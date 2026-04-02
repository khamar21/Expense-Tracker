# Expense Tracker

A beautiful and intuitive Flutter mobile application for tracking personal expenses with smart analytics, salary management, and detailed expense history.

## Features

✨ **Smart Expense Tracking**
- Add expenses with title, amount, and category
- Automatic date and time recording
- Real-time expense list with filtering options
- Organized by categories

💳 **Salary & Savings Management**
- Set monthly salary with one-time entry restriction
- Track remaining savings after expenses
- Automatic calculation of available balance
- Monthly salary lock to prevent re-entry

📊 **Advanced Analytics**
- Dynamic pie chart showing spending by category
- Monthly, weekly, and yearly period filters
- Trend analysis with bar charts
- Average daily spending calculation
- Top spending category insights

📜 **Expense History**
- Complete history of all transactions
- Date range filtering
- Category-based filtering
- Detailed transaction view with timestamps
- Easy navigation and search

🎨 **Beautiful UI/UX**
- Modern gradient design
- Smooth animations and transitions
- Responsive layout for all screen sizes
- Polished cards and interactive elements
- Professional color palette

## Tech Stack

- **Framework**: Flutter 3.x
- **Language**: Dart 3.x
- **State Management**: Flutter Riverpod
- **Backend**: REST API (http package)
- **Local Storage**: Hive
- **Charts**: FL Chart
- **Date Formatting**: Intl
- **UI Components**: Material Design 3

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_colors.dart          # App color palette
│   ├── theme/                         # Theme configuration
│   └── utils/                         # Utility functions
├── data/
│   ├── datasources/
│   │   └── local/                     # Local storage logic
│   ├── models/                        # Data models
│   ├── remote/
│   │   └── api_service.dart          # API service
│   └── repositories/                  # Repository implementations
├── domain/
│   ├── entities/
│   │   └── expense_entity.dart       # Expense model
│   ├── repositories/                  # Repository interfaces
│   └── usecases/                      # Business logic
├── presentation/
│   ├── providers/
│   │   └── expense_provider.dart     # Riverpod providers
│   ├── screens/
│   │   ├── home/
│   │   ├── analytics/
│   │   ├── history/
│   │   ├── add_expense/
│   │   └── main_navigation/
│   └── widgets/                       # Reusable widgets
└── main.dart                          # App entry point
```

## Installation

### Prerequisites
- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher
- Android Studio or Xcode (for emulator)
- An active internet connection for backend API

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/expense_tracker.git
   cd expense_tracker
   ```

2. **Get dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Backend API**
   - Update the base URL in `lib/data/remote/api_service.dart`:
     ```dart
     static const String baseUrl = "http://your-backend-url:8000";
     ```
   - For local development with Android Emulator: `http://10.0.2.2:8000`
   - For real device: Use your server's IP address (e.g., `http://192.168.1.100:8000`)

4. **Run the app**
   ```bash
   flutter run
   ```

## Usage

### Adding an Expense
1. Tap the floating action button (+) on the Home screen
2. Enter expense details:
   - Title
   - Amount
   - Category (select from dropdown)
3. Tap "Save Expense"

### Setting Monthly Salary
1. Go to Home screen
2. Look for the salary card
3. Tap "Add Salary" button
4. Enter your monthly salary
5. Confirm - you can only set this once per month

### Viewing Analytics
1. Navigate to the Analytics tab
2. Use period filters (Monthly, Weekly, Yearly)
3. View:
   - Pie chart by category
   - Spending trends
   - Average daily spending
   - Top spending category

### Checking Expense History
1. Go to History tab
2. Filter by date range using the calendar picker
3. Filter by category using chips
4. View detailed transaction information

## API Endpoints

The app communicates with a REST backend. Required endpoints:

### GET /expenses/
Returns list of all expenses

**Response:**
```json
[
  {
    "id": "1",
    "title": "Groceries",
    "amount": 500,
    "category": "Food",
    "date": "2024-04-02T10:30:00Z"
  }
]
```

### POST /expenses/
Creates a new expense

**Request:**
```json
{
  "title": "Groceries",
  "amount": 500,
  "category": "Food"
}
```

**Response:** Returns created expense with ID and date

## Color Palette

- **Primary**: `#5B67FF` (Blue)
- **Secondary**: `#FF9D55` (Orange)
- **Background**: `#F6F8FC` (Light Gray)
- **Surface**: `#FFFFFF` (White)
- **Error**: `#FF6B6B` (Red)

## State Management with Riverpod

The app uses Riverpod for state management with the `expenseProvider`:

```dart
final expenseProvider = StateNotifierProvider<ExpenseNotifier, List<ExpenseEntity>>((ref) {
  return ExpenseNotifier();
});
```

### Key Methods:
- `fetchExpenses()` - Load expenses from API
- `addExpense(title, amount, category)` - Create new expense
- `deleteExpense(id)` - Remove expense

## Local Storage (Hive)

Hive is used for lightweight local storage:

- **settings box**: Stores monthly salary and salary entry month
- **expenses box**: Cached expense data (for future offline support)

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Troubleshooting

### API Connection Issues
- Verify backend server is running
- Check base URL configuration matches your environment
- Ensure device/emulator can reach the backend IP
- Check network logs in Flutter DevTools

### Salary Not Saving
- Clear app cache and try again
- Ensure Hive boxes are initialized in `main.dart`
- Check device storage permissions

### Expenses Not Appearing
- Pull down to refresh (if implemented)
- Verify backend API responses
- Check Riverpod provider logs
- Ensure date/time on device is correct

## Known Limitations

- Monthly salary can only be set once per calendar month
- Requires backend API for full functionality
- Expense history limited to 5 years
- Offline mode not yet implemented

## Future Enhancements

- [ ] Offline expense tracking
- [ ] Recurring expense templates
- [ ] Budget alerts and limits
- [ ] Export to PDF/CSV
- [ ] Dark mode implementation
- [ ] Push notifications for spending alerts
- [ ] Multi-currency support
- [ ] Expense notes and attachments



---

**Made with Flutter 🚀**
