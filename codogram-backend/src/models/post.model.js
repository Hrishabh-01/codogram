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