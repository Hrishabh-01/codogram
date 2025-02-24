import mongoose,{isValidObjectId} from "mongoose";
import {asyncHandler} from "../utils/asyncHandler.js";
import {ApiError} from "../utils/ApiError.js";
import {User} from "../models/user.model.js"
import { ApiResponse } from "../utils/ApiResponse.js";
import { Post } from "../models/post.model.js";
import {Like} from "../models/like.model.js";
import {Comment} from "../models/comment.model.js"

const likePost =asyncHandler(async(req,res)=>{

    //get post that needs to be liked
    //check if post exist
    //check if the post is already liked by you or not
    //if liked remove the like
    //otherwise like the post 
    //return the response with pdated like count

    const {postId} = req.params
    const userId =req.user._id
    
    if (!userId) {
        throw new ApiError(401, "User not authenticated.");
    }
    if(!isValidObjectId(postId)){
        throw new ApiError(400,"Invalid Post ID");
    }

    const post =await Post.findById(postId);
    if(!post){
        throw new ApiError(404 ,"Post not found");
    } 

    const existingLike =await Like.findOne({post:postId,likedBy:userId});

    if(existingLike){
        //unlike
        await Like.findByIdAndDelete(existingLike._id);
        return res
        .status(200)
        .json(
            new ApiResponse(
                200,"Post Unliked Succesflly"
            )
        )
    }
    const like = await Like.create({
        post:postId,
        likedBy:userId
    })
    return res
        .status(200)
        .json(
            new ApiResponse(
                200,like,"Post liked Succesflly"
            )
        )

})
const toggleCommentLike=asyncHandler(async(req,res)=>{
    //get comment that needs to be liked
    //check if comment exist
    //check if the comment is already liked by you or not
    //if liked remove the like
    //otherwise like the comment 
    //return the response with updated like count
    const {commentId} = req.params
    const userId =req.user?._id

    if(!isValidObjectId(commentId)){
        throw new ApiError(400,"Invalid Commnet ID");
    }

    const comment =await Comment.findById(commentId);
    if(!comment){
        throw new ApiError(404 ,"Comment not found");
    } 

    const existingLike =await Like.findOne({comment:commentId,likedBy:userId});

    if(existingLike){
        //unlike
        await Like.findByIdAndDelete(existingLike._id);
        return res
        .status(200)
        .json(
            new ApiResponse(
                200,"Comment Unliked Succesflly"
            )
        )
    }
    await Like.create({
        comment:commentId,
        likedBy:userId
    })
    return res
        .status(200)
        .json(
            new ApiResponse(
                200,"Comment liked Succesflly"
            )
        )

})
const getLikedPost=asyncHandler(async(req,res)=>{
    const userId = req.user._id;

    const likedPosts = await Like.find({ likedBy: userId, post: { $ne: null } }).populate("post");

    res.status(200).json(new ApiResponse(200, "Liked posts retrieved successfully", likedPosts));
})
const getLikedComments = asyncHandler(async (req, res) => {
    const userId = req.user._id;

    const likedComments = await Like.find({ likedBy: userId, comment: { $ne: null } }).populate("comment");

    res.status(200).json(new ApiResponse(200, "Liked comments retrieved successfully", likedComments));
});

export{
    likePost,
    toggleCommentLike,
    getLikedPost,
    getLikedComments
}