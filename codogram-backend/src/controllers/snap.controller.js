import { asyncHandler } from "../utils/asyncHandler.js";
import { ApiError } from "../utils/ApiError.js";
import { ApiResponse } from "../utils/ApiResponse.js";
import { User } from "../models/user.model.js";
import { uploadOnCloudinary } from "../utils/cloudinary.js";
import { Snap } from "../models/snap.model.js";

const createSnap = asyncHandler(async (req, res) => {
    const {reciever , duration} = req.body;
    const sender = req.user._id;

    if(!reciever){
        throw new ApiError(400,"Reciever is required!!!")
    }
    if(!duration){
        throw new ApiError(400,"Duration is required!!!")
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
        reciever,
        sendSnap,
        duration
    })
})

const viewSnap = asyncHandler(async (req, res) => {
    const { snapId } = req.params;
    if (!snapId) throw new ApiError(400, "Snap id is required");

    const snap = await Snap.findByIdAndUpdate(snapId, { isViewed: true });
    if (!snap) throw new ApiError(404, "Snap not found");

    return res.status(200).json(new ApiResponse(200, snap, "Snap viewed"));
});

export{
    createSnap,
    viewSnap
}
