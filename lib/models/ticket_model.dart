import 'package:flutter/material.dart';

class Ticket {
  final String id;
  final String eventName;
  final String date;
  final String venue;
  final String ticketType;
  final String startTime;
  final String endTime;
  final String month;
  final String day;
  final String status;
  final Color color;
  final Color secondaryColor;
  final String qrCode;
  final double price;
  final String section;
  final int quantity;

  Ticket({
    required this.id,
    required this.eventName,
    required this.date,
    required this.venue,
    required this.ticketType,
    required this.startTime,
    required this.endTime,
    required this.month,
    required this.day,
    required this.status,
    required this.color,
    required this.secondaryColor,
    required this.qrCode,
    required this.price,
    required this.section,
    required this.quantity,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'] ?? '',
      eventName: json['eventName'] ?? '',
      date: json['date'] ?? '',
      venue: json['venue'] ?? '',
      ticketType: json['ticketType'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      month: json['month'] ?? '',
      day: json['day'] ?? '',
      status: json['status'] ?? '',
      color: _parseColor(json['color']),
      secondaryColor: _parseColor(json['secondaryColor']),
      qrCode: json['qrCode'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      section: json['section'] ?? '',
      quantity: json['quantity'] ?? 1,
    );
  }

  static Color _parseColor(dynamic color) {
    if (color is String) {
      final buffer = StringBuffer();
      if (color.length == 6 || color.length == 7) buffer.write('ff');
      buffer.write(color.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    }
    return const Color(0xFF6C63FF);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventName': eventName,
      'date': date,
      'venue': venue,
      'ticketType': ticketType,
      'startTime': startTime,
      'endTime': endTime,
      'month': month,
      'day': day,
      'status': status,
      'color': color.value.toRadixString(16),
      'secondaryColor': secondaryColor.value.toRadixString(16),
      'qrCode': qrCode,
      'price': price,
      'section': section,
      'quantity': quantity,
    };
  }

  Ticket copyWith({
    String? status,
  }) {
    return Ticket(
      id: id,
      eventName: eventName,
      date: date,
      venue: venue,
      ticketType: ticketType,
      startTime: startTime,
      endTime: endTime,
      month: month,
      day: day,
      status: status ?? this.status,
      color: color,
      secondaryColor: secondaryColor,
      qrCode: qrCode,
      price: price,
      section: section,
      quantity: quantity,
    );
  }
}
