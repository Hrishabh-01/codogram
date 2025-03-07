import mongoose, { Schema } from "mongoose";


const snapSchema = new Schema(
    {
        sender: {
            type: Schema.Types.ObjectId,
            ref: "User",
            required: true,
        },
        receiver: {
            type: Schema.Types.ObjectId,
            ref: "User",
            required: true,
        },
        media: {
            type: String, // Cloudinary URL for image/video
            required: true,
            trim: true,
        },
        duration: {
            type: Number,
            default: 10, // Snap disappears after 10 seconds
        },
        isViewed: {
            type: Boolean,
            default: false,
        },
        expiresAt: {
            type: Date,
            default: () => new Date(Date.now() + 24 * 60 * 60 * 1000),
            index: true,
        },
    },
    { timestamps: true } // Automatically adds createdAt and updatedAt
);

snapSchema.index({ expiresAt: 1 }, { expireAfterSeconds: 0 }); // Auto-delete after expiration

export const Snap = mongoose.model("Snap", snapSchema);
