import {asyncHandler} from "../utils/asyncHandler.js";
import {ApiError} from "../utils/ApiError.js";
import {User} from "../models/user.model.js"
import { ApiResponse } from "../utils/ApiResponse.js";
// import jwt from "jsonwebtoken"; 
import { Post } from "../models/post.model.js";
import {Comment} from "../models/comment.model.js"

const getPostComments = asyncHandler(async (req,res)=>{
    const {postId} = req.params
    const {page = 1,limit=10}=req.query

    const postExist=await Post.findById(postId)
    if(!postExist){
        throw ApiError(404,"Post not found")
    }

    // Fetch comments using pagination
    const options ={
        page: parseInt(page, 10),
        limit: parseInt(limit, 10),
        populate: [{ path: "owner", select: "name email" }],
        sort: { createdAt: -1 } // Newest first
    };

    const comments = await Comment.aggregatePaginate(
        Comment.aggregate([
            {
                $match :{
                    post:postExist._id
                }
            }
        ]),
        options
    )
    return res
    .status(200)
    .json(new ApiResponse(200, comments, "Comments fetched successfully"));
})
const addComment = asyncHandler(async (req, res) => {
    const { postId } = req.params;
    const { content } = req.body;
    const userId = req.user._id; // Assuming user is authenticated
    
    console.log("User Info:", req.user);
    console.log("Post ID:", req.params.postId);
    console.log("id:",userId)

    if (!content) {
        throw new ApiError(400, "Comment content is required");
    }

    const postExists = await Post.findById(postId);
    if (!postExists) {
        throw new ApiError(404, "Post not found");
    }

    const comment = await Comment.create({
        content,
        post: postExists._id,
        owner: userId
    });
    const populatedComment = await Comment.findById(comment._id).populate("owner", "username");

    res.status(201).json(new ApiResponse(201, populatedComment, "Comment added successfully"));
})

const updateComment = asyncHandler(async (req, res) => {
    const { commentId } = req.params;
    const { content } = req.body;
    const userId = req.user._id;

    const comment = await Comment.findById(commentId);
    if (!comment) {
        throw new ApiError(404, "Comment not found");
    }

    if (comment.owner.toString() !== userId.toString()) {
        throw new ApiError(403, "Unauthorized to update this comment");
    }

    comment.content = content;
    await comment.save();

    res.status(200).json(new ApiResponse(200, comment, "Comment updated successfully"));
})

const deleteComment = asyncHandler(async (req, res) => {
    const { commentId } = req.params;
    const userId = req.user._id;

    const comment = await Comment.findById(commentId);
    if (!comment) {
        throw new ApiError(404, "Comment not found");
    }

    if (comment.owner.toString() !== userId.toString()) {
        throw new ApiError(403, "Unauthorized to delete this comment");
    }

    await comment.deleteOne();

    res.status(200).json(new ApiResponse(200, {}, "Comment deleted successfully"));
})
export {
    getPostComments, 
    addComment, 
    updateComment,
    deleteComment
}