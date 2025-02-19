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
        media: {
            type:[String],
            required:true,
            default:[]
        },
        // duration:{
        //     type:Number,
        //     default:0
        // },
        // codeSnippet: {
        //     language: { type: String, trim: true,default: null }, // e.g., "JavaScript", "Python"
        //     content: { type: String, trim: true,default: null }, // The actual code snippet
        //     default:null
        // },
        tags: [{
            type:String,
            trim: true,
        }], // Hashtags or mentions (e.g., ["#JavaScript", "#OpenSource"])
        isPublic: {
            type: Boolean,
            default: true // Public post by default
        }
    },{timestamps:true})

postSchema.plugin(mongooseAggregatePaginate)

export const Post=mongoose.model("Post",postSchema)