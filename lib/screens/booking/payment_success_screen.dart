import 'package:flutter/material.dart';
import '../../resources/theme.dart';
import '../user/user_home_screen.dart';
import '../../widgets/app_image.dart';
import '../../widgets/user_bottom_nav_bar.dart';
import '../../widgets/dashboard_background.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final PGAccommodation? pg;
  final int totalAmount;
  final String duration;
  final int members;
  final String dateString;
  final String transactionId;
  final PGRoom? selectedRoom;

  const PaymentSuccessScreen({
    super.key,
    this.pg,
    this.totalAmount = 39000,
    this.duration = '6 Months',
    this.members = 1,
    this.dateString = '25 July 2026',
    this.transactionId = 'TXN9876543210',
    this.selectedRoom,
  });

  @override
  Widget build(BuildContext context) {
    final String pgName = pg?.name ?? 'Green Valley PG';
    final String pgLocation = pg?.location ?? 'Kalawad Road, Rajkot';
    final String pgImage = (pg?.imageUrl != null && pg!.imageUrl.isNotEmpty)
        ? pg!.imageUrl
        : AppPlaceholders.defaultPgImage;

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

                Center(
                  child: Container(
                    width: 95,
                    height: 95,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 74,
                        height: 74,
                        decoration: const BoxDecoration(
                          color: primaryGreen,
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

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF091A2A).withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 5),
                      ),
                      BoxShadow(
                        color: const Color(0xFF091A2A).withValues(alpha: 0.03),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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

                            _buildDetailRow(
                              Icons.location_on_outlined,
                              pgLocation,
                            ),
                            const SizedBox(height: 2),

                            _buildDetailRow(
                              Icons.calendar_today_outlined,
                              dateString,
                            ),
                            const SizedBox(height: 2),

                            _buildDetailRow(
                              Icons.calendar_month_outlined,
                              'Duration : $duration',
                            ),
                            const SizedBox(height: 2),

                            _buildDetailRow(
                              Icons.person_outline,
                              '$members Member${members > 1 ? 's' : ''}',
                            ),
                            const SizedBox(height: 2),

                            _buildDetailRow(
                              Icons.meeting_room_outlined,
                              '${selectedRoom?.roomNumber ?? 'Room 102'} (${selectedRoom?.floor ?? '1st Floor'}) • ${selectedRoom?.sharingType ?? 'Double Sharing'}',
                            ),
                            const SizedBox(height: 8),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: const Color(0xFFFDE68A),
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.schedule_rounded,
                                    size: 12,
                                    color: Color(0xFFD97706),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Pending Owner Approval',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFB45309),
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

                const SizedBox(height: 14),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
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

                      Container(
                        width: 1.2,
                        height: 38,
                        color: AppColors.primary.withValues(alpha: 0.3),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                      ),

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

                _buildStepItem(
                  icon: Icons.meeting_room_outlined,
                  title: 'Room Requested',
                  subtitle:
                      '${selectedRoom?.roomNumber ?? 'Room 102'} request sent to owner',
                  showCheckmark: true,
                  showBottomLine: true,
                ),

                _buildStepItem(
                  icon: Icons.verified_user_outlined,
                  title: 'Owner Approves Request',
                  subtitle: 'Owner will verify & confirm your room assignment',
                  showCheckmark: false,
                  showBottomLine: true,
                ),

                _buildStepItem(
                  icon: Icons.home_outlined,
                  title: 'Visit, Pay & Move In',
                  subtitle:
                      'Visit the PG, pay cash & move in on\nyour selected date',
                  showCheckmark: false,
                  showBottomLine: false,
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: () {
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

                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: () {
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
        Column(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primaryDark, size: 20),
            ),
            if (showBottomLine)
              Container(
                width: 1.5,
                height: 22,
                color: AppColors.primary.withValues(alpha: 0.4),
              ),
          ],
        ),

        const SizedBox(width: 14),

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

        if (showCheckmark)
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.check_circle, color: AppColors.primary, size: 20),
          ),
      ],
    );
  }
}
