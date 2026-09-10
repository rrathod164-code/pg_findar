import 'package:flutter/material.dart';
import '../../models/pg_model.dart';
import '../../services/data_service.dart';

class AdminHomeTab extends StatelessWidget {
  final ValueChanged<int> onSelectTab;
  final VoidCallback onOpenDrawer;
  final VoidCallback onOpenNotifications;

  const AdminHomeTab({
    super.key,
    required this.onSelectTab,
    required this.onOpenDrawer,
    required this.onOpenNotifications,
  });

  static const Color brandTeal = Color(0xFF13B99D);

  Widget _buildMetricCard({
    required Widget iconWidget,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: brandTeal.withValues(alpha: 0.08),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 40, child: Center(child: iconWidget)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayBookingCard(BuildContext context, PGBooking booking) {
    return InkWell(
      onTap: () => _showBookingDetailsSheet(context, booking),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                booking.pg.imageUrl,
                width: 78,
                height: 78,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => Container(
                  width: 78,
                  height: 78,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.business, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    booking.pg.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    booking.pg.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8B9CB0),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFB0BEC5), size: 24),
          ],
        ),
      ),
    );
  }

  void _showBookingDetailsSheet(BuildContext context, PGBooking booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    booking.pg.imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.pg.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        booking.pg.location,
                        style:
                            const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 30),
            _buildDetailRow('Booking ID', '#${booking.id}'),
            _buildDetailRow('Room Type', booking.roomType),
            _buildDetailRow('Status', booking.status),
            _buildDetailRow('Date Range', booking.dateRangeFormatted),
            _buildDetailRow('Rent Paid', '₹${booking.totalPaid.toInt()}'),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.redAccent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      DataService().cancelBooking(booking.id);
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Booking marked as Cancelled'),
                        ),
                      );
                    },
                    child: const Text(
                      'Cancel Booking',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandTeal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      DataService()
                          .updateBookingStatus(booking.id, 'Confirmed');
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Booking Verified & Confirmed'),
                          backgroundColor: brandTeal,
                        ),
                      );
                    },
                    child: const Text(
                      'Confirm',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<PGBooking>>(
      valueListenable: DataService().bookingsNotifier,
      builder: (context, bookings, _) {
        const totalUsersCount = 250;
        const bookingsCount = 120;
        const pgsCount = 45;
        const revenueString = '3,90,000';

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // Top Action Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.menu,
                      size: 28,
                      color: Colors.black87,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: onOpenDrawer,
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.notifications_none_rounded,
                          size: 28,
                          color: Colors.black87,
                        ),
                        onPressed: onOpenNotifications,
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => onSelectTab(4), // Go to More
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4D8DD),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: Color(0xFF5A6A7E),
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Welcome Back, Admin Greeting
              const Text(
                'Welcome Back,',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Admin',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Manage your PG properties efficiently',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF7A929E),
                ),
              ),
              const SizedBox(height: 24),

              // 2x2 Metric Cards Grid
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      iconWidget: const Icon(
                        Icons.person_outline_rounded,
                        color: brandTeal,
                        size: 38,
                      ),
                      title: 'Total Users',
                      value: '$totalUsersCount',
                      onTap: () => onSelectTab(1),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildMetricCard(
                      iconWidget: const Icon(
                        Icons.book_outlined,
                        color: brandTeal,
                        size: 36,
                      ),
                      title: 'Bookings',
                      value: '$bookingsCount',
                      onTap: () => onSelectTab(2),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      iconWidget: const Icon(
                        Icons.home_outlined,
                        color: brandTeal,
                        size: 38,
                      ),
                      title: 'PGs',
                      value: '$pgsCount',
                      onTap: () => onSelectTab(3),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildMetricCard(
                      iconWidget: const Text(
                        '₹',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: brandTeal,
                          height: 1.1,
                        ),
                      ),
                      title: 'Revenue',
                      value: revenueString,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Monthly Revenue: ₹3,90,000 across 45 PG properties',
                            ),
                            backgroundColor: brandTeal,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 26),

              // Section Header: "Todays booking"
              const Text(
                'Todays booking',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: -0.2,
                ),
              ),

              const SizedBox(height: 14),

              // Todays Booking Cards List
              if (bookings.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      'No bookings available today',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: bookings.length > 3 ? 3 : bookings.length,
                  separatorBuilder: (ctx, i) => const SizedBox(height: 12),
                  itemBuilder: (ctx, index) {
                    final booking = bookings[index];
                    return _buildTodayBookingCard(context, booking);
                  },
                ),

              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }
}
