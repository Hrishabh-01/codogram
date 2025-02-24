import express from "express"
import cors from "cors"
import cookieParser from "cookie-parser"

const app =express()

app.use(cors(
    {
        origin:process.env.CORS_ORIGIN,
        credentials:true
    }
))

app.use(express.json({limit:"16kb"}))
app.use(express.urlencoded({extended:true,
    limit:"16kb"}))
app.use(express.static("public"))
app.use(cookieParser())



//routes import
//we can only take man chaha name if export is default 
import userRouter from "./routes/user.routes.js"
import postRouter from "./routes/post.routes.js"
import likeRouter from "./routes/like.routes.js"
import commentRouter from "./routes/comment.routes.js"
//routers declaration
app.use("/api/v1/users",userRouter)//it works as a middleware
//http://localhost:8000/api/v1/users/register we have to write it for register user route 
//if we want to login we have to write http://localhost:8000/api/v1/users/login

app.use("/api/v1/posts",postRouter)
app.use("/api/v1/likes",likeRouter)
app.use("/api/v1/comments",commentRouter)

export {app}