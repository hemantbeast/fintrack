# FinTrack - Personal Finance Management App

[![Flutter Version](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.x-blue.svg)](https://dart.dev)

A comprehensive personal finance management application built with Flutter, helping users track income, expenses, and budgets with a beautiful and intuitive interface.

## Features

### Core Features
- **Dashboard** - Financial overview with balance card, recent transactions, budget overview, and currency converter
- **Expense Tracker** - Add/edit expenses with categories, descriptions, dates, and recurring expense support
- **Budget Planning** - Create category-based budgets with progress tracking and spending alerts
- **Transaction History** - View all transactions with filtering and search capabilities
- **Settings** - Profile management, currency preferences, theme customization, and notification settings

### Additional Features
- **Currency Converter** - Real-time currency conversion with exchange rates
- **Onboarding** - Multi-page onboarding flow for first-time users
- **Dark Mode** - Full dark theme support
- **Multi-currency Support** - Track finances in your preferred currency
- **Offline Support** - Cached data for offline access with automatic sync

## Architecture

This project follows **Clean Architecture** principles with three distinct layers:

```
lib/
├── features/
│   ├── {feature}/
│   │   ├── domain/          # Business logic (Entities, Repository Interfaces)
│   │   ├── data/            # Data handling (Models, Repositories, Services)
│   │   │   ├── sources/
│   │   │   │   ├── remote/  # API services
│   │   │   │   └── local/   # Hive storage
│   │   │   └── repositories/
│   │   └── ui/              # Presentation layer (Providers, States, Widgets)
├── core/                    # Shared core utilities
├── themes/                  # Theme management
└── routes/                  # Navigation
```

### Key Patterns
- **Stale-While-Revalidate** - Show cached data instantly, fetch fresh data in background
- **Repository Pattern** - Abstract data sources behind interfaces
- **Riverpod State Management** - Reactive state with Notifier pattern
- **Immutable State** - Freezed for state classes

## Tech Stack

| Category | Technology | Purpose |
|----------|------------|---------|
| **Framework** | Flutter 3.x | Cross-platform UI |
| **Language** | Dart 3.x | Programming language |
| **State Management** | Riverpod 3.2.0 | Reactive state management |
| **Local Storage** | Hive CE 2.19.1 | Fast NoSQL local database |
| **HTTP Client** | Dio 5.9.0 | API calls |
| **Routing** | Go Router 17.0.1 | Navigation |
| **Code Generation** | Freezed 3.2.4 | Immutable classes |
| **JSON Serialization** | JSON Serializable | JSON parsing |
| **Localization** | Flutter Intl | Multi-language support |
| **Animations** | Lottie 3.3.2 | Rich animations |

## Getting Started

### Prerequisites

- Flutter SDK (^3.10.7)
- Dart SDK
- Android Studio / Xcode (for emulators)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/hemantbeast/fintrack.git
cd fintrack
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate code (JSON serializers, Freezed classes, Hive adapters):
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. Run the app:
```bash
flutter run
```

### Available Scripts

Using `rps` (run pubspec scripts):

```bash
# Activate rps
flutter pub global activate rps

# Generate code after model changes
rps run

# Watch for changes and regenerate automatically
rps watch

# Run static analysis
rps analyze
```

## Project Structure

```
lib/
├── core/                  # Core utilities and extensions
│   ├── config/           # App configuration
│   ├── extensions/       # Dart/Flutter extensions
│   ├── network/          # API handling (Dio)
│   ├── observers/        # Provider observers
│   ├── utils/            # Utility functions
│   └── widgets/          # Shared widgets
├── features/             # Feature modules
│   ├── budget/           # Budget planning
│   ├── dashboard/        # Main dashboard
│   ├── expenses/         # Expense tracking
│   ├── onboarding/       # Onboarding flow
│   ├── settings/         # App settings
│   └── splash/           # Splash screen
├── themes/               # Light/Dark themes
├── routes/               # App routing
├── hive/                 # Hive storage configuration
├── fintrack_app.dart     # Main app widget
└── main.dart             # Entry point
```

## Key Features Implementation

### State Management
- Uses Riverpod with `AsyncNotifier` pattern
- Each feature has its own provider
- State is immutable using Freezed

### Data Persistence
- Hive for local storage
- Stale-while-revalidate pattern for data freshness
- Automatic caching with 24-hour validity for exchange rates

### Theming
- Light and dark theme support
- Theme switching at runtime
- Custom color palette defined in `themes/colors.dart`

### Routing
- Go Router for declarative routing
- Deep linking support

## Design System

### Colors
| Color | Hex | Usage |
|-------|-----|-------|
| Primary | `#6C63FF` | Brand color, buttons |
| Secondary | `#4CAF50` | Income, success |
| Accent | `#FF6B6B` | Expenses, alerts |
| Background | `#F8F9FA` | Light background |
| Dark Background | `#121212` | Dark background |

### Typography
- **Headers**: Poppins Bold
- **Subheaders**: Poppins SemiBold
- **Body**: Google Sans Flex Regular

## Entities

| Entity | Description |
|--------|-------------|
| `Transaction` | Income/expense transactions |
| `Balance` | Current balance with income/expenses summary |
| `Budget` | Category budgets with spending limits |
| `ExpenseCategory` | Predefined expense categories |
| `UserProfile` | User personal information |
| `UserPreferences` | App preferences (currency, theme, notifications) |

## API Integration

The app uses a mock API service for development. To connect to a real backend:

1. Update the service classes in `lib/features/{feature}/data/sources/remote/`
2. Configure API base URL in `lib/core/config/app_config.dart`
3. Add authentication headers in Dio interceptor

## Building for Production

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License.

## Acknowledgments

- [Flutter](https://flutter.dev) - UI toolkit
- [Riverpod](https://riverpod.dev) - State management
- [Hive](https://hivedb.dev) - Local storage
- [Freezed](https://pub.dev/packages/freezed) - Code generation
