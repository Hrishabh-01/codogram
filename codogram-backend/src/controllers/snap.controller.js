import { asyncHandler } from "../utils/asyncHandler.js";
import { ApiError } from "../utils/ApiError.js";
import { ApiResponse } from "../utils/ApiResponse.js";
import { User } from "../models/user.model.js";
import { uploadOnCloudinary } from "../utils/cloudinary.js";
import { Snap } from "../models/snap.model.js";
import { Streak } from "../models/streak.model.js";
import { Chat } from "../models/chat.model.js";


const createSnap = asyncHandler(async (req, res) => {
    const {receiver , duration,chatId} = req.body;
    const sender = req.user._id;

    if(!receiver){
        throw new ApiError(400,"receiver is required!!!")
    }
    if(!duration){
        throw new ApiError(400,"Duration is required!!!")
    }
    if(!chatId){
        throw new ApiError(400,"chatId is required!!!")
    }
    if (!req.file) {
        throw new ApiError(400, "Snap media is required");
    }
    const snapLocalPath = req.file.path;
    console.log("snapLocalPath : ",snapLocalPath);

    if(!snapLocalPath){
            throw new ApiError(400,"Snap is required!!!")
        }
    
    const sendSnap = await uploadOnCloudinary(snapLocalPath)
    console.log("sendSnap : ",sendSnap); 
    if (!sendSnap) {
        throw new ApiError(500, "Failed to upload media");
    }
    const snap = await Snap.create({
        sender,
        receiver,
        media : sendSnap.url,
        chatId,
        duration
    })

    await Chat.findByIdAndUpdate(chatId, { $push: { snaps: snap._id } });

    // Streak Handling
    const streak = await Streak.findOne({ users: { $all: [sender, receiver] } });
    if (streak) {
        const lastSnapTime = new Date(streak.lastSnapAt);
        const currentTime = new Date();
        const hoursDifference = (currentTime - lastSnapTime) / (1000 * 60 * 60);

        if (hoursDifference <= 24) {
            streak.count += 1;
        } else {
            streak.count = 1; // Reset if no snap in 24 hours
        }
        streak.lastSnapAt = currentTime;
        await streak.save();
    } else {
        await Streak.create({ users: [sender, receiver], lastSnapAt: new Date() });
    }
    return res.status(201).json(new ApiResponse(201, snap, "Snap created successfully"));

})

const viewSnap = asyncHandler(async (req, res) => {
    const { snapId } = req.params;
    if (!snapId) throw new ApiError(400, "Snap id is required");

    const snap = await Snap.findByIdAndUpdate(snapId, { isViewed: true }, { new: true });
    if (!snap) throw new ApiError(404, "Snap not found");

    return res.status(200).json(new ApiResponse(200, snap, "Snap viewed"));
});

export{
    createSnap,
    viewSnap
}
