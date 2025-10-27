class Voucher {
  final String id;
  final String title;
  final String description;
  final String expiryDate;
  final String minPurchase;
  final String maxDiscount;
  final String code;
  final String validFrom;
  final String validTo;
  final int activeVouchers;
  final String category;
  final String imageUrl;
  final bool isExpired;

  Voucher({
    required this.id,
    required this.title,
    required this.description,
    required this.expiryDate,
    required this.minPurchase,
    required this.maxDiscount,
    required this.code,
    required this.validFrom,
    required this.validTo,
    required this.activeVouchers,
    required this.category,
    required this.imageUrl,
    required this.isExpired,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      expiryDate: json['expiryDate'] ?? '',
      minPurchase: json['minPurchase'] ?? '',
      maxDiscount: json['maxDiscount'] ?? '',
      code: json['code'] ?? '',
      validFrom: json['validFrom'] ?? '',
      validTo: json['validTo'] ?? '',
      activeVouchers: json['activeVouchers'] ?? 0,
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      isExpired: json['isExpired'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'expiryDate': expiryDate,
      'minPurchase': minPurchase,
      'maxDiscount': maxDiscount,
      'code': code,
      'validFrom': validFrom,
      'validTo': validTo,
      'activeVouchers': activeVouchers,
      'category': category,
      'imageUrl': imageUrl,
      'isExpired': isExpired,
    };
  }
}
