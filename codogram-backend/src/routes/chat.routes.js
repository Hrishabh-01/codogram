import { Router } from "express";
import {
    accessChat, 
    getChats,
    createGroupChat, 
    sendMessage, 
    getMessages, 
    deleteMessage,
    markMessagesAsRead
} from "../controllers/chat.controller.js";
import {upload} from "../middlewares/multer.middleware.js";
import { verifyJWT } from "../middlewares/auth.middleware.js";


const router =Router();

// ✅ Route to create/fetch an individual chat
router.post("/access", verifyJWT, accessChat);

// ✅ Route to fetch all chats
router.get("/fetch", verifyJWT, getChats);

// ✅ Route to create a group chat
router.post("/group",
    upload.single("groupImage"),
    verifyJWT, createGroupChat);

// ✅ Route to send a message
router.post("/message", verifyJWT, sendMessage);

// ✅ Route to get all messages in a chat
router.get("/:chatId", verifyJWT, getMessages);

// ✅ Route to delete a message (soft delete)
router.delete("/message/:messageId", verifyJWT, deleteMessage);

// ✅ Route to mark messages as read
router.put("/:chatId/read", verifyJWT, markMessagesAsRead);

export default router;