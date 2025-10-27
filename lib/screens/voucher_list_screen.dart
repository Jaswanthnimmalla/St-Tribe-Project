import 'package:flutter/material.dart';
import 'package:level1/order_payment_screens.dart';
import 'package:provider/provider.dart';
import '../providers/voucher_provider.dart';
import '../widgets/voucher_card.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/error_widget.dart';
import '../widgets/custom_bottom_nav.dart';
import '../utils/constants.dart';
import '../utils/responsive.dart';
import 'voucher_detail_screen.dart';
import 'my_tickets_screen.dart';

class VoucherListScreen extends StatefulWidget {
  @override
  _VoucherListScreenState createState() => _VoucherListScreenState();
}

class _VoucherListScreenState extends State<VoucherListScreen> {
  final TextEditingController _searchController = TextEditingController();
  late VoucherProvider _voucherProvider;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _voucherProvider = Provider.of<VoucherProvider>(context, listen: false);
      _voucherProvider.loadVouchers();
    });
  }

  void _onSearchChanged() {
    _voucherProvider.searchVouchers(_searchController.text);
  }

  void _clearSearch() {
    _searchController.clear();
    _voucherProvider.clearSearch();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildActiveDealsSection(BuildContext context) {
    final voucherProvider = Provider.of<VoucherProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.yourActiveDeals,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                'See More',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            bool isWide = constraints.maxWidth > 600;
            if (isWide) {
              return Row(
                children: [
                  Expanded(
                    child: _buildDealCard(
                        context,
                        voucherProvider.activeVouchers.length.toString(),
                        'Available Voucher',
                        '${voucherProvider.expiredVouchers.length} Expiring Soon',
                        true),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildDealCard(context, '13', 'Event Subscriptions',
                        '10 Ongoing Soon', true),
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildDealCard(
                            context,
                            voucherProvider.activeVouchers.length.toString(),
                            'Available Voucher',
                            '${voucherProvider.expiredVouchers.length} Expiring Soon',
                            true),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildDealCard(context, '13',
                            'Event Subscriptions', '10 Ongoing Soon', true),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDealCard(context, '4', 'Expiring Soon',
                            '2 Almost Gone', false),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildDealCard(context, '10', 'Ongoing Soon',
                            '5 Starting Today', false),
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildDealCard(BuildContext context, String value, String title,
      String subtitle, bool showProgress) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          if (showProgress) ...[
            SizedBox(height: 8),
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Stack(
                children: [
                  Container(
                    width: 60,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.getPadding(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          AppStrings.appName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert,
                color: Theme.of(context).colorScheme.onSurface),
            onSelected: (String value) {
              _handleMenuSelection(context, value);
            },
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
              PopupMenuItem<String>(
                value: 'products',
                child: Row(
                  children: [
                    Icon(Icons.shopping_bag,
                        color: Theme.of(context).colorScheme.onSurface),
                    SizedBox(width: 12),
                    Text('Products'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<VoucherProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading && provider.vouchers.isEmpty) {
              return LoadingShimmer();
            }

            if (provider.hasError && provider.vouchers.isEmpty) {
              return CustomErrorWidget(
                error: provider.error!,
                onRetry: provider.retry,
              );
            }

            return SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: padding, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey, size: 20),
                          SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: AppStrings.searchVoucher,
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            IconButton(
                              icon: Icon(Icons.clear, size: 20),
                              onPressed: _clearSearch,
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),

                    // Active Deals Section
                    _buildActiveDealsSection(context),
                    SizedBox(height: 24),

                    // Promo Code Banner
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.local_offer_outlined,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              AppStrings.promoCodeHint,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),

                    // Vouchers List
                    Text(
                      'Available Vouchers (${provider.vouchers.length})',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 16),

                    if (provider.vouchers.isEmpty && !provider.isLoading)
                      Center(
                        child: Column(
                          children: [
                            Icon(Icons.local_offer_outlined,
                                size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No vouchers available',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: provider.vouchers.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final voucher = provider.vouchers[index];
                          return VoucherCard(
                            voucher: voucher,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      VoucherDetailScreen(voucher: voucher),
                                ),
                              );
                            },
                          );
                        },
                      ),
                  ],
                ),
              ),
            );
          },
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
      case 'products':
        // Navigate to products screen
        break;
    }
  }
}
