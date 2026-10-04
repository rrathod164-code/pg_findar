import 'package:flutter/material.dart';
import 'package:pg_findar/resources/owner_theme.dart';

class OwnerEarningsScreen extends StatelessWidget {
  const OwnerEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Earnings & Payouts',
          style: TextStyle(
            color: OwnerColors.textHeading,
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Revenue Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [OwnerColors.primary, OwnerColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: OwnerColors.primary.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Total Net Earnings',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '₹ 1,25,500',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Next Payout Scheduled: 15 Oct 2025',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Monthly Breakdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: OwnerColors.textDark,
              ),
            ),
            const SizedBox(height: 12),

            _buildMonthlyItem('September 2025', '₹ 45,500', '12 Bookings'),
            _buildMonthlyItem('August 2025', '₹ 42,000', '10 Bookings'),
            _buildMonthlyItem('July 2025', '₹ 38,000', '8 Bookings'),

            const SizedBox(height: 24),

            const Text(
              'Bank Account Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: OwnerColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.account_balance_rounded,
                    color: OwnerColors.primary,
                    size: 32,
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HDFC Bank •••• 4589',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          'Primary Account for Direct Deposit',
                          style: TextStyle(
                            color: OwnerColors.textGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.check_circle_rounded, color: OwnerColors.primary),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }

  Widget _buildMonthlyItem(String month, String amount, String sub) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                month,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                sub,
                style: const TextStyle(color: OwnerColors.textGrey, fontSize: 12),
              ),
            ],
          ),
          Text(
            amount,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: OwnerColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
