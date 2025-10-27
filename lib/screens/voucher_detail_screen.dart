import 'package:flutter/material.dart';
import 'package:level1/models/voucher_model.dart';

import '../widgets/custom_bottom_nav.dart';
import '../utils/constants.dart';
import '../utils/responsive.dart';
import 'my_tickets_screen.dart';
import 'order_details_screen.dart';

class VoucherDetailScreen extends StatelessWidget {
  final Voucher voucher;

  const VoucherDetailScreen({Key? key, required this.voucher})
      : super(key: key);

  void _copyToClipboard(BuildContext context, String text) {
    // In a real app, use clipboard package
    // FlutterClipboard.copy(text).then((_) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Code copied to clipboard!'),
          ],
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: AppColors.success,
      ),
    );
    // });
  }

  Widget _buildDetailRow(BuildContext context, String title, String value,
      {Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 600;
          if (isWideScreen) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    value,
                    style: TextStyle(
                      color:
                          valueColor ?? Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color:
                        valueColor ?? Theme.of(context).colorScheme.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildTermItem(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: EdgeInsets.only(top: 6, right: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.getPadding(context);
    final imageHeight = Responsive.getImageHeight(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          AppStrings.voucherDetails,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert,
                color: Theme.of(context).colorScheme.onSurface),
            onSelected: (value) => _handleMenuSelection(context, value),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'my_tickets',
                child: Row(
                  children: [
                    Icon(Icons.confirmation_number,
                        color: Theme.of(context).colorScheme.onSurface),
                    SizedBox(width: 12),
                    Text('My Tickets'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'order_details',
                child: Row(
                  children: [
                    Icon(Icons.receipt_long,
                        color: Theme.of(context).colorScheme.onSurface),
                    SizedBox(width: 12),
                    Text('Order Details'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Voucher Card
                Hero(
                  tag: 'voucher_${voucher.id}',
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      children: [
                        Container(
                          height: imageHeight,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(16)),
                            image: DecorationImage(
                              image: NetworkImage(voucher.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16)),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black54,
                                ],
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  voucher.title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(padding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow(
                                context,
                                'Valid Period:',
                                '${voucher.validFrom} - ${voucher.validTo}',
                                valueColor: voucher.isExpired
                                    ? AppColors.error
                                    : AppColors.success,
                              ),
                              _buildDetailRow(
                                context,
                                'Available Vouchers:',
                                '${voucher.activeVouchers} Active',
                                valueColor: AppColors.success,
                              ),
                              _buildDetailRow(
                                context,
                                'Minimum Purchase:',
                                voucher.minPurchase,
                              ),
                              _buildDetailRow(
                                context,
                                'Maximum Discount:',
                                voucher.maxDiscount,
                              ),
                              SizedBox(height: 16),

                              // Code Section
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.primary.withOpacity(0.1),
                                      AppColors.secondary.withOpacity(0.1),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color:
                                          AppColors.primary.withOpacity(0.3)),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.local_offer,
                                        color: AppColors.primary, size: 24),
                                    SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Voucher Code',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          voucher.code,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    ElevatedButton(
                                      onPressed: () => _copyToClipboard(
                                          context, voucher.code),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.content_copy, size: 16),
                                          SizedBox(width: 6),
                                          Text('Copy'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Terms & Conditions
                Text(
                  'Terms & Conditions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 16),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTermItem(context,
                            'Minimum Purchase: This coupon is valid for a minimum purchase of ${voucher.minPurchase}.'),
                        _buildTermItem(context,
                            'Discount Amount: By using this coupon, you will receive a discount of ${voucher.maxDiscount}.'),
                        _buildTermItem(context,
                            'Valid for Promotional Menu: Please note that this coupon cannot be used for items on our promotional event.'),
                        _buildTermItem(context,
                            'Validity Period: This coupon is valid for a limited time. Please make sure to use it before the expiration date.'),
                        _buildTermItem(context,
                            'Coupon Usage: To redeem this coupon, enter the coupon code during the online checkout process.'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(currentIndex: 1),
    );
  }

  void _handleMenuSelection(BuildContext context, String value) {
    switch (value) {
      case 'my_tickets':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyTicketsScreen()),
        );
        break;
      case 'order_details':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrderDetailsScreen()),
        );
        break;
    }
  }
}
