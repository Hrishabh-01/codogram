import mongoose, { Schema } from "mongoose";

const streakSchema = new Schema(
    {
        users: [
            {
                type: Schema.Types.ObjectId,
                ref: "User",
                required: true,
            }
        ],
        count: {
            type: Number,
            default: 1, // Streak starts at 1
        },
        lastSnapAt: {
            type: Date,
            required: true,
        },
        
    },
    { timestamps: true }
);
streakSchema.pre("save", function (next) {
    this.users = this.users.sort(); // Ensure consistent order
    next();
});


// Index for fast retrieval of streaks between users
streakSchema.index({ users: 1 }, { unique: true });

export const Streak = mongoose.model("Streak", streakSchema);
