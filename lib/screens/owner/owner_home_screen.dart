import 'package:flutter/material.dart';
import 'package:pg_findar/models/pg_model.dart';
import 'package:pg_findar/services/api_service.dart';
import 'package:pg_findar/widgets/app_image.dart';
import 'package:pg_findar/widgets/dashboard_background.dart';

class OwnerHomeTab extends StatelessWidget {
  final VoidCallback onViewAllBookings;

  const OwnerHomeTab({super.key, required this.onViewAllBookings});

  @override
  Widget build(BuildContext context) {
    final dataService = DataService();

    return ValueListenableBuilder<List<PGAccommodation>>(
      valueListenable: dataService.pgsNotifier,
      builder: (context, pgs, _) {
        return ValueListenableBuilder<List<PGBooking>>(
          valueListenable: dataService.bookingsNotifier,
          builder: (context, bookings, _) {
            // Owner properties
            final ownerProperties = pgs
                .where((p) => p.organizerId == 'organizer13' || p.organizerId == 'owner13')
                .toList();
            final propertyCount = ownerProperties.isEmpty
                ? 5
                : ownerProperties.length;

            // Pending booking requests count
            final pendingCount = bookings
                .where((b) => b.status.toLowerCase() == 'pending')
                .length;

            return Scaffold(
              backgroundColor: Colors.transparent,
              body: DashboardBackground(
                child: SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),

                        // Header Bar: "Good Morning, Renisha! 👋" & Avatar
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Good Morning,',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF132230),
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: const [
                                      Text(
                                        'Renisha!',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF132230),
                                          letterSpacing: -0.4,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        '👋',
                                        style: TextStyle(fontSize: 22),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Manage your properties, bookings\nand earnings',
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      color: Color(0xFF637688),
                                      height: 1.3,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Notification bell & Profile Avatar
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.85),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.04,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.notifications_none_rounded,
                                      color: Color(0xFF132230),
                                      size: 24,
                                    ),
                                    onPressed: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'You have $pendingCount pending booking requests to review.',
                                          ),
                                          backgroundColor: const Color(
                                            0xFF13B99D,
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.08,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: AppImage(
                                      imageUrl: 'assets/images/user_avatar.png',
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // 4 Metric Cards (2 x 2 Grid)
                        Row(
                          children: [
                            Expanded(
                              child: _buildMetricCard(
                                icon: Icons.home_rounded,
                                iconColor: const Color(0xFF13B99D),
                                iconBg: const Color(0xFFD2F5EC),
                                value: '$propertyCount',
                                label: 'Properties',
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: _buildMetricCard(
                                icon: Icons.card_giftcard_rounded,
                                iconColor: const Color(0xFFE53935),
                                iconBg: const Color(0xFFFFECEE),
                                value: '24',
                                label: 'Total Bookings',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: _buildMetricCard(
                                icon: Icons.access_time_filled_rounded,
                                iconColor: const Color(0xFFFB8C00),
                                iconBg: const Color(0xFFFFF3E0),
                                value: '$pendingCount',
                                label: 'Pending Requests',
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: _buildMetricCard(
                                icon: Icons.currency_rupee_rounded,
                                iconColor: const Color(0xFF00A896),
                                iconBg: const Color(0xFFDFF8F3),
                                value: '₹ 1,25,500',
                                label: 'Total Earnings',
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // "Recent Bookings" Section Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Recent Bookings',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF132230),
                                letterSpacing: -0.3,
                              ),
                            ),
                            GestureDetector(
                              onTap: onViewAllBookings,
                              child: Row(
                                children: const [
                                  Text(
                                    'View All',
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF13B99D),
                                    ),
                                  ),
                                  SizedBox(width: 2),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    size: 18,
                                    color: Color(0xFF13B99D),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // Recent Bookings List
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: bookings.length > 5 ? 5 : bookings.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final booking = bookings[index];
                            return _buildBookingItemCard(context, booking);
                          },
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF132230),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF758595),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingItemCard(BuildContext context, PGBooking booking) {
    final statusLower = booking.status.toLowerCase();
    Color badgeBg;
    Color badgeText;
    String badgeLabel;

    if (statusLower == 'confirmed' || statusLower == 'approved') {
      badgeBg = const Color(0xFFE6F8F0);
      badgeText = const Color(0xFF27AE60);
      badgeLabel = 'Confirmed';
    } else if (statusLower == 'pending') {
      badgeBg = const Color(0xFFFFF6E0);
      badgeText = const Color(0xFFE67E22);
      badgeLabel = 'Pending';
    } else {
      badgeBg = const Color(0xFFFFECEE);
      badgeText = const Color(0xFFE53935);
      badgeLabel = booking.status;
    }

    return Container(
      padding: const EdgeInsets.all(14),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Property image thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AppImage(
              imageUrl: booking.pg.imageUrl,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 14),

          // Details: Tenant Name, PG Name, Date range, Price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF132230),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  booking.pg.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF758595),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '🚪 ${booking.roomNumber} • ${booking.roomType}',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F766E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  booking.dateRangeFormatted,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8B98A5),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${booking.totalPaid.toInt()}',
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF132230),
                  ),
                ),
              ],
            ),
          ),

          // Status Badge + Quick action
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badgeLabel,
                  style: TextStyle(
                    color: badgeText,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (statusLower == 'pending') ...[
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    _showBookingActionSheet(context, booking);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF13B99D).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Action >',
                      style: TextStyle(
                        color: Color(0xFF13B99D),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _showBookingActionSheet(BuildContext context, PGBooking booking) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Booking Request',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Applicant: ${booking.userName} (${booking.userPhone})',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F8F5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFB8E8DE)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.meeting_room_outlined,
                      size: 16,
                      color: Color(0xFF0D9488),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Requested: ${booking.roomNumber} (${booking.floor}) • ${booking.roomType}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F766E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text('Property: ${booking.pg.name}'),
              const SizedBox(height: 2),
              Text('Dates: ${booking.dateRangeFormatted}'),
              const SizedBox(height: 2),
              Text('Amount: ₹${booking.totalPaid.toInt()}'),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFE53935),
                        side: const BorderSide(color: Color(0xFFE53935)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        DataService().updateBookingStatus(
                          booking.id,
                          'Cancelled',
                        );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Booking request declined.'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: const Text('Decline'),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF13B99D),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        DataService().updateBookingStatus(
                          booking.id,
                          'Confirmed',
                        );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Booking confirmed successfully!'),
                            backgroundColor: Color(0xFF13B99D),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: const Text('Approve'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
      },
    );
  }
}

// Alias for compatibility
typedef OwnerHomeScreen = OwnerHomeTab;
