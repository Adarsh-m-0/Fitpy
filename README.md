# FitPy 🏋️

**Your Personal Fitness Journey Companion**  
An open-source fitness tracking application built with Flutter.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.19+-blue.svg)](https://flutter.dev)
[![GitHub Issues](https://img.shields.io/github/issues/Adarsh-m-0/Fitpy)](https://github.com/Adarsh-m-0/Fitpy/issues)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)


## Table of Contents
- [Features](#-features)
- [Installation](#-installation)
- [Usage](#-usage)
- [Tech Stack](#-tech-stack)
- [Architecture](#-architecture)
- [Contributing](#-contributing)
- [Roadmap](#-roadmap)
- [License](#-license)

---

## 🚀 Features

### Core Functionality
- 📊 Workout tracking with sets/reps/weight logging
- 📈 Progress analytics with interactive charts
- 🏅 Achievement system with badges and streaks
- 📚 Exercise library with 150+ predefined movements

### Technical Highlights
- 🔒 Local-first data storage (Hive database)
- � Clean Architecture implementation
- 🌓 Dark/Light theme support
- 📱 Responsive mobile-first design

---

## 📥 Installation

### Requirements
- Flutter 3.19.0+
- Dart 3.0.0+
- Android Studio or VS Code

### Quick Start
```bash
git clone https://github.com/Adarsh-m-0/Fitpy.git
cd Fitpy
flutter pub get
flutter run

### Build Releases
```bash
# Android
flutter build apk --release

# iOS (requires macOS)
flutter build ios --release
```

---

## 🖥️ Usage

**Basic Workflow:**
1. Create workout routine
2. Add exercises from library
3. Track daily sessions
4. Analyze progress in charts

**Keyboard Shortcuts (Web):**
- `Ctrl+N`: New workout
- `Ctrl+S`: Save session
- `Ctrl+P`: Progress view

---

## 🛠 Tech Stack

| Category          | Technologies                          |
|-------------------|---------------------------------------|
| Framework         | Flutter                              |
| State Management  | Riverpod                             |
| Local Database    | Hive                                |
| Charts            | FL Chart                            |
| DI                | Get It                              |
| Testing           | Mockito, Bloc Test                 |

---

## 🏗 Architecture

```
lib/
├── core/
│   ├── constants/
│   ├── utils/
│   └── themes/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── widgets/
    ├── pages/
    └── providers/
```

**Key Principles:**
- Clean Architecture
- SOLID Principles
- Reactive Programming
- Immutable State

---

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`feat/feature-name`)
3. Commit changes following [Conventional Commits](https://www.conventionalcommits.org/)
4. Open Pull Request

**Development Tips:**
```bash
# Run static analysis
flutter analyze

# Generate models
flutter pub run build_runner build

# Run tests
flutter test
```

---

