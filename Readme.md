
# Codogram 📸💻

Codogram is a modern social media platform tailored specifically for **coders, programmers, and developers** to showcase their work in a creative and engaging way. It combines the **stories and posts of Instagram** with the **snaps and streaks of Snapchat**, all while maintaining a clean, developer-friendly aesthetic.

> ⚙️ Built with Node.js, Express, MongoDB, Flutter, and Socket.IO

---

## 🚀 Project Status

- ✅ **Backend** – Fully implemented with real-time and REST APIs
- 🔧 **Frontend (Flutter)** – In progress (MVVM architecture)
- 🌐 **Repository** – [Public GitHub Repo](https://github.com/Hrishabh-01/codogram)
- 📸 **Screenshots** – Coming soon...

---

## 🛠️ Tech Stack

### 🔙 Backend
- **Node.js** + **Express.js**
- **MongoDB** + **Mongoose**
- **Socket.IO** – Real-time chat, snaps, and streak tracking
- **Cloudinary** – Image & video uploads
- **JWT Authentication** – Secure tokens with refresh via HTTP-only cookies
- **Modular Structure** – `controllers/`, `services/`, `routes/`, `middlewares/`, `utils/`

### 📱 Frontend *(In Progress)*
- **Flutter** – Clean MVVM architecture
- Target: Android, iOS, Web

---

## 🔐 Authentication & User System
- Register, Login, Logout
- Refresh tokens using secure cookies
- Update password, bio, avatar, and cover image
- Followers / Following system
- Snap score and streak count tracking

---

## 💡 Key Features

### 📰 Feed (Instagram Style)
- Post creation with multiple images/videos
- Feed view with reactions: ❤️ 🔥 😂 👍
- Gradient card UI with dot indicators and media support

### 📖 Stories
- Upload image/video stories
- View stories from followed users
- Story autoplay and full-screen view

### 📸 Snaps (Snapchat Style)
- Camera-first UX (planned in frontend)
- Capture & send snaps to users or post as story
- Snaps appear in chat threads

### 🔥 Streaks
- Track streaks when users exchange snaps within 24 hours
- Auto-expire and reset after timeout
- Visible in chat overview

### 💬 Real-Time Chat
- Personal & Group Chats with Socket.IO
- Typing indicators, unread status, last message preview
- Group management: creation, participants, admins
- Snap preview inside chats

### 🔍 Explore
- Grid-based explore page with all public posts
- (Search & filter planned)

---

## 🧠 Architecture & Design

- Modular MVC-inspired architecture
- Utilities like `asyncHandler`, `ApiError`, `ApiResponse` for consistent API responses
- Scalable real-time features with **Socket.IO**
- Cloud-based media storage with **Cloudinary**
- Security best practices: CORS, secure cookies, sanitization, rate limiting

---

## 📁 Project Structure (Backend)

```bash
codogram/
├── controllers/
├── routes/
├── services/
├── models/
├── middlewares/
├── utils/
├── sockets/
└── app.js
```

---

## 🔮 Future Roadmap

- ✅ Complete backend (Done!)
- 🚧 Finish Flutter frontend
- 🎨 Add advanced UI animations and camera-first design
- 📲 Push notifications
- 🌐 Add shareable profile links & deep linking
- 📈 Optional analytics + streak insights

---

## 📸 Screenshots

> Screenshots for the Snap UI, Feed, Profile, Stories, and Chat will be uploaded soon. Stay tuned!

---

## 👨‍💻 Developer

- **Name:** Hrishabh Agrawal
- **Role:** Solo Full-Stack Developer
- **GitHub:** [@Hrishabh-01](https://github.com/Hrishabh-01)
- **Repo:** [github.com/Hrishabh-01/codogram](https://github.com/Hrishabh-01/codogram)

---

## 🤝 Contributing

Coming soon. Once the frontend reaches beta, contribution guidelines will be added.

---

## 📫 Contact

Feel free to connect for collaboration, feedback, or opportunities:

- GitHub: [@Hrishabh-01](https://github.com/Hrishabh-01)
- Email: hrishabhagrawal122@gmail.com

---

> 💬 *Codogram — Not just a flex, but a platform for developers to showcase their journey.*
