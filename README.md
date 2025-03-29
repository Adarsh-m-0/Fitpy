# FitPy 🏋️♂️

**Your Personal Fitness Journey Companion**  
An open-source fitness tracking and workout management application built with Flutter.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.19+-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev)
[![GitHub Issues](https://img.shields.io/github/issues/Adarsh-m-0/Fitpy)](https://github.com/Adarsh-m-0/Fitpy/issues)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

<p align="center">
  <img src="assets/app_icon.png" width="200" alt="FitPy Logo">
</p>

## 📌 Table of Contents
- [About](#-about)
- [Features](#-features)
- [Screenshots](#-screenshots)
- [Installation](#-installation)
- [Usage](#-usage)
- [Tech Stack](#-tech-stack)
- [Architecture](#-architecture)
- [Contributing](#-contributing)
- [Roadmap](#-roadmap)
- [License](#-license)

---

## 📖 About

FitPy is a comprehensive fitness tracking application designed to help you **monitor, manage, and maximize** your fitness journey. Whether you're a beginner or a seasoned athlete, FitPy provides powerful tools to track workouts, monitor progress, and stay motivated - all while respecting your privacy.

**Key Differentiators:**
- 🛡️ 100% offline functionality
- 🔒 Zero account requirements
- 📱 Mobile-first design
- 🧩 Extensible architecture
- 🌐 Open source community-driven

---

## 🌟 Features

### 🏋️ Workout Management
- **Exercise Tracking**: Log sets, reps, weights, and duration
- **Program Builder**: Create custom workout routines
- **Progress Visualization**: Interactive charts for strength gains
- **Body Metrics**: Track weight, body fat %, and measurements

### 📊 Analytics & Insights
- **Performance Trends**: Visualize progress with interactive graphs
- **Personal Records**: Auto-detected PR highlighting
- **Workout History**: Calendar view with historical data
- **Export Data**: CSV export for personal analysis

### 🎯 Guided Programs
- **Beginner-Friendly**: 4-week starter programs
- **Progressive Overload**: Adaptive workout suggestions
- **Rest Timer**: Built-in interval timer
- **Exercise Library**: 150+ exercises with animations

### 🎮 Gamification
- **Achievements**: Unlock fitness milestones
- **Streaks**: Maintain workout consistency
- **Badges**: Earn rewards for PRs
- **Challenges**: Monthly fitness challenges

### ⚙️ Personalization
- **Dark/Light Mode**: Eye-friendly themes
- **Custom Units**: kg/lb toggle
- **Reminders**: Daily workout notifications
- **Backup/Restore**: Local data management

---

## 📸 Screenshots

| Dashboard | Workout Tracking | Progress Analytics |
|-----------|------------------|--------------------|
| <img src="screenshots/dashboard.png" width="300"> | <img src="screenshots/workout.png" width="300"> | <img src="screenshots/analytics.png" width="300"> |

---

## 📥 Installation

### Prerequisites
- Flutter 3.19.0+
- Dart 3.0.0+
- Android Studio/Xcode (for mobile builds)
- VS Code/IntelliJ (recommended IDE)

### Installation Options

#### Option 1: Production Build (Android APK)
1. Download latest APK from [Releases](https://github.com/Adarsh-m-0/Fitpy/releases)
2. Enable "Install from unknown sources" in device settings
3. Install and launch

#### Option 2: Development Setup
```bash
# Clone repository
git clone https://github.com/Adarsh-m-0/Fitpy.git
cd Fitpy

# Install dependencies
flutter pub get

# Run development build
flutter run

# Install dependencies
flutter pub get

# Run the app in debug mode
flutter run
