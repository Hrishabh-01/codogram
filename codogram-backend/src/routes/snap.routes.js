import { Router } from "express";
import {
    createSnap,
    viewSnap
} from "../controllers/snap.controller.js";
import {upload} from "../middlewares/multer.middleware.js";
import { verifyJWT } from "../middlewares/auth.middleware.js";

const router =Router();

router.route("/").post(
    verifyJWT,
    upload.single("media"),
    createSnap
)

router.put("/:snapId/view", verifyJWT, viewSnap);
export default router;