import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:level1/my_tickets_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:level1/main.dart';
import 'package:level1/providers/voucher_provider.dart';
import 'package:level1/providers/ticket_provider.dart';
import 'package:level1/providers/product_provider.dart';
import 'package:level1/screens/voucher_list_screen.dart';
import 'package:level1/widgets/voucher_card.dart';

// Generate mocks for http.Client
class MockClient extends Mock implements http.Client {}

void main() {
  // Set up mock HTTP client for all tests
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    // Mock a successful response with sample vouchers
    Uri any;
    var any2 = newMethod(any);
    when(mockClient.get(any2)).thenAnswer((_) async => http.Response(
          '''[
            {"id": "1", "title": "Voucher 1"},
            {"id": "2", "title": "Voucher 2"}
          ]''',
          200,
        ));
  });

  testWidgets('App launches and shows voucher list screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => VoucherProvider()..setClient(mockClient)),
          ChangeNotifierProvider(
              create: (_) => TicketProvider()..setClient(mockClient)),
          ChangeNotifierProvider(
              create: (_) => ProductProvider()..setClient(mockClient)),
        ],
        child: MyApp(),
      ),
    );

    // Wait for async operations (e.g., loadVouchers)
    await tester.pumpAndSettle();

    // Verify app structure
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(VoucherListScreen), findsOneWidget);

    // Verify AppBar title (adjust if AppStrings.appName differs)
    expect(find.text('Vouchers'),
        findsOneWidget); // Replace with AppStrings.appName value
  });

  testWidgets('App has basic material structure', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => VoucherProvider()..setClient(mockClient)),
          ChangeNotifierProvider(
              create: (_) => TicketProvider()..setClient(mockClient)),
          ChangeNotifierProvider(
              create: (_) => ProductProvider()..setClient(mockClient)),
        ],
        child: MyApp(),
      ),
    );

    // Wait for async operations
    await tester.pumpAndSettle();

    // Verify material structure
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);

    // Verify debug banner is hidden
    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.debugShowCheckedModeBanner, false);
  });

  testWidgets('VoucherListScreen loads vouchers and displays them',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => VoucherProvider()..setClient(mockClient)),
          ChangeNotifierProvider(
              create: (_) => TicketProvider()..setClient(mockClient)),
          ChangeNotifierProvider(
              create: (_) => ProductProvider()..setClient(mockClient)),
        ],
        child: MyApp(),
      ),
    );

    // Wait for async voucher loading
    await tester.pumpAndSettle();

    // Verify voucher list title
    expect(find.text('Available Vouchers (2)'),
        findsOneWidget); // Based on mock response

    // Verify VoucherCard widgets (assumes 2 vouchers from mock)
    expect(find.byType(VoucherCard), findsNWidgets(2));

    // Verify specific voucher titles (adjust based on VoucherCard content)
    expect(find.text('Voucher 1'), findsOneWidget);
    expect(find.text('Voucher 2'), findsOneWidget);
  });

  testWidgets('VoucherListScreen search functionality',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => VoucherProvider()..setClient(mockClient)),
          ChangeNotifierProvider(
              create: (_) => TicketProvider()..setClient(mockClient)),
          ChangeNotifierProvider(
              create: (_) => ProductProvider()..setClient(mockClient)),
        ],
        child: MyApp(),
      ),
    );

    // Wait for async voucher loading
    await tester.pumpAndSettle();

    // Verify initial vouchers
    expect(find.text('Available Vouchers (2)'), findsOneWidget);
    expect(find.byType(VoucherCard), findsNWidgets(2));

    // Enter search query
    await tester.enterText(find.byType(TextField), 'Voucher 1');
    await tester.pumpAndSettle();

    // Verify filtered vouchers (assumes searchVouchers filters to 1 result)
    expect(find.text('Available Vouchers (1)'), findsOneWidget);
    expect(find.byType(VoucherCard), findsOneWidget);
    expect(find.text('Voucher 1'), findsOneWidget);
    expect(find.text('Voucher 2'), findsNothing);

    // Clear search
    await tester.tap(find.byIcon(Icons.clear));
    await tester.pumpAndSettle();

    // Verify all vouchers are back
    expect(find.text('Available Vouchers (2)'), findsOneWidget);
    expect(find.byType(VoucherCard), findsNWidgets(2));
  });

  testWidgets('VoucherListScreen navigates to MyTicketsScreen via menu',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => VoucherProvider()..setClient(mockClient)),
          ChangeNotifierProvider(
              create: (_) => TicketProvider()..setClient(mockClient)),
          ChangeNotifierProvider(
              create: (_) => ProductProvider()..setClient(mockClient)),
        ],
        child: MyApp(),
      ),
    );

    // Wait for async voucher loading
    await tester.pumpAndSettle();

    // Tap the menu button
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    // Tap the 'My Tickets' menu item
    await tester.tap(find.text('My Tickets'));
    await tester.pumpAndSettle();

    // Verify navigation to MyTicketsScreen
    expect(find.byType(MyTicketsScreen), findsOneWidget);
  });
}

Uri newMethod(Uri any) => any;

when(Future<http.Response> future) {}

// Run `flutter pub run build_runner build` to generate this
@GenerateMocks([http.Client])
void mockGenerator() {}
