# 💰 Expense Tracker - Modern Flutter Application

A beautiful, feature-rich expense tracking application built with Flutter. Track your spending habits with a modern UI, powerful analytics, and intuitive controls.

## ✨ Features

### Core Features
- **Add/Edit/Delete Expenses** - Easily manage your expenses with a beautiful dialog interface
- **Expense Search** - Search expenses by title or category in real-time
- **Category Management** - 8 predefined categories with color-coded icons:
  - 🍽️ Food
  - 🚗 Transport
  - 🎬 Entertainment
  - 🛍️ Shopping
  - 📄 Bills
  - 🏥 Health
  - 📚 Education
  - 📌 Other

### Dashboard & Analytics
- **Beautiful Dashboard** - Overview of your total expenses, transaction count, and average spending
- **Category Insights** - Identify your highest spending category at a glance
- **Monthly Tracking** - See how many transactions you've made this month
- **Expense Statistics** - Real-time calculation of spending patterns

### User Interface
- **Modern Design** - Clean, intuitive interface with smooth animations
- **Responsive Layout** - Works seamlessly on all screen sizes
- **Dark & Light Support** - Beautiful theme implementation using Material 3
- **Smooth Transitions** - Animated transitions between screens and dialogs

### Data Management
- **Local Storage** - Uses Hive database for offline-first functionality
- **Data Persistence** - All expenses are saved locally on your device
- **Date Management** - Smart date picker with relative date display (Today, Yesterday, etc.)
- **Real-time Updates** - Instant UI updates when expenses change

## 🎨 UI/UX Improvements

### Theme & Typography
- **Modern Color Palette** - Carefully chosen colors for visual harmony
- **Google Fonts** - Professional typography with Poppins font family
- **Material 3 Design** - Latest Material Design principles implemented
- **Consistent Styling** - Unified design language across the app

### Components
- **Beautiful Cards** - Custom expense cards with category icons and colors
- **Dashboard Widget** - Summary statistics in an eye-catching gradient card
- **Smart Dialogs** - Intuitive add/edit expense dialogs with category selection
- **Bottom Sheets** - Detailed expense view in smooth bottom sheet
- **Search Bar** - Real-time search functionality with clear button

## 📱 Technical Architecture

### Project Structure (Clean Architecture)
```
lib/
├── core/
│   ├── theme/           # App theme and styling
│   └── utils/          # Utility functions
├── data/
│   ├── datasourse/     # Hive database service
│   ├── models/         # Data models
│   └── repository/     # Repository implementation
├── domain/
│   └── repository/     # Repository interface
├── presentation/
│   ├── bloc/          # BLoC state management
│   ├── widgets/       # Reusable UI components
│   ├── home.dart      # Main home page
│   └── error_app.dart # Error handling
└── main.dart          # Entry point
```

### State Management
- **Flutter BLoC** - Robust state management with BLoC pattern
- **Events & States** - Clean event-driven architecture
- **Filtering & Searching** - Advanced filtering capabilities

### Technologies Used
- **flutter_bloc: ^9.1.1** - State management
- **hive & hive_flutter** - Local database
- **google_fonts** - Typography
- **fl_chart** - Chart support (for future analytics)
- **intl** - Internationalization and formatting
- **uuid** - Unique ID generation

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.12.0 or higher)
- Dart SDK

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd expense_tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

## 🎯 Usage

### Adding an Expense
1. Tap the floating action button (+ button) at the bottom right
2. Fill in the expense details:
   - **Title** - Name of the expense
   - **Amount** - Spending amount
   - **Category** - Choose from 8 categories
   - **Date** - Select the date (defaults to today)
3. Tap "Add" to save

### Editing an Expense
1. Tap on an expense in the list
2. In the details bottom sheet, tap "Edit"
3. Modify the details and tap "Update"

### Deleting an Expense
1. Swipe or tap the expense and select "Delete"
2. Confirm the deletion in the dialog

### Searching Expenses
1. Use the search bar at the top
2. Type to search by title or category
3. Tap the X button to clear search

## 📊 Dashboard

The dashboard shows:
- **Total Expenses** - Sum of all your spending
- **Transaction Count** - Number of transactions recorded
- **Average Spending** - Average amount per transaction
- **Highest Category** - Category with most spending
- **This Month** - Number of transactions this month

## 🔒 Data Privacy

- All data is stored locally on your device using Hive database
- No data is sent to external servers
- Full control over your financial information

## 📈 Future Enhancements

- 📊 Advanced charts and graphs
- 📅 Monthly/yearly reports
- 💾 Data export (CSV, PDF)
- 🏷️ Custom categories
- 🎯 Budget limits and alerts
- 📱 Cross-device sync
- 🌙 Dark mode toggle
- 📈 Recurring expenses
- 🔍 Advanced filtering options

## 🐛 Known Issues

None currently. Please report any bugs or issues you encounter.

## 💡 Tips

- Use consistent category names for better organization
- Review your expenses regularly to identify spending patterns
- The search function is case-insensitive for easy finding
- Expenses are automatically sorted by most recent first

## 📄 License

This project is open source and available under the MIT License.

## 👨‍💻 Developer

Built with ❤️ using Flutter

---

**Version:** 1.0.0+1
**Last Updated:** 2024
