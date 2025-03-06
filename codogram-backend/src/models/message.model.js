import mongoose, { Schema } from "mongoose";

const messageSchema = new Schema({
    chat: { 
        type: mongoose.Schema.Types.ObjectId, 
        ref: "Chat", 
        required: true 
    }, // Reference to the chat
    sender: { 
        type: mongoose.Schema.Types.ObjectId, 
        ref: "User", 
        required: true 
    }, // Who sent the message
    content: { 
        type: String, 
        required: true 
    }, // Message text
    messageType: { 
        type: String, 
        enum: ["text", "image", "video", "file"], 
        default: "text" 
    }, // Type of message
    mediaUrl: { 
        type: String, 
        default: null 
    }, // URL for media files (if applicable)
    readBy: [
        { 
            type: mongoose.Schema.Types.ObjectId, 
            ref: "User" 
        }
    ], // Users who have read the message
    deletedFor: [
        { 
            type: mongoose.Schema.Types.ObjectId, 
            ref: "User" 
        }
    ], // Users who deleted the message (soft delete)
}, { timestamps: true });

export const Message = mongoose.model("Message", messageSchema);
