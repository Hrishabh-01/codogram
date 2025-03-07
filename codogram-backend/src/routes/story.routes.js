import { Router } from "express";

import {upload} from "../middlewares/multer.middleware.js";
import { verifyJWT } from "../middlewares/auth.middleware.js";
import { 
    createStory,
    fetchStories,
    viewStory,
    deleteStory  } from "../controllers/story.controller.js";
 const router = Router();
    router.route("/create-story").post(
        verifyJWT,
        upload.fields([
            {
                name: "media",
                maxCount: 3
            }
        ]),
        createStory
    )
//secure route
// Fetch stories
router.get("/fetchStories", verifyJWT, fetchStories);

// View a story (Consider using PATCH instead of POST)
router.patch("/:storyId/view", verifyJWT, viewStory);

// Delete a story
router.delete("/:storyId", verifyJWT, deleteStory);
    
export default router;