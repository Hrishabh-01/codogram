// require('dotenv').config({path: './env'})

import dotenv from "dotenv"
import { createServer } from "http";
import { initializeSocket, getSocketInstance } from "./socket.js";
import connectDB from "./db/index.js";
import {app} from "./app.js";
import { setSocketInstance } from "./controllers/chat.controller.js";

dotenv.config({
    path :'./.env'
})

// ✅ Create HTTP server
const server = createServer(app);

connectDB()
.then(()=>{
    // ✅ Initialize Socket.io with the server
    initializeSocket(server);
    setSocketInstance(getSocketInstance());
    
    server.listen(process.env.PORT || 8000,()=>{
        console.log(`Server is running at port : ${process.env.PORT}`)
    });

        
})
.catch((err)=>{
    console.log("MONGO DB connection failed !!!" , err);

})


