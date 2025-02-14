import {asyncHandler} from "../utils/asyncHandler.js";
import {ApiError} from "../utils/ApiError.js";
import {User} from "../models/user.model.js"
import {uploadOnCloudinary} from "../utils/cloudinary.js";
import { ApiResponse } from "../utils/ApiResponse.js";

const generateAccessAndRefreshToken=async(userId)=>{
    try{
        const user = await User.findById(userId)
        const accessToken = user.generateAccessToken()
        const refreshToken = user.generateRefreshToken()

        user.refreshToken = refreshToken//to save the refresh token in db
        await user.save({validateBeforeSave:false})//to save the refresh token in db


        return {accessToken,refreshToken}

    }catch(error){
        throw new ApiError(500,"Failed to generate tokens")
    }
}

const registerUser = asyncHandler(async (req,res)=>{
    //get user deatail from frontend
    //validation- not empty
    //check if user already exists:username , email
    //check for images
    //check for avatar
    //upload them to cloudinary,avatar
    //create user object - create entry in db
    //remove password and refresh token field from response
    //check for user creation 
    //return res

    const {fullname,email,username,password,bio,skills}=req.body
    console.log("email : ",email);

    if(
        [fullname,email,username,password].some((field)=>
            field?.trim()==="")
    ){
        throw new ApiError(400,"All fields are required !!!")
    }

    const existedUser = await User.findOne({
        $or:[{ username },{ email }]
    })
    // console.log("existedUser : ",existedUser);

    if(existedUser){
        throw new ApiError(409,"User already exists")
    }

    const avatarLocalPath = req.files?.avatar[0]?.path;
    console.log("avatarLocalPath : ",avatarLocalPath);

    let coverImageLocalPath;
    if(req.files && Array.isArray(req.files.coverImage) && req.files.coverImage.length>0){
        coverImageLocalPath = req.files.coverImage[0].path;
    }

    if(!avatarLocalPath){
        throw new ApiError(400,"Avatar is required!!!")
    }

    const avatar = await uploadOnCloudinary(avatarLocalPath)
    const coverImage = await uploadOnCloudinary(coverImageLocalPath);
    console.log("avatar : ",avatar);  
    console.log("coverImage : ",coverImage); 
    if(!avatar){
        throw new ApiError(500,"Failed to upload avatar")
    }

    const user=await User.create({
        fullname,
        avatar:avatar.url,
        coverImage:coverImage?.url || "",
        email,
        password,
        username:username.toLowerCase(),
        bio,
        skills
    })

    const createdUser = await User.findById(user._id).select(
        "-password -refreshToken"
    )

    if(!createdUser){
        throw new ApiError(500,"Failed to register user!!!")
    }

    return res.status(201).json(
        new ApiResponse(
            200,
            createdUser,
            "User registered successfully"
        )
    )


})

const loginUser = asyncHandler(async (req,res)=>{
    //req body -> get user detail from frontend
    //username or email
    //find the user
    //password check
    //access and refresh token generation
    //send cookies
    //return response

    const {email ,username,password}=req.body

    if(!username || !email){
        throw new ApiError(400,"Username or Email is required")
    }

    const user = await User.findOne({
        $or:[{username},{email}]//or->either username or email
    })

    if(!user){
        throw new ApiError(404,"user does not exist")
    }

    const isPasswordValid = await user.isPasswordCorrect(password)

    if(!isPasswordValid){
        throw new ApiError(404,"Invalid credentials!!!")
    }

    const {accessToken,refreshToken} = await generateAccessAndRefreshToken(user._id)

    const loggedInUser = await User.findById(user._id).select("-password -refreshToken")

    const options ={//to set the cookie options 
        httpOnly:true,
        secure:true,
    }

    return res //to send the response 
    .status(200)
    .cookie("accessToken",accessToken,options)
    .cookie("refreshToken",refreshToken,options)
    .json(
        new ApiResponse(
            200,
            {//data to send
                user:loggedInUser,
                accessToken,
                refreshToken
            },
            "User logged in successfully"//message
        )
    )

})  

const logoutUser = asyncHandler(async(req,res)=>{
    //clear cookie
    //set refresh token to empty
    
})

export {registerUser,loginUser,logoutUser}