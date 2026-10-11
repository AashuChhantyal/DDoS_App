# DDoS — Daily Dose of Software 📱

A cross-platform Flutter mobile application designed for bite-sized software engineering learning[cite: 1, 2]. Built as part of the **Excelerate Internship Program**, DDoS delivers daily software knowledge, code snippets, interactive learning tracks, and progress analytics through an engaging mobile UI[cite: 1, 2].

---

## 👤 Developer

- **Developer:** Aashu Chhantyal
- **Role:** Full-Stack & Frontend Development (Flutter UI, Mobile Architecture, Express API, PostgreSQL)[cite: 1]
- **Scope:** Mobile UI/UX, Navigation, JWT Authentication, API Client, State Management, and Database Integration[cite: 1]
- **Platforms:** Android, iOS, and Web (Flutter Cross-Platform)[cite: 1]

---

## 🎨 Design System

The app strictly adheres to Material Design 3 guidelines using an Amber & Shield brand identity[cite: 1]:

| Design Token | Hex Code | Application |
| :--- | :--- | :--- |
| **Primary Accent** | `#D97706` | Active navigation tabs, buttons, highlights[cite: 1] |
| **Primary Theme** | `#8D4B00` | Material primary seed color[cite: 1] |
| **Background** | `#FAF9F8` | Screen background color[cite: 1] |
| **Surface Card** | `#FFFFFF` | Cards, list items, navigation bar[cite: 1] |
| **Primary Text** | `#1A1C1C` | Headings and primary labels[cite: 1] |
| **Secondary Text** | `#554336` | Subtitles, reading times, captions[cite: 1] |

---

## ✨ Core Features & UI Overview

### 1. 🎬 Animated Splash Screen
- Staggered fade-in and slide-up animations using native `AnimationController`[cite: 1].
- Seamless transition to the authenticated app shell or login flow[cite: 1].

### 2. 🏠 Dynamic Home Screen
- **Daily Dose Featured Card:** Highlights today's post with dark-mode syntax highlighting, reading duration, and category tags[cite: 1, 4].
- **Personalized Header:** Displays greeting, search bar, and active daily streak badge (e.g., `7 🔥`)[cite: 1, 4].
- **Horizontal Tracks:** Interactive carousel showing in-progress learning tracks with progress indicators[cite: 1, 4].

### 3. 🔍 Topic Exploration
- **Category Filters:** Filter posts by *System Design*, *Backend*, *Frontend*, *DevOps*, and *Data Structures*[cite: 1, 7, 8].
- **Trending Topics Grid:** 2x2 interactive grid connecting to specific software engineering domains[cite: 1, 7, 8].

### 4. 📊 Progress & Analytics
- **Gamification:** Daily streak counters and achievement badges (*7-Day Flame 🔥*, *30-Day Master 🏆*, *Fast Learner ⚡*, *Bug Hunter 🐛*)[cite: 1].
- **Analytics Grid:** Displays total concepts mastered, quiz accuracy, total read time, and global ranking[cite: 1].

### 5. 👤 Profile & Offline Reading
- **Bookmarked Content:** Access saved posts offline[cite: 1].
- **Offline Storage:** Local caching using `flutter_secure_storage` and disk persistence for offline study sessions[cite: 1].

---

## 🛠️ Architecture & Tech Stack

### Mobile Frontend (`/mobile`)
- **Framework:** Flutter (Dart)[cite: 1]
- **State Management:** `Provider` pattern (`AuthProvider`, `FeedProvider`, `PostProvider`, `OfflineProvider`)[cite: 1]
- **Networking:** `Dio` with authorization interceptors and automated `401 Unauthorized` token handling[cite: 1]
- **Secure Storage:** `flutter_secure_storage` for JWT tokens and user metadata[cite: 1]

### Backend Service (`/backend`)
- **Environment:** Node.js, Express, TypeScript[cite: 1]
- **Database:** PostgreSQL on Port 5432[cite: 1]
- **Authentication:** JWT (JSON Web Tokens) with hashed password security[cite: 1]

---

## 📁 Project Directory Structure

```text
ddos_app/
├── backend/
│   ├── src/
│   │   ├── config/          # Database connection pool setup
│   │   ├── controllers/     # Auth, post, series & social controllers
│   │   ├── middleware/      # JWT authentication middleware
│   │   ├── routes/          # Express route declarations (/api/auth, /api/posts, etc.)
│   │   └── db/              # SQL schema definitions and seed.sql scripts
│   └── package.json
│
└── mobile/
    ├── assets/
    │   └── images/          # logo.png and brand assets
    ├── lib/
    │   ├── models/          # User, Post, Series, Comment Dart models
    │   ├── providers/       # AuthProvider, PostProvider, FeedProvider
    │   ├── screens/         # Home, Explore, DailyDose, Progress, Profile, Auth screens
    │   ├── services/        # ApiService, AuthService, DioClient, StorageService
    │   └── utils/           # Centralized constants, theme colors, and layout helpers
    └── pubspec.yaml

---

## ⚡ Quick Start & Setup Guide
1. Prerequisites
Flutter SDK (3.x or higher)

Node.js (v18+) & npm

PostgreSQL Service running on port 5432

2. Database Initialization
Start your PostgreSQL service and execute the database seed file:

Bash
# Start PostgreSQL service (Windows CMD as Administrator)
net start postgresql-x64-18

# Seed database schema & initial post data
cd backend
psql -U postgres -d ddos_db -f src/db/seed.sql
3. Backend Setup & Startup
Install dependencies and launch the Node.js Express server:

Bash
cd backend
npm install
npm run dev
Backend server will start on http://localhost:3000

4. Mobile App Launch
In a new terminal window, fetch dependencies and launch the Flutter app:

Bash
cd mobile
flutter pub get

# Run on Web (Chrome)
flutter run -d chrome

# Run on Android Emulator / Physical Device
flutter run


*** DDoS Application Developed by Aashu Chhantyal for Excelerate Internship Program — 2026 ***
