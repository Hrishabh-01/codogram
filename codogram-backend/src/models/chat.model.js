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
  messageStatus: {
    type: Map,
    of: {
      seen: { type: Boolean, default: false },
      delivered: { type: Boolean, default: false },
      sent: { type: Boolean, default: true },
    },
  },
  expiresAt: {
    type: Date,
    default: () => new Date(Date.now() + 24 * 60 * 60 * 1000),
    index: true,
  },
}, { timestamps: true });

chatSchema.index({ participants: 1 }); // Optimize queries for user chats
chatSchema.index({ expiresAt: 1 }, { expireAfterSeconds: 0 });

export const Chat = mongoose.model("Chat", chatSchema);
