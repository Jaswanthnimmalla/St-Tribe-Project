import 'package:flutter/foundation.dart';
import 'package:http/testing.dart';
import '../models/ticket_model.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';

class TicketProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final CacheService _cacheService = CacheService();

  List<Ticket> _tickets = [];
  bool _isLoading = false;
  String? _error;

  List<Ticket> get tickets => _tickets;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  Future<void> loadTickets() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Try cache first
      final cachedData = await _cacheService.getCachedData('tickets');
      if (cachedData != null) {
        _tickets = cachedData.map((json) => Ticket.fromJson(json)).toList();
        notifyListeners();
      }

      // Fetch from API
      final List<Ticket> freshTickets = await _apiService.fetchTickets();
      _tickets = freshTickets;
      await _cacheService.cacheData('tickets', _tickets);
    } catch (e) {
      _error = e.toString();
      if (_tickets.isEmpty) {
        _error = 'Failed to load tickets: $e';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Ticket> get activeTickets {
    return _tickets.where((ticket) => ticket.status == 'Active').toList();
  }

  List<Ticket> get upcomingTickets {
    return _tickets.where((ticket) => ticket.status == 'Upcoming').toList();
  }

  List<Ticket> get usedTickets {
    return _tickets.where((ticket) => ticket.status == 'Used').toList();
  }

  void transferTicket(String ticketId, String email) {
    final index = _tickets.indexWhere((ticket) => ticket.id == ticketId);
    if (index != -1) {
      _tickets[index] = _tickets[index].copyWith(status: 'Transferred');
      notifyListeners();
    }
  }

  void useTicket(String ticketId) {
    final index = _tickets.indexWhere((ticket) => ticket.id == ticketId);
    if (index != -1) {
      _tickets[index] = _tickets[index].copyWith(status: 'Used');
      notifyListeners();
    }
  }

  void retry() {
    loadTickets();
  }

  setClient(MockClient mockClient) {}
}
