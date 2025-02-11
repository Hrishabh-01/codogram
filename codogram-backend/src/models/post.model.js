import mongoose,{Schema} from "mongoose";
import mongooseAggregatePaginate from "mongoose-aggregate-paginate-v2"

const postSchema=new Schema(
    {
        user:{
            type: Schema.Types.ObjectId,
            ref: "User", // Links the post to its creator
            required: true
        },
        title:{
            type:String,
            trim: true,
            required:true
        },
        description:{
            type:String,
            required:true,
        },
        media: [{
            type: String, // Array of media URLs (images/videos)
            required: true
        }],
        duration:{
            type:Number,
            default:0
        },
        codeSnippet: {
            language: { type: String, trim: true }, // e.g., "JavaScript", "Python"
            content: { type: String, trim: true }, // The actual code snippet
        },
        likes: [{
            type: Schema.Types.ObjectId,
            ref: "User" // Stores user IDs who liked the post
        }],
        comments: [{
            user: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
            text: { type: String, required: true },
            created_at: { type: Date, default: Date.now }
        }],
        tags: [{
            type:String,
        }], // Hashtags or mentions (e.g., ["#JavaScript", "#OpenSource"])
        isPublic: {
            type: Boolean,
            default: true // Public post by default
        }
    },{timestamps:true})

postSchema.plugin(mongooseAggregatePaginate)

export const Post=mongoose.model("Post",postSchema)