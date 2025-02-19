import mongoose,{Schema} from "mongoose";
import { User } from "./user.model.js";

const followSchema = new Schema({
    followers:[
        {
            type:mongoose.Schema.Types.ObjectId,//one who is following
            ref:"User" 
        }
    ],
    following:[
        {
            type:mongoose.Schema.Types.ObjectId,//one to whom 
            // follower is  following
            ref:"User"
        }
    ]
},{timestamps:true})


export const Follow = mongoose.model
("Follow",followSchema);