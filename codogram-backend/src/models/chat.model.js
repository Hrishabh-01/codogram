import mongoose, { Schema } from "mongoose";

const chatSchema = new Schema({
  isGroup: {
    type: Boolean,
    default: false,
  }, // True for group chats, false for direct messages
  participants: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
    },
  ], // Users involved in the chat
  groupName: {
    type: String,
  }, // Name for group chats
  groupImage: {
    type: String,
  }, // Group chat profile image
  lastMessage: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Message",
  }, // Store the last message for efficient retrieval
  snaps: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Snap",
    },
  ],
  // streak: {
  //   type: mongoose.Schema.Types.ObjectId,
  //   ref: "Streak",
  // },
  typingUsers: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
    },
  ],
}, { timestamps: true });

chatSchema.index({ participants: 1 }); // Optimize queries for user chats

export const Chat = mongoose.model("Chat", chatSchema);
