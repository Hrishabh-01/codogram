import {asyncHandler} from "../utils/asyncHandler.js";
import {ApiError} from "../utils/ApiError.js";
import {User} from "../models/user.model.js"
import {uploadOnCloudinary} from "../utils/cloudinary.js";
import { ApiResponse } from "../utils/ApiResponse.js";
// import jwt from "jsonwebtoken"; 
import { Post } from "../models/post.model.js";
import { Follow } from "../models/follower.model.js";

 const createPost = asyncHandler(async(req,res)=>{
    //get post details from frontend
    //validation- not empty
    //check for images
    //check for avatar
    //upload them to cloudinary,avatar
    //create post object - create entry in db
    //remove password and refresh token field from response
    //check for post creation
    //return res

    const {title,description,tags,isPublic}=req.body;
    console.log("title : ",title);

    if([title,description].some((field)=>field?.trim()==="")){
        throw new ApiError(400,"Title and Description are required!")
    }
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

    //get user info from req
    const user=req.user;

    const post =await Post.create({
        user:user._id,
        title,
        description,
        media:mediaUrls,
        // codeSnippet,
        tags,
        isPublic,
    }) 
    console.log("post : ",post);
    const createdPost=await Post.findById(post._id).select("-password -refreshToken");
    console.log("createdPost : ",createdPost);

    if(!createdPost){
        throw new ApiError(500,"failed to create post")
    }
    return res.status(201).json(
        new ApiResponse(
            200,
            createdPost,
            "Post created successfully",
        )
    )


 })

const deletePost = asyncHandler(async(req,res)=>{
    //get post id from req
    //get user info from req
    //find post by id
    //check if post exists
    //check if user is the owner of the post
    //delete post
    //return res

    const {postId}=req.params;
    const user=req.user;
    const post=await Post.findById(postId);
    if(!post){
        throw new ApiError(404,"Post not found")
    }
    if(post.user.toString()!==user._id.toString()){
        throw new ApiError(403,"You are not authorized to delete this post")
    }
    await Post.findByIdAndDelete(postId);
    return res.status(200).json(
        new ApiResponse(
            200,
            {},
            "Post deleted successfully",
        )
    ) 

})

const getFeed = asyncHandler(async(req,res)=>{
    //get user id from req
    //get user following list
    //get posts from users in following list
    //return res

    const user=req.user;
    const { page = 1, limit = 10 } = req.query; // Pagination params
    const skip = (page - 1) * limit;

    const followingList = await Follow.find({ follower: user._id }).select("following");
    const followingUserIds = followingList.map(follow => follow.following);

    console.log("Following User IDs: ", followingUserIds);

    if (followingUserIds.length === 0) {
        throw new ApiError(404, "You are not following anyone");
    }

    const feedPosts =await Post.aggregate(
        [
            {
                $match:{
                    $or:[
                        {user:{
                            $in:followingUserIds 
                        }},
                        {isPublic:true}
                    ]
                }
            },
            {
                $sort:{
                    createdAt:-1
                }
            },
            {
                $skip: skip
            },
            {
                $limit: Number(limit)
            },
            {
                $lookup:{
                    from:"users",
                    localField:"user",
                    foreignField:"_id",
                    as:"user"
                }
            },
            {
                $unwind:"$user"
            },
            {
                $project:{
                    _id: 1,
                    title: 1,
                    description: 1,
                    media: 1,
                    tags: 1,
                    isPublic: 1,
                    createdAt: 1,
                    "user._id": 1,
                "user.username": 1,
                "user.avatar": 1
                }
            }

        ]
    );
    return res.status(200).json(
        new ApiResponse(200, feedPosts, "Feed fetched successfully")
    );

})
 export {createPost,deletePost,getFeed}