import mongoose,{Schema} from "mongoose";

const userSchema = new Schema(
    {
        username:{
            type:String,
            required:true,
            unique:true,
            lowercase:true,
            trim:true,
            index:true//to make any field searchable
        },
        email:{
            type:String,
            required:true,
            unique:true,
            lowercase:true,
            trim:true,
        },
        fullname:{
            type:String,
            required:true,
            trim:true,
            index:true
        },
        avatar:{
            type:String,//cloudinary url
            required:true,
        },
        bio:{
            type:String,
        },
        skills:{
            type:[String],
            default:[]
        },
        snap_score:{
            type:Number,
            default:0
        },
        friend_list:[{
            type: mongoose.Schema.Types.ObjectId,
            ref: "User" // Reference to other users
        }],
        password:{
            type:String,
            required:[true,"Password is required"],
        },

        refreshToken:{
            type:String,
            default:"",
        },
    },{timestamps:true}// Automatically adds createdAt and updatedAt timestamps
)

export const User = mongoose.model("User",userSchema)

