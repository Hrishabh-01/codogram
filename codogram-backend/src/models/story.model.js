import mongoose from "mongoose";
import mongooseAggregatePaginate from "mongoose-aggregate-paginate-v2"

const storySchema = new mongoose.Schema({
    user: { 
        type: mongoose.Schema.Types.ObjectId, 
        ref: "User", 
        required: true 
    },
    media: { 
        type: [String], // URL of image/video
        required: true 
    },
    duration: { 
        type: Number, 
        default: 15 // Story lasts for 15 seconds by default
    },
    viewers: [{ 
        type: mongoose.Schema.Types.ObjectId, 
        ref: "User" 
    }] // Users who viewed the story
}, { 
    timestamps: true // Automatically adds `createdAt`
});

// ✅ TTL Index on `createdAt` for automatic deletion after 24 hours
storySchema.index({ createdAt: 1 }, { expireAfterSeconds: 86400 }); // 24 hours = 86400 seconds
storySchema.plugin(mongooseAggregatePaginate)

export const Story = mongoose.model("Story", storySchema);
