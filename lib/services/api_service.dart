import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../models/voucher_model.dart';
import '../models/ticket_model.dart';
import '../utils/constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final http.Client client = http.Client();
  static const Duration timeoutDuration = Duration(seconds: 10);

  // Products API
  Future<List<Product>> fetchProducts({int limit = 10, int skip = 0}) async {
    try {
      final response = await client
          .get(Uri.parse('${ApiEndpoints.products}?limit=$limit&skip=$skip'))
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> productsJson = data['products'];
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await client
          .get(Uri.parse('${ApiEndpoints.productSearch}?q=$query'))
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> productsJson = data['products'];
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Search error: $e');
    }
  }

  // Vouchers API (Mock data for demonstration)
  Future<List<Voucher>> fetchVouchers() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay

    // Mock data - in real app, this would come from API
    return [
      Voucher(
        id: '1',
        title: 'Discount 15% on Music on Sphere Ticket',
        description:
            'Min Purchase 2 Ticket, Max. 75k discount. Please note coupon that this coupon cannot used for items promotional event.',
        expiryDate: 'Expired 24 Dec 2023',
        minPurchase: '2 Tickets',
        maxDiscount: '75K',
        code: '#HappyConcert',
        validFrom: '24 November 2023',
        validTo: '12 December 2023',
        activeVouchers: 2,
        category: 'Entertainment',
        imageUrl: 'https://picsum.photos/300/200?random=1',
        isExpired: false,
      ),
      Voucher(
        id: '2',
        title: 'Discount 55% on Era\'s Tour Ticket',
        description:
            'Min Purchase 3 Ticket, Max. 155k discount. Please note coupon that this coupon cannot used for items promotional event.',
        expiryDate: 'Expired 12 Nov 2023',
        minPurchase: '3 Tickets',
        maxDiscount: '155K',
        code: '#ErasTour',
        validFrom: '12 October 2023',
        validTo: '12 November 2023',
        activeVouchers: 1,
        category: 'Entertainment',
        imageUrl: 'https://picsum.photos/300/200?random=2',
        isExpired: true,
      ),
    ];
  }

  // Tickets API (Mock data)
  Future<List<Ticket>> fetchTickets() async {
    await Future.delayed(Duration(seconds: 1));

    return [
      Ticket(
        id: 'TKT001',
        eventName: '5th Anniversary',
        date: 'Mon 14 Oct 2019',
        venue: 'Hilton Santa Barbara',
        ticketType: 'VIP',
        startTime: '6:00 pm',
        endTime: '12:00 am',
        month: 'AUG - OCT',
        day: '14',
        status: 'Active',
        color: AppColors.vipTicket,
        secondaryColor: Color(0xFF8B85FF),
        qrCode: 'TKT001_QR',
        price: 150.0,
        section: 'A',
        quantity: 2,
      ),
      Ticket(
        id: 'TKT002',
        eventName: 'Summer Music Festival',
        date: 'Fri 25 Aug 2023',
        venue: 'Central Park Arena',
        ticketType: 'General',
        startTime: '4:00 pm',
        endTime: '11:00 pm',
        month: 'AUG',
        day: '25',
        status: 'Active',
        color: AppColors.generalTicket,
        secondaryColor: Color(0xFFFF8DA6),
        qrCode: 'TKT002_QR',
        price: 75.0,
        section: 'B',
        quantity: 1,
      ),
    ];
  }
}
