import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF4CAF50);
  static const Color secondary = Color(0xFF2196F3);
  static const Color accent = Color(0xFFFF9800);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF333333);
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);

  // Ticket colors
  static const Color vipTicket = Color(0xFF6C63FF);
  static const Color generalTicket = Color(0xFFFF6584);
  static const Color premiumTicket = Color(0xFF36D1DC);
}

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      background: AppColors.background,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      error: AppColors.error,
    ),
    fontFamily: 'Roboto',
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.onSurface,
      elevation: 0,
      centerTitle: true,
    ),
    // Remove CardTheme or use the corrected version below
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primary),
      ),
      filled: true,
      fillColor: Colors.white,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      background: Color(0xFF121212),
      surface: Color(0xFF1E1E1E),
      onSurface: Colors.white,
    ),
    fontFamily: 'Roboto',
  );
}

class AppStrings {
  static const String appName = 'Voucher & Deals';
  static const String searchVoucher = 'Search a Voucher';
  static const String yourActiveDeals = 'Your Active Deals';
  static const String promoCodeHint = 'Promo Code? Enter Promo Here.';
  static const String viewVoucher = 'View Voucher';
  static const String voucherDetails = 'Voucher Details';
  static const String myTickets = 'My Tickets';
  static const String orderDetails = 'Order Details';
  static const String paymentMethod = 'Payment Method';
  static const String success = 'Success!';
}

class ApiEndpoints {
  static const String baseUrl = 'https://dummyjson.com';
  static const String products = '$baseUrl/products';
  static const String productSearch = '$baseUrl/products/search';
}
