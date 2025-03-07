// import mongoose, { Schema } from "mongoose";

// // const STREAK_EXPIRATION_HOURS = process.env.STREAK_EXPIRATION_HOURS || 24; // Default 24 hours

// const streakSchema = new Schema(
//     {
//         users: [
//             {
//                 type: Schema.Types.ObjectId,
//                 ref: "User",
//                 required: true,
//             }
//         ],
//         count: {
//             type: Number,
//             default: 1, // Streak starts at 1
//         },
//         lastSnapAt: {
//             type: Date,
//             required: true,
//         },
        
//     },
//     { timestamps: true }
// );

// // Index for fast retrieval of streaks between users
// streakSchema.index({ users: 1 }, { unique: true });

// export const Streak = mongoose.model("Streak", streakSchema);
