import { Server } from "socket.io";

let io;
const activeUsers = new Map(); // Store active users

export const initializeSocket = (server) => {
    io = new Server(server, {
        cors: {
            origin: process.env.CORS_ORIGIN,
            methods: ["GET", "POST"],
        }
    });

    io.on("connection", (socket) => {
        console.log(`⚡ User connected: ${socket.id}`);

        // User joins with userId
        socket.on("join", ({userId,chatId}) => {
            activeUsers.set(userId, socket.id);
            socket.join(chatId);
            console.log(`User ${userId} joined chat: ${chatId}`);

            socket.broadcast.emit("user-online", userId);
        });

        // Handling messages
        socket.on("send-message", ({ receiverId, senderId, message }) => {
            const receiverSocketId = activeUsers.get(receiverId);
            if (receiverSocketId) {
                io.to(receiverSocketId).emit("receive-message", { senderId, message });
            }
        });

        // Handle user disconnect
        socket.on("disconnect", () => {
            for (const [userId, socketId] of activeUsers.entries()) {
                if (socketId === socket.id) {
                    activeUsers.delete(userId);
                    break;
                }
            }
            console.log(`User disconnected: ${socket.id}`);
        });
    });
};

export const getSocketInstance = () => io; // Allow controllers to access socket instance
