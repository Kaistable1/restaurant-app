import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/models/badge_model.dart';
import 'package:kaistable_website/models/transaction_model.dart';
import 'package:kaistable_website/services/monetization_service.dart';

class MonetizationScreen extends StatefulWidget {
  const MonetizationScreen({Key? key}) : super(key: key);

  @override
  State<MonetizationScreen> createState() => _MonetizationScreenState();
}

class _MonetizationScreenState extends State<MonetizationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final MonetizationService _monetizationService = MonetizationService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        title: Text(
          'Premium Features',
          style: TextStyle(
            fontSize: 17,
            color: AppColors.bottomSheetColor,
            fontWeight: FontWeight.w700,
            fontFamily: 'Nunito-Bold',
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primaryColor,
          tabs: [
            Tab(text: 'Badges'),
            Tab(text: 'Transactions'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBadgesTab(),
          _buildTransactionsTab(),
        ],
      ),
    );
  }

  Widget _buildBadgesTab() {
    return StreamBuilder<List<BadgeModel>>(
      stream: _monetizationService.getAvailableBadges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        // Show placeholder badges if no data
        final badges = snapshot.hasData && snapshot.data!.isNotEmpty
            ? snapshot.data!
            : _getPlaceholderBadges();

        return ListView(
          padding: EdgeInsets.all(16),
          children: [
            _buildHeaderSection(),
            SizedBox(height: 24),
            ...badges.map((badge) => _buildBadgeCard(badge)),
          ],
        );
      },
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryColor, AppColors.primaryColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.stars, color: Colors.white, size: 32),
              SizedBox(width: 12),
              Text(
                'Premium Badges',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Nunito-Bold',
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'Stand out with exclusive badges and show your support for the community!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontFamily: 'Nunito-Regular',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeCard(BadgeModel badge) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.emoji_events,
                size: 32,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    badge.name ?? 'Badge',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito-Bold',
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    badge.description ?? 'Premium badge',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontFamily: 'Nunito-Regular',
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '\$${badge.price?.toStringAsFixed(2) ?? '0.00'}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                          fontFamily: 'Nunito-Bold',
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        badge.currency ?? 'USD',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontFamily: 'Nunito-Regular',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => _showPurchaseDialog(badge),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(
                'Buy',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Nunito-Bold',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsTab() {
    return StreamBuilder<List<TransactionModel>>(
      stream: _monetizationService.getUserTransactions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyTransactions();
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return _buildTransactionCard(snapshot.data![index]);
          },
        );
      },
    );
  }

  Widget _buildTransactionCard(TransactionModel transaction) {
    IconData icon;
    Color iconColor;

    switch (transaction.type) {
      case 'badge_purchase':
        icon = Icons.emoji_events;
        iconColor = Colors.amber;
        break;
      case 'tip':
        icon = Icons.card_giftcard;
        iconColor = Colors.green;
        break;
      default:
        icon = Icons.payment;
        iconColor = Colors.blue;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.2),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          _getTransactionTitle(transaction),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Nunito-Bold',
          ),
        ),
        subtitle: Text(
          _formatDate(transaction.createdAt),
          style: TextStyle(fontFamily: 'Nunito-Regular'),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${transaction.amount?.toStringAsFixed(2) ?? '0.00'}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Nunito-Bold',
              ),
            ),
            _buildStatusBadge(transaction.status ?? 'pending'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'completed':
        color = Colors.green;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      case 'failed':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.bold,
          fontFamily: 'Nunito-Bold',
        ),
      ),
    );
  }

  Widget _buildEmptyTransactions() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          SizedBox(height: 16),
          Text(
            'No transactions yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
              fontFamily: 'Nunito-Bold',
            ),
          ),
        ],
      ),
    );
  }

  String _getTransactionTitle(TransactionModel transaction) {
    switch (transaction.type) {
      case 'badge_purchase':
        return 'Badge Purchase';
      case 'tip':
        return 'Tip Sent';
      default:
        return 'Payment';
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays < 1) {
      return 'Today';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  Future<void> _showPurchaseDialog(BadgeModel badge) async {
    String selectedPaymentMethod = 'Stripe';

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            'Purchase Badge',
            style: TextStyle(fontFamily: 'Nunito-Bold'),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                badge.name ?? 'Badge',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito-Bold',
                ),
              ),
              SizedBox(height: 8),
              Text(
                badge.description ?? '',
                style: TextStyle(fontFamily: 'Nunito-Regular'),
              ),
              SizedBox(height: 16),
              Text(
                'Price: \$${badge.price?.toStringAsFixed(2) ?? '0.00'}',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Nunito-Bold',
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Payment Method:',
                style: TextStyle(fontFamily: 'Nunito-Bold'),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedPaymentMethod,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: ['Stripe', 'PayPal'].map((method) {
                  return DropdownMenuItem(
                    value: method,
                    child: Row(
                      children: [
                        Icon(
                          method == 'Stripe' ? Icons.credit_card : Icons.account_balance_wallet,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(method, style: TextStyle(fontFamily: 'Nunito-Regular')),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.blue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This is a demo. No actual payment will be processed.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.blue[900],
                          fontFamily: 'Nunito-Regular',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _processPurchase(badge, selectedPaymentMethod);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
              ),
              child: Text(
                'Purchase',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Nunito-Bold',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processPurchase(BadgeModel badge, String paymentMethod) async {
    // Show loading
    Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // Create payment intent (stub)
      Map<String, dynamic> paymentIntent;
      if (paymentMethod == 'Stripe') {
        paymentIntent = await _monetizationService.createStripePaymentIntent(
          amount: badge.price ?? 0.0,
          currency: badge.currency ?? 'USD',
        );
      } else {
        paymentIntent = await _monetizationService.createPayPalOrder(
          amount: badge.price ?? 0.0,
          currency: badge.currency ?? 'USD',
        );
      }

      // Create transaction record
      final transactionID = await _monetizationService.purchaseBadge(
        badgeID: badge.badgeID ?? '',
        amount: badge.price ?? 0.0,
        paymentMethod: paymentMethod.toLowerCase(),
      );

      // Simulate payment completion
      await Future.delayed(Duration(seconds: 2));

      if (transactionID != null) {
        await _monetizationService.completeTransaction(
          transactionID,
          paymentIntent['paymentIntentID'] ?? paymentIntent['orderID'] ?? '',
        );
      }

      Get.back(); // Close loading

      Get.snackbar(
        'Success',
        'Badge purchased successfully! (Demo mode)',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.back(); // Close loading
      Get.snackbar(
        'Error',
        'Purchase failed: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  List<BadgeModel> _getPlaceholderBadges() {
    return [
      BadgeModel(
        badgeID: 'badge_1',
        name: 'Food Explorer',
        description: 'Show your passion for discovering new restaurants',
        price: 2.99,
        currency: 'USD',
        isActive: true,
      ),
      BadgeModel(
        badgeID: 'badge_2',
        name: 'Taste Master',
        description: 'Demonstrate your refined culinary taste',
        price: 4.99,
        currency: 'USD',
        isActive: true,
      ),
      BadgeModel(
        badgeID: 'badge_3',
        name: 'Community Champion',
        description: 'Support the community and stand out',
        price: 9.99,
        currency: 'USD',
        isActive: true,
      ),
    ];
  }
}
