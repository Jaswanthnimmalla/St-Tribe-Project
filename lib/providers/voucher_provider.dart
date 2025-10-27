import 'package:flutter/foundation.dart';
import 'package:http/testing.dart';
import 'package:level1/models/voucher_model.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';

class VoucherProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final CacheService _cacheService = CacheService();

  List<Voucher> _vouchers = [];
  List<Voucher> _filteredVouchers = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  List<Voucher> get vouchers =>
      _searchQuery.isEmpty ? _vouchers : _filteredVouchers;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;
  String get searchQuery => _searchQuery;

  Future<void> loadVouchers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Try to load from cache first
      final cachedData = await _cacheService.getCachedData('vouchers');
      if (cachedData != null) {
        _vouchers = cachedData.map((json) => Voucher.fromJson(json)).toList();
        _filteredVouchers = _vouchers;
        notifyListeners();
      }

      // Then try to fetch from API
      final List<Voucher> freshVouchers = await _apiService.fetchVouchers();
      _vouchers = freshVouchers;
      _filteredVouchers = _vouchers;

      // Cache the fresh data
      await _cacheService.cacheData('vouchers', _vouchers);
    } catch (e) {
      _error = e.toString();
      if (_vouchers.isEmpty) {
        // Only show error if we don't have cached data
        _error = 'Failed to load vouchers: $e';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchVouchers(String query) {
    _searchQuery = query;

    if (query.isEmpty) {
      _filteredVouchers = _vouchers;
    } else {
      _filteredVouchers = _vouchers.where((voucher) {
        return voucher.title.toLowerCase().contains(query.toLowerCase()) ||
            voucher.description.toLowerCase().contains(query.toLowerCase()) ||
            voucher.category.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _filteredVouchers = _vouchers;
    notifyListeners();
  }

  void retry() {
    loadVouchers();
  }

  List<Voucher> get activeVouchers {
    return _vouchers.where((voucher) => !voucher.isExpired).toList();
  }

  List<Voucher> get expiredVouchers {
    return _vouchers.where((voucher) => voucher.isExpired).toList();
  }

  setClient(MockClient mockClient) {}
}
