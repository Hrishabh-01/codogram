import { Router } from "express";

import {upload} from "../middlewares/multer.middleware.js";
import { verifyJWT } from "../middlewares/auth.middleware.js";
import { createPost,deletePost,getFeed } from "../controllers/post.controller.js";

const router=Router();

router.route("/create-post").post(
    verifyJWT,
    upload.fields([
        {
            name: "media",
            maxCount: 3
        }
    ]),
    createPost
)
//secure route
router.route("/delete-post/:postId").delete(
    verifyJWT,
    deletePost
)
router.route("/feed").get(
    verifyJWT,
    getFeed
)

export default router;