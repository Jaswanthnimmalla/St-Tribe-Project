import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/voucher_provider.dart';
import 'providers/ticket_provider.dart';
import 'providers/product_provider.dart';
import 'screens/voucher_list_screen.dart';
import 'utils/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VoucherProvider()),
        ChangeNotifierProvider(create: (_) => TicketProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        title: 'Voucher & Tickets App',
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        themeMode: ThemeMode.light,
        home: VoucherListScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
