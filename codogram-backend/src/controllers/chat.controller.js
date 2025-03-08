import { asyncHandler } from "../utils/asyncHandler.js";
import { ApiError } from "../utils/ApiError.js";
import { ApiResponse } from "../utils/ApiResponse.js";
import { User } from "../models/user.model.js";
import { uploadOnCloudinary } from "../utils/cloudinary.js";
import { Message } from "../models/message.model.js";
import { Chat } from "../models/chat.model.js";
import { Snap } from "../models/snap.model.js";
import { Streak } from "../models/streak.model.js"; // Import Streak Model

let io; // Socket instance

export const setSocketInstance = (socketInstance) => {
    io = socketInstance;
};

// Create or fetch an individual chat
const accessChat = asyncHandler(async (req, res) => {
    const { userId } = req.body;
    const loggedInUser = req.user._id;

    if (!userId) {
        throw new ApiError(400, "User ID is required");
    }

    let chat = await Chat.findOne({
        isGroup: false,
        participants: { $all: [loggedInUser, userId] },
    }).populate("participants", "-password")
      .populate("lastMessage")
      .populate("snaps");

    if (!chat) {
        chat = await Chat.create({
            isGroup: false,
            participants: [loggedInUser, userId],
        });

        await chat.populate("participants", "-password");
    }

    // Fetch Streak Count using Aggregation Pipeline
    const streakData = await Streak.aggregate([
        { $match: { users: { $all: [loggedInUser, userId] } } },
        { $project: { _id: 0, count: 1 } }
    ]);
    const streakCount = streakData.length > 0 ? streakData[0].count : 0;
    
    return res.status(200).json(new ApiResponse(200, { chat, streakCount }, "Chat accessed successfully"));
});

// Fetch all chats for the logged-in user
const getChats = asyncHandler(async (req, res) => {
    const loggedInUser = req.user._id;

    // Fetch all chats where the logged-in user is a participant
    let chats = await Chat.find({ participants: loggedInUser })
        .populate("participants", "-password")
        .populate("lastMessage")
        .populate("snaps")
        .sort({ updatedAt: -1 });

    // Fetch Streak Counts for Each Chat
    const streakData = await Streak.find({ users: loggedInUser });

    // Map streak counts to corresponding chats
    const streakMap = {};
    streakData.forEach(({ users, count }) => {
        const otherUser = users.find((user) => user.toString() !== loggedInUser.toString());
        if (otherUser) {
            streakMap[otherUser.toString()] = count;
        }
    });
    console.log("Chats:", chats);
    console.log("Streak Data:", streakData);


    // Attach streak count to each chat
    chats = chats.map(chat => {
        if (!chat.isGroup) {
            const otherUserId = chat.participants.find(p => p._id.toString() !== loggedInUser.toString())?._id.toString();
            return {
                ...chat.toObject(),
                streakCount: streakMap[otherUserId] || 0
            };
        }
        return chat.toObject();
    });
    

    return res.status(200).json(new ApiResponse(200, chats, "Chats retrieved successfully"));
});

// Create a group chat with image upload
const createGroupChat = asyncHandler(async (req, res) => {
    const { groupName, participantIds } = req.body;
    const loggedInUser = req.user._id;

    if (!groupName || !groupName.trim()) {
        throw new ApiError(400, "Group name is required");
    }

    if (!Array.isArray(participantIds)) {
        participantIds = participantIds ? [participantIds] : [];
    }
    

    // Check if a group with the same name and participants already exists
    const existingGroup = await Chat.findOne({
        isGroup: true,
        groupName,
        participants: { $size: participantIds.length + 1, $all: [...participantIds, loggedInUser] },
    });

    if (existingGroup) {
        throw new ApiError(400, "A group with the same participants already exists");
    }

    let uploadedImage = null;
    if (req.file) {
        const uploadResult = await uploadOnCloudinary(req.file.path);
        if (!uploadResult) {
            throw new ApiError(500, "Failed to upload image to Cloudinary");
        }
        uploadedImage = uploadResult.secure_url;
    }

    const groupChat = await Chat.create({
        isGroup: true,
        groupName,
        groupImage: uploadedImage || "",
        participants: [...participantIds, loggedInUser],
    });

    await groupChat.populate("participants", "-password");

    return res.status(201).json(new ApiResponse(201, groupChat, "Group chat created successfully"));
});

// Send a message
const sendMessage = asyncHandler(async (req, res) => {
    const { chatId, content, messageType, mediaUrl } = req.body;
    const sender = req.user._id;

    if (!chatId || !content || content.trim().length === 0) {
        throw new ApiError(400, "Chat ID and non-empty content are required");
    }

    const message = await Message.create({
        chat: chatId,
        sender,
        content,
        messageType,
        mediaUrl,
    });

    await Chat.findByIdAndUpdate(chatId, { lastMessage: message._id });

    const populatedMessage = await Message.findById(message._id)
        .populate("sender", "username avatar")
        .populate("chat");

    // Emit real-time message event
    io.to(chatId).emit("new-message", populatedMessage);
    return res.status(201).json(new ApiResponse(201, populatedMessage, "Message sent successfully"));
});

// Fetch messages from a chat
const getMessages = asyncHandler(async (req, res) => {
    const { chatId } = req.params;
    const userId = req.user._id;

    if (!chatId) {
        throw new ApiError(400, "Chat ID is required");
    }

    const messages = await Message.find({
        chat: chatId,
        deletedFor: { $ne: userId }, // Exclude messages deleted for this user
    })
        .populate("sender", "username avatar")
        .populate("chat");

    const snaps = await Snap.find({ chatId, receiver: userId, isViewed: false });

    return res.status(200).json(new ApiResponse(200, { messages, snaps }, "Messages and snaps retrieved successfully"));
});

// Soft delete a message
const deleteMessage = asyncHandler(async (req, res) => {
    const { messageId } = req.params;
    const userId = req.user._id;

    const message = await Message.findById(messageId);
    if (!message) {
        throw new ApiError(404, "Message not found");
    }

    // Soft delete for the user
    await Message.findByIdAndUpdate(messageId, { $addToSet: { deletedFor: userId } });

    // Emit real-time message deletion
    io.emit("message-deleted", { messageId, userId });

    return res.status(200).json(new ApiResponse(200, {}, "Message deleted successfully"));
});

// Mark messages as read
const markMessagesAsRead = asyncHandler(async (req, res) => {
    const { chatId } = req.params;
    const userId = req.user._id;

    if (!chatId) {
        throw new ApiError(400, "Chat ID is required");
    }

    // Update all messages in the chat by adding the user to the `readBy` array
    await Message.updateMany(
        { chat: chatId, readBy: { $ne: userId } },
        { $addToSet: { readBy: userId } }
    );
    io.to(chatId).emit("messages-read", { chatId, userId });
    return res.status(200).json(new ApiResponse(200, {}, "Messages marked as read"));
});

export { accessChat, getChats, createGroupChat, sendMessage, getMessages, deleteMessage, markMessagesAsRead };
