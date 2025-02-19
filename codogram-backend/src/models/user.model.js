import mongoose,{Schema} from "mongoose";
import jwt from "jsonwebtoken" //jwt is bearer token , jiske pass token voh hi sahi h
import bcrypt from "bcrypt"

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
        coverImage:{
            type:String,//cloudinary url
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

userSchema.pre("save",async function (next){
    if(!this.isModified("password"))return next();// password change na hua h toh kyu hi ese encrypt kre

    this.password=await bcrypt.hash(this.password, 10)
    next()
})//it is a hook or middleware

userSchema.methods.isPasswordCorrect = async function
(password){
    return await bcrypt.compare(password,this.password)
}

userSchema.methods.generateAccessToken =function(){
    return jwt.sign
    (
    {
        _id:this._id,
        email:this.email,
        username:this.username,
        fullname:this.fullname
    },
    process.env.ACCESS_TOKEN_SECRET,
    {
        expiresIn:process.env.ACCESS_TOKEN_EXPIRY
    }
    )
}
userSchema.methods.generateRefreshToken =function(){
    return jwt.sign({
        _id:this._id,
    },
    process.env.REFRESH_TOKEN_SECRET,
    {
        expiresIn:process.env.REFRESH_TOKEN_EXPIRY
    }
)
}

export const User = mongoose.model("User",userSchema)

