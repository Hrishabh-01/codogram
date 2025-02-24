import { Router } from "express";
import {
    likePost,
    toggleCommentLike,
    getLikedPost,
    getLikedComments
} from "../controllers/like.controller.js"
import { verifyJWT } from "../middlewares/auth.middleware.js";

const router =Router();

router.use(verifyJWT);// Apply verifyJWT middleware to all routes in this file

router.route("/toggle/p/:postId").post(likePost);
router.route("/toggle/c/:commentId").post(toggleCommentLike);
router.route("/posts").get(getLikedPost);
router.route("/comments").get(getLikedComments);

export default router