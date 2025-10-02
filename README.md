# Buscaminas (Minesweeper)

A classic Minesweeper game built with Flutter, featuring a modern cross-platform implementation with support for desktop, mobile, and web platforms.

## 📝 Description

Buscaminas is a Flutter-based implementation of the classic Minesweeper puzzle game. Players must clear a board containing hidden "mines" without detonating any of them, using clues about the number of neighboring mines in each field. The game features an intuitive interface built with Cupertino design patterns and supports multiple difficulty levels.

## 🚀 Technologies Used

### Core Technologies
- **Flutter SDK** (>=3.1.0 <4.0.0) - UI framework for building natively compiled applications
- **Dart** - Programming language optimized for building mobile, desktop, server, and web applications

### Key Packages & Dependencies
- **[provider](https://pub.dev/packages/provider)** (^6.0.5) - State management solution for managing game state
- **[window_manager](https://pub.dev/packages/window_manager)** (^0.3.6) - Window management for desktop platforms (Linux, macOS, Windows)
- **[cupertino_icons](https://pub.dev/packages/cupertino_icons)** (^1.0.2) - iOS-style icons

### Development Tools
- **flutter_lints** (^2.0.0) - Recommended lints for Flutter projects
- **flutter_launcher_icons** (^0.13.1) - Icon generation for multiple platforms

### Build Systems
- **CMake** (3.10+) - Build system for Linux and Windows desktop applications
- **GTK 3.0** - GUI toolkit for Linux platform

## 🎮 Features

- Classic Minesweeper gameplay mechanics
- Multiple difficulty levels (configurable board size and bomb count)
- Flag marking system for suspected mines
- Timer to track game duration
- Win/loss detection
- Custom graphics for bombs, flags, and explosions
- Responsive UI that adapts to different screen sizes

## 📱 Platform Support

This application runs on:
- ✅ **Windows** (Desktop)
- ✅ **macOS** (Desktop)
- ✅ **Linux** (Desktop with GTK 3.0)
- ✅ **iOS** (Mobile)
- ✅ **Android** (Mobile)
- ✅ **Web** (Browser-based)

### Installation Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/gbiagi/DAM-Flutter-Buscaminas-gbiagi-dsanchez.git
   cd DAM-Flutter-Buscaminas-gbiagi-dsanchez/buscaminas
   ```

2. Get Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application:
   ```bash
   flutter run
   ```

   For specific platforms:
   ```bash
   flutter run -d windows    # Windows
   flutter run -d macos      # macOS
   flutter run -d linux      # Linux
   flutter run -d chrome     # Web
   flutter run -d <device>   # Mobile (Android/iOS)
   ```

## 🎯 How to Play

1. **Start the game** - Launch the application and select your difficulty level and grid size on upper right corner
2. **Click to reveal** - Tap or click on a cell to reveal what's underneath
3. **Place flags** - Double-click/tap to place a flag on suspected mines
4. **Win condition** - Reveal all cells that don't contain mines
5. **Lose condition** - Revealing a cell with a mine ends the game

## 📄 License

This is a educational project for DAM (Desarrollo de Aplicaciones Multiplataforma).

## 👥 Authors

- gbiagi
- dsanchez

This was an educational class project. 
