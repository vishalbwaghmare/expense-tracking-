import 'package:intl/intl.dart';

class AppUtils {
  // Format currency
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(symbol: '₹ ', decimalDigits: 2);
    return formatter.format(amount);
  }

  // Format date
  static String formatDate(DateTime date) {
    final formatter = DateFormat('dd MMM yyyy');
    return formatter.format(date);
  }

  // Format time
  static String formatTime(DateTime dateTime) {
    final formatter = DateFormat('hh:mm a');
    return formatter.format(dateTime);
  }

  // Get relative time (Today, Yesterday, etc.)
  static String getRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today';
    } else if (dateOnly == yesterday) {
      return 'Yesterday';
    } else if (dateOnly.year == now.year) {
      return DateFormat('dd MMM').format(date);
    } else {
      return DateFormat('dd MMM yyyy').format(date);
    }
  }

  // Calculate total from list
  static double calculateTotal(List<dynamic> items) {
    double total = 0;
    for (var item in items) {
      if (item is Map && item.containsKey('amount')) {
        total += item['amount'] as double;
      }
    }
    return total;
  }

  // Get default category color
  static const Map<String, int> defaultCategoryColors = {
    'Food': 0xFFFF6B6B,
    'Transport': 0xFF4ECDC4,
    'Entertainment': 0xFFFFE66D,
    'Shopping': 0xFFFF8C42,
    'Bills': 0xFF95E1D3,
    'Health': 0xFFC7CEEA,
    'Education': 0xFF67E8F9,
    'Other': 0xFFB0E0E6,
  };
}
