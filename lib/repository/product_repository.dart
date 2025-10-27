import 'dart:convert';
import 'package:level1/models/product_model.dart';
import 'package:level1/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductRepository {
  final ApiService _apiService = ApiService();
  static const String _cacheKey = 'cached_products';
  static const String _cacheTimestampKey = 'cache_timestamp';
  static const Duration cacheDuration = Duration(hours: 1); // Cache for 1 hour

  Future<List<Product>> getProducts() async {
    try {
      // Try to fetch from API first
      final List<Product> products = await _apiService.fetchProducts();
      await _cacheProducts(products);
      return products;
    } catch (e) {
      // If API fails, try cache
      final List<Product>? cachedProducts = await _getCachedProducts();
      if (cachedProducts != null && cachedProducts.isNotEmpty) {
        return cachedProducts;
      }
      rethrow;
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    if (query.isEmpty) {
      return getProducts();
    }
    return await _apiService.searchProducts(query);
  }

  Future<void> _cacheProducts(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> productJsonList =
        products.map((product) => json.encode(product.toJson())).toList();

    await prefs.setStringList(_cacheKey, productJsonList);
    await prefs.setInt(
        _cacheTimestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<List<Product>?> _getCachedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? productJsonList = prefs.getStringList(_cacheKey);
    final int? timestamp = prefs.getInt(_cacheTimestampKey);

    if (productJsonList == null || timestamp == null) {
      return null;
    }

    // Check if cache is still valid
    final DateTime cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    if (DateTime.now().difference(cacheTime) > cacheDuration) {
      await prefs.remove(_cacheKey);
      await prefs.remove(_cacheTimestampKey);
      return null;
    }

    return productJsonList
        .map((jsonString) => Product.fromJson(json.decode(jsonString)))
        .toList();
  }
}
