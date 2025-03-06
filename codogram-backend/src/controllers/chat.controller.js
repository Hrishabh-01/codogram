import { asyncHandler } from "../utils/asyncHandler.js";
import { ApiError } from "../utils/ApiError.js";
import { ApiResponse } from "../utils/ApiResponse.js";
import { User } from "../models/user.model.js";
import { uploadOnCloudinary } from "../utils/cloudinary.js";
import { Message } from "../models/message.model.js";
import { Chat } from "../models/chat.model.js";

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
      .populate("lastMessage");

    if (!chat) {
        chat = await Chat.create({
            isGroup: false,
            participants: [loggedInUser, userId],
        });

        await chat.populate("participants", "-password");
    }
    console.log(`chat id : `,chat);
    
    return res.status(200).json(new ApiResponse(200, chat, "Chat accessed successfully"));
});

// Create a group chat with image upload
const createGroupChat = asyncHandler(async (req, res) => {
    console.log("req.body:", req.body);
    console.log("req.file:", req.file);
    const { groupName,participantIds } = req.body;
    const loggedInUser = req.user._id;

    if(!groupName){
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

    return res.status(200).json(new ApiResponse(200, messages, "Messages retrieved successfully"));
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


export { accessChat, createGroupChat, sendMessage, getMessages, deleteMessage,markMessagesAsRead };
