import 'package:flutter/material.dart';
import '../../models/pg_model.dart';
import '../../resources/theme.dart';
import '../../widgets/app_image.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/dashboard_background.dart';

/// ============================================================================
/// PAYMENT SUCCESS SCREEN (BEGINNER-FRIENDLY UI)
/// ============================================================================
/// Displays the booking confirmation and next steps.
/// Pure UI code with clean comments, no backend needed!
/// ============================================================================

class PaymentSuccessScreen extends StatelessWidget {
  final PGAccommodation? pg;
  final int totalAmount;
  final String duration;
  final int members;
  final String dateString;
  final String transactionId;

  const PaymentSuccessScreen({
    super.key,
    this.pg,
    this.totalAmount = 39000,
    this.duration = '6 Months',
    this.members = 1,
    this.dateString = '25 July 2026',
    this.transactionId = 'TXN9876543210',
  });

  @override
  Widget build(BuildContext context) {
    // PG information
    final String pgName = pg?.name ?? 'Green Valley PG';
    final String pgLocation = pg?.location ?? 'Kalawad Road, Rajkot';
    final String pgImage = (pg?.imageUrl != null && pg!.imageUrl.isNotEmpty)
        ? pg!.imageUrl
        : 'assets/images/GreenVally.png';

    const Color primaryGreen = AppColors.primary;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DashboardBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              children: [
                const SizedBox(height: 10),

                // ==============================================================
                // 1. TOP BIG GREEN CHECKMARK BADGE
                // ==============================================================
                Center(
                  child: Container(
                    width: 95,
                    height: 95,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.25), // Soft green outer circle
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 74,
                        height: 74,
                        decoration: const BoxDecoration(
                          color: primaryGreen, // Vibrant green inner circle
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 44,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ==============================================================
                // 2. SUCCESS TITLE & SUBTITLE (CASH ON DELIVERY)
                // ==============================================================
                const Text(
                  'Your Booking is Confirmed!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Payment Mode: Cash on Delivery (Pay at check-in)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4B5563),
                  ),
                ),

                const SizedBox(height: 20),

                // ==============================================================
                // 3. PG BOOKING SUMMARY CARD
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // PG Image Thumbnail
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: AppImage(
                          imageUrl: pgImage,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // PG Name, Location, Date, Duration, Members
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
                            const SizedBox(height: 4),

                            // Location row
                            _buildDetailRow(
                              Icons.location_on_outlined,
                              pgLocation,
                            ),
                            const SizedBox(height: 2),

                            // Date row
                            _buildDetailRow(
                              Icons.calendar_today_outlined,
                              dateString,
                            ),
                            const SizedBox(height: 2),

                            // Duration row
                            _buildDetailRow(
                              Icons.calendar_month_outlined,
                              'Duration : $duration',
                            ),
                            const SizedBox(height: 2),

                            // Member row
                            _buildDetailRow(
                              Icons.person_outline,
                              '$members Member${members > 1 ? 's' : ''}',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ==============================================================
                // 4. PAY ON DELIVERY AMOUNT & PAYMENT METHOD CARD
                // ==============================================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight, // Mint tinted background
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      // Left side: Pay on Delivery Amount
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pay on Delivery',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹$totalAmount',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: primaryGreen,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Vertical Divider
                      Container(
                        width: 1.2,
                        height: 38,
                        color: AppColors.primary.withValues(alpha: 0.3),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                      ),

                      // Right side: Payment Method (Cash on Delivery)
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Payment Method',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Cash on Delivery',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // ==============================================================
                // 5. "WHAT'S NEXT ?" SECTION
                // ==============================================================
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'What’s Next ?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Step 1: Booking Confirmed
                _buildStepItem(
                  icon: Icons.bookmark_outline,
                  title: 'Booking Confirmed',
                  subtitle: 'We have sent your booking details',
                  showCheckmark: true,
                  showBottomLine: true,
                ),

                // Step 2: Owner Will Contact You
                _buildStepItem(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'Owner Will Contact You',
                  subtitle: 'The PG owner will contact you soon',
                  showCheckmark: false,
                  showBottomLine: true,
                ),

                // Step 3: Visit, Pay & Move In (Cash on Delivery)
                _buildStepItem(
                  icon: Icons.home_outlined,
                  title: 'Visit, Pay & Move In',
                  subtitle:
                      'Visit the PG, pay cash & move in on\nyour selected date',
                  showCheckmark: false,
                  showBottomLine: false,
                ),

                const SizedBox(height: 24),

                // ==============================================================
                // 6. ACTION BUTTONS ROW ("VIEW BOOKING" & "BACK TO HOME")
                // ==============================================================
                Row(
                  children: [
                    // Left Button: View Booking
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to user's bookings tab in dashboard
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const BottomNavScreen(initialIndex: 2),
                              ),
                              (route) => false,
                            );
                          },
                          icon: const Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                          ),
                          label: const Text(
                            'View booking',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Right Button: Back to Home
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Redirect directly to the user Home page
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const BottomNavScreen(initialIndex: 0),
                              ),
                              (route) => false,
                            );
                          },
                          icon: const Icon(Icons.home_outlined, size: 16),
                          label: const Text(
                            'Back to home',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: primaryGreen,
                            side: const BorderSide(
                              color: primaryGreen,
                              width: 1.5,
                            ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget: Small row with icon and text in PG card
  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF6B7280)),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Helper widget: Step Item in "What's Next ?" section
  Widget _buildStepItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool showCheckmark,
    required bool showBottomLine,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step Icon Circle + Connecting Line
        Column(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.primaryLight, // Soft mint circle
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.primaryDark, // Dark emerald icon
                size: 20,
              ),
            ),
            if (showBottomLine)
              Container(
                width: 1.5,
                height: 22,
                color: AppColors.primary.withValues(alpha: 0.4), // Connecting line
              ),
          ],
        ),

        const SizedBox(width: 14),

        // Step Title and Description
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF6B7280),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Green Checkmark icon for completed step
        if (showCheckmark)
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.check_circle, color: AppColors.primary, size: 20),
          ),
      ],
    );
  }
}
