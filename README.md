# FitPy

<div align="center">
  <img src="assets/images/fitpy_logo.png" alt="FitPy Logo" width="200"/>
  <h3>Your Personal Fitness Journey Companion</h3>
  <p>An open-source fitness tracking and workout management application built with Flutter</p>

  [![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
  [![Flutter](https://img.shields.io/badge/Flutter-3.19+-blue.svg)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev)
  [![GitHub Issues](https://img.shields.io/github/issues/Adarsh-m-0/Fitpy)](https://github.com/Adarsh-m-0/Fitpy/issues)
  
  <p>
    <a href="#about">About</a> •
    <a href="#key-features">Key Features</a> •
    <a href="#screenshots">Screenshots</a> •
    <a href="#installation">Installation</a> •
    <a href="#usage">Usage</a> •
    <a href="#tech-stack">Tech Stack</a> •
    <a href="#architecture">Architecture</a> •
    <a href="#contributing">Contributing</a> •
    <a href="#roadmap">Roadmap</a> •
    <a href="#license">License</a>
  </p>
</div>

## About

FitPy is a comprehensive fitness tracking application designed to help you monitor, manage, and maximize your fitness journey. Whether you're just starting your fitness journey or you're a seasoned athlete, FitPy provides the tools you need to track your workouts, monitor your progress, and stay motivated – all within a clean, intuitive interface built with Flutter.

Unlike many fitness apps that require constant internet connectivity or paid subscriptions, FitPy prioritizes your privacy by storing all data locally on your device with no account requirements.

## Key Features

### 📊 Comprehensive Workout Tracking
- Track daily workouts with detailed exercise information
- Record sets, reps, and weights for strength training
- Monitor bodyweight exercises with progressive overload tracking
- Add notes to workouts for future reference

### 📈 Weight Progress Monitoring
- Log weight measurements over time
- Visualize your weight journey with intuitive charts
- Track trends and patterns in your weight fluctuations
- Set weight goals and monitor your progress

### 🗓️ Guided Fitness Programs
- Follow structured workout programs tailored to your fitness level
- Track program completion with visual progress indicators
- Daily workout recommendations based on your program
- Adaptive routines that grow with your fitness level

### 💪 Exercise Library
- Access a diverse collection of strength and bodyweight exercises
- Filter exercises by muscle groups for targeted workouts
- View proper form and technique recommendations
- Customize exercises to match your specific needs

### 🏆 Achievement System
- Earn achievements as you reach fitness milestones
- Visual celebration of workout streaks and personal records
- Track consistency with workout calendar
- Stay motivated with progress tracking

### ⚙️ Personalization & Convenience
- Dark/light mode for comfortable viewing in any environment
- Intuitive, modern Material You design
- No internet connection required - all data stored locally
- Privacy-focused with no data sharing or account requirements

## Screenshots

[Coming Soon]

## Installation

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) (v3.19.0 or higher)
- [Dart](https://dart.dev/get-dart) (v3.0.0 or higher)
- Android Studio / VS Code with Flutter extensions

### Option 1: Install from Release

1. Visit the [Releases](https://github.com/Adarsh-m-0/Fitpy/releases) page
2. Download the latest APK file
3. Install on your Android device

### Option 2: Build from Source

```bash
# Clone the repository
git clone https://github.com/Adarsh-m-0/Fitpy.git

# Navigate to project directory
cd Fitpy

# Install dependencies
flutter pub get

# Run the app in debug mode
flutter run
```

### Building Release Versions

```bash
# Generate an APK
flutter build apk --release

# Generate an App Bundle for Google Play
flutter build appbundle --release

# Install directly to connected device
flutter install --release
```

## Usage

### Getting Started
1. Launch FitPy on your device
2. Explore the bottom navigation to access different sections
3. Start by adding your first workout or weight entry
4. Track your progress over time with the built-in charts and statistics

### Workout Tracking
- Tap the "+" button to add a new workout
- Select exercise type and enter details (sets, reps, weight)
- Add notes for additional context
- View your workout history in calendar view

### Weight Tracking
- Enter weight measurements regularly
- Visualize progress with the weight chart
- Set goals and track achievements

### Fitness Programs
- Browse available programs
- Select a program that matches your goals
- Follow daily workout recommendations
- Track your completion rate

## Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) - Google's UI toolkit for building natively compiled applications
- **State Management**: [Riverpod](https://riverpod.dev/) - A reactive caching and data-binding framework
- **Local Storage**: [Hive](https://docs.hivedb.dev/) - Lightweight and blazing fast key-value database
- **Charts**: [FL Chart](https://pub.dev/packages/fl_chart) - A powerful Flutter chart library
- **Calendar**: [Table Calendar](https://pub.dev/packages/table_calendar) - Highly customizable calendar widget
- **Animations**: [Confetti](https://pub.dev/packages/confetti) - Celebratory animations for achievements

## Architecture

FitPy follows a clean architecture approach with the following components:

- **Models**: Data structures representing workout data, programs, and user records
- **Providers**: State management using Riverpod for different app features
- **Views**: UI components and screens that users interact with
- **Widgets**: Reusable UI components used across the app

The app is structured with maintainability and testability in mind, making it easy for contributors to understand and extend.

```
lib/
├── app/            # App initialization and configuration
├── models/         # Data models and Hive adapters
│   ├── enum/       # Enumerations (e.g., muscle groups)
│   └── hive/       # Hive-specific models
├── providers/      # Riverpod providers and state management
├── theme/          # App theming and styling
├── utils/          # Utility functions
├── views/          # Main screens (e.g., home, workout, weight)
└── widgets/        # Reusable UI components
```

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

For detailed guidelines, please read our [CONTRIBUTING.md](CONTRIBUTING.md) file.

## Roadmap

We're just getting started! Here's what's coming next:

- [ ] **Enhanced Exercise Library**: Adding more exercises with illustrated guides
- [ ] **Workout Sharing**: Export and share your workout routines with friends
- [ ] **Custom Exercise Creator**: Build and save your own exercises
- [ ] **Advanced Statistics**: More detailed analytics and insights
- [ ] **Wearable Integration**: Connect with fitness wearables for automatic tracking
- [ ] **Nutrition Tracking**: Basic food and calorie logging
- [ ] **Multi-language Support**: Making FitPy accessible to users worldwide
- [ ] **Cloud Backup/Sync**: Optional backup of user data

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

- The Flutter team for creating such an amazing framework
- All contributors who have helped shape FitPy
- The open source community for valuable packages and tools
- You, for considering using or contributing to FitPy!

---

<div align="center">
  <sub>Built with ❤️ by Adarsh and contributors</sub>
  <br><br>
  <a href="https://github.com/Adarsh-m-0"><img src="https://img.shields.io/github/followers/Adarsh-m-0?style=social" alt="Follow on GitHub"></a>
</div>
#   F i t p y 
 
 