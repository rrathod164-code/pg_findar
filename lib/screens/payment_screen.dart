import 'package:flutter/material.dart';
import '../models/pg_model.dart';
import '../widgets/app_image.dart';
import '../widgets/dashboard_background.dart';
import 'payment_success_screen.dart';

/// ============================================================================
/// PAYMENT SCREEN (BEGINNER-FRIENDLY UI)
/// ============================================================================
/// This screen displays the payment summary and options.
/// Per your requirement: ONLY "Cash on Delivery" (Cash payment) is allowed.
/// Pure UI code with clean comments, no backend needed!
/// ============================================================================

class PaymentScreen extends StatefulWidget {
  final PGAccommodation? pg;
  final int totalAmount;
  final String duration;
  final int members;

  const PaymentScreen({
    super.key,
    this.pg,
    this.totalAmount = 39000,
    this.duration = '6 Months',
    this.members = 1,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    // PG information
    final String pgName = widget.pg?.name ?? 'Green Valley PG';
    final String pgLocation = widget.pg?.location ?? 'Kalawad Road, Rajkot';
    final int monthlyPrice = widget.pg?.price.toInt() ?? 6500;
    final String pgImage =
        (widget.pg?.imageUrl != null && widget.pg!.imageUrl.isNotEmpty)
        ? widget.pg!.imageUrl
        : 'assets/images/GreenVally.png';

    const Color primaryGreen = Color(0xFF10B981);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DashboardBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==============================================================
                // 1. TOP BAR (BACK BUTTON & "PAYMENT" TITLE)
                // ==============================================================
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Text(
                      'Payment',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ==============================================================
                // 2. SAFE & SECURE BANNER
                // ==============================================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFD1FAE5), // Soft green border
                      width: 1.2,
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        color: primaryGreen,
                        size: 22,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Your booking is safe and secure',
                        style: TextStyle(
                          color: primaryGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ==============================================================
                // 3. PG SUMMARY CARD
                // ==============================================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // PG Image Thumbnail
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: AppImage(
                          imageUrl: pgImage,
                          width: 75,
                          height: 75,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 14),

                      // PG Name & Location
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pgName,
                              style: const TextStyle(
                                fontSize: 16.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              pgLocation,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF8692A6),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ==============================================================
                // 4. AMOUNT DETAILS CARD
                // ==============================================================
                const Text(
                  'Amount Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Monthly Rent Row
                      _buildAmountRow(
                        'Monthly Rent  (₹$monthlyPrice X 6)',
                        '₹${widget.totalAmount}',
                      ),
                      const SizedBox(height: 8),

                      // Security Deposit Row
                      _buildAmountRow('Security Deposit', '₹5000'),
                      const SizedBox(height: 8),

                      // Service Fee Row
                      _buildAmountRow('Service Fee', '₹0'),
                      const SizedBox(height: 10),

                      // Dotted divider line
                      Row(
                        children: List.generate(
                          35,
                          (index) => Expanded(
                            child: Container(
                              color: index % 2 == 0
                                  ? const Color(0xFFCBD5E1)
                                  : Colors.transparent,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Total Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total (Approx.)',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '₹${widget.totalAmount}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ==============================================================
                // 5. SELECT PAYMENT METHOD (CASH ON DELIVERY ONLY)
                // ==============================================================
                const Text(
                  'Select Payment Method',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),

                // Option 5: CASH ON DELIVERY (ACTIVE & ALLOWED OPTION)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: primaryGreen, // Highlighted with green border
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryGreen.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Cash Icon Box
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8FAF3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.payments_outlined,
                          color: primaryGreen,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Title & Description
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cash on Delivery',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Pay in cash during your visit / check-in',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Green Selected Checkmark
                      const Icon(
                        Icons.check_circle,
                        color: primaryGreen,
                        size: 24,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ==============================================================
                // 6. BOTTOM BUTTON: "PAY NOW ₹39,000"
                // ==============================================================
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to the Payment Success confirmation screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentSuccessScreen(
                            pg: widget.pg,
                            totalAmount: widget.totalAmount,
                            duration: widget.duration,
                            members: widget.members,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_outline, size: 20),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Confirm Booking',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for Amount Detail rows
  Widget _buildAmountRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4B5563),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
