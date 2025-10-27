import 'package:flutter/foundation.dart';
import 'package:http/testing.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final CacheService _cacheService = CacheService();

  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  List<Product> get products =>
      _searchQuery.isEmpty ? _products : _filteredProducts;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Try cache first
      final cachedData = await _cacheService.getCachedData('products');
      if (cachedData != null) {
        _products = cachedData.map((json) => Product.fromJson(json)).toList();
        _filteredProducts = _products;
        notifyListeners();
      }

      // Fetch from API
      final List<Product> freshProducts =
          await _apiService.fetchProducts(limit: 20);
      _products = freshProducts;
      _filteredProducts = _products;

      await _cacheService.cacheData('products', _products);
    } catch (e) {
      _error = e.toString();
      if (_products.isEmpty) {
        _error = 'Failed to load products: $e';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchProducts(String query) async {
    _searchQuery = query;

    if (query.isEmpty) {
      _filterProductsByCategory();
    } else {
      try {
        final List<Product> searchResults =
            await _apiService.searchProducts(query);
        _filteredProducts = searchResults;
      } catch (e) {
        // Fallback to local search
        _filteredProducts = _products.where((product) {
          return product.title.toLowerCase().contains(query.toLowerCase()) ||
              product.description.toLowerCase().contains(query.toLowerCase()) ||
              product.brand.toLowerCase().contains(query.toLowerCase()) ||
              product.category.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    }
    notifyListeners();
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _filterProductsByCategory();
  }

  void _filterProductsByCategory() {
    if (_selectedCategory == 'All') {
      _filteredProducts = _products;
    } else {
      _filteredProducts = _products
          .where((product) => product.category == _selectedCategory)
          .toList();
    }
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _filterProductsByCategory();
    notifyListeners();
  }

  List<String> get categories {
    final allCategories =
        _products.map((product) => product.category).toSet().toList();
    return ['All', ...allCategories];
  }

  void retry() {
    loadProducts();
  }

  setClient(MockClient mockClient) {}
}
