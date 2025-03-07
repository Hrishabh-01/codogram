import { asyncHandler } from "../utils/asyncHandler.js";
import { ApiError } from "../utils/ApiError.js";
import { ApiResponse } from "../utils/ApiResponse.js";
import { User } from "../models/user.model.js";
import { uploadOnCloudinary } from "../utils/cloudinary.js";
import { Story } from "../models/story.model.js";
import { Follow } from "../models/follower.model.js";

const createStory = asyncHandler(async(req,res)=>{
    const user = req.user;
    const {duration} = req.body;

    if (!req.files?.media || req.files.media.length === 0) {
        throw new ApiError(400, "Media not found");
    }

    // Upload each media file to Cloudinary and store URLs
    const mediaUrls = [];
    for (const file of req.files.media) {
        const uploadedMedia = await uploadOnCloudinary(file.path);
        if (uploadedMedia?.secure_url) {
            mediaUrls.push(uploadedMedia.secure_url);
        }
    }


    if (mediaUrls.length === 0) {
        throw new ApiError(500, "Failed to upload media");
    }
    const story = await Story.create({
        user:user._id,
        media:mediaUrls,
        duration:duration || 15,
        
    })
    console.log("story : ",story);
        const createdStory=await Story.findById(story._id).select("-password -refreshToken");
        console.log("createdStory : ",createdStory);
    
        if(!createdStory){
            throw new ApiError(500,"failed to create story")
        }
        return res.status(201).json(
            new ApiResponse(
                200,
                createdStory,
                "Story created successfully",
            )
        )

})
const fetchStories = asyncHandler(async (req, res) => {
    const user = req.user;

    // Fetch the users that the current user follows
    const followingList = await Follow.find({ follower: user._id }).select("following");
    const followingUserIds = followingList.map(follow => follow.following); // Extract user IDs

    if (followingUserIds.length === 0) {
        return res.status(200).json(new ApiResponse(200, [], "No stories available"));
    }

    console.log("Following User IDs: ", followingUserIds);

    const stories = await Story.aggregate([
        {
            $match: {
                user: { $in: followingUserIds },
            },
        },
        {
            $sort: { createdAt: -1 },
        },
        {
            $lookup: {
                from: "users",
                localField: "user",
                foreignField: "_id",
                as: "user",
            },
        },
        {
            $unwind: "$user" // Flatten the user array
        },
        {
            $project: {
                media: 1,
                createdAt: 1,
                "user._id": 1,
                "user.username": 1,
                "user.avatar": 1
            }
        }
    ]);

    return res
    .status(200)
    .json(new ApiResponse(
        200, 
        stories, 
        "Stories retrieved successfully"
    ));
});
const viewStory = asyncHandler(async(req,res)=>{
    const { storyId } = req.params;
    const userId = req.user._id;

    const story = await Story.findById(storyId);
    if (!story) {
        throw new ApiError(404, "Story not found");
    }

    // Add viewer only if not already viewed
    if (!story.viewers.includes(userId)) {
        story.viewers.push(userId);
        await story.save();
    }

    return res.status(200).json(new ApiResponse(200, {}, "Story marked as viewed"));
})
const deleteStory   = asyncHandler(async(req,res)=>{
    const { storyId } = req.params;
    const userId = req.user._id;

    const story = await Story.findOneAndDelete({ _id: storyId, user: userId });
    if (!story) {
        throw new ApiError(404, "Story not found or unauthorized");
    }

    return res.status(200).json(new ApiResponse(200, {}, "Story deleted successfully"));
})

export {
    createStory,
    fetchStories,
    viewStory,
    deleteStory 
}
