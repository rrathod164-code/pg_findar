import 'package:flutter/material.dart';
import '../../models/pg_model.dart';
import '../../services/data_service.dart';

class AdminBookingsTab extends StatefulWidget {
  const AdminBookingsTab({super.key});

  @override
  State<AdminBookingsTab> createState() => _AdminBookingsTabState();
}

class _AdminBookingsTabState extends State<AdminBookingsTab> {
  final TextEditingController _bookingSearchController =
      TextEditingController();
  String _bookingSearchQuery = '';
  String _selectedBookingStatus = 'All';

  static const Color brandTeal = Color(0xFF13B99D);

  @override
  void dispose() {
    _bookingSearchController.dispose();
    super.dispose();
  }

  Widget _buildBookingFilterChip(String label) {
    final isSelected =
        _selectedBookingStatus.toLowerCase() == label.toLowerCase();
    return InkWell(
      onTap: () {
        setState(() {
          _selectedBookingStatus = label;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF55E7A4) // Bright mint green
              : const Color(0xFFC7ECE3), // Muted mint
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: const Color(0xFF0F172A),
          ),
        ),
      ),
    );
  }

  Widget _buildAdminBookingCard(PGBooking booking) {
    final priceVal =
        (booking.totalPaid > 0 ? booking.totalPaid : booking.pg.price).toInt();
    final priceStr = priceVal.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );

    Color statusBg;
    Color statusTextColor;
    final statusLower = booking.status.toLowerCase();

    if (statusLower == 'confirmed' || statusLower == 'approved') {
      statusBg = const Color(0xFFBAF5DD);
      statusTextColor = const Color(0xFF109B59);
    } else if (statusLower == 'pending') {
      statusBg = const Color(0xFFFDE68A);
      statusTextColor = const Color(0xFFD97706);
    } else {
      statusBg = const Color(0xFFFCD3D3);
      statusTextColor = const Color(0xFFDC2626);
    }

    return InkWell(
      onTap: () => _showEditBookingStatusModal(booking),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left PG Image
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                booking.pg.imageUrl,
                width: 72,
                height: 72,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => Container(
                  width: 72,
                  height: 72,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.business, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Middle Details: Name, Location, Status Badge
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.pg.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Rajkot, Gujarat',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF8E9FA8),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Status Badge (tappable to edit status)
                  InkWell(
                    onTap: () => _showEditBookingStatusModal(booking),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3.5,
                      ),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            booking.status[0].toUpperCase() +
                                booking.status.substring(1),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: statusTextColor,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 14,
                            color: statusTextColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Right Details: Price & Date
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹ $priceStr',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  booking.customDateRange ?? '23 May 2025',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8E9FA8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditBookingStatusModal(PGBooking booking) {
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
                    width: 64,
                    height: 64,
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
                      const SizedBox(height: 2),
                      const Text(
                        'Rajkot, Gujarat',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Current Status: ${booking.status}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: brandTeal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Change Booking Status',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            _buildStatusActionTile(
              title: 'Confirm Booking',
              subtitle: 'Mark booking as verified and confirmed',
              color: const Color(0xFF109B59),
              bgColor: const Color(0xFFE8F9F1),
              icon: Icons.check_circle_rounded,
              isSelected: booking.status.toLowerCase() == 'confirmed',
              onTap: () {
                DataService().updateBookingStatus(booking.id, 'Confirmed');
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Booking for "${booking.pg.name}" Confirmed'),
                    backgroundColor: const Color(0xFF109B59),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            _buildStatusActionTile(
              title: 'Mark as Pending',
              subtitle: 'Keep booking in review / awaiting user response',
              color: const Color(0xFFD97706),
              bgColor: const Color(0xFFFFFBEB),
              icon: Icons.hourglass_top_rounded,
              isSelected: booking.status.toLowerCase() == 'pending',
              onTap: () {
                DataService().updateBookingStatus(booking.id, 'Pending');
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('Booking for "${booking.pg.name}" set to Pending'),
                    backgroundColor: const Color(0xFFD97706),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            _buildStatusActionTile(
              title: 'Cancel Booking',
              subtitle: 'Reject or cancel this booking request',
              color: const Color(0xFFDC2626),
              bgColor: const Color(0xFFFEF2F2),
              icon: Icons.cancel_rounded,
              isSelected: booking.status.toLowerCase() == 'cancelled',
              onTap: () {
                DataService().updateBookingStatus(booking.id, 'Cancelled');
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Booking for "${booking.pg.name}" Cancelled'),
                    backgroundColor: const Color(0xFFDC2626),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusActionTile({
    required String title,
    required String subtitle,
    required Color color,
    required Color bgColor,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : color.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check, color: color, size: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<PGBooking>>(
      valueListenable: DataService().bookingsNotifier,
      builder: (context, bookings, _) {
        final query = _bookingSearchQuery.trim().toLowerCase();
        final filteredBookings = bookings.where((b) {
          if (_selectedBookingStatus != 'All' &&
              b.status.toLowerCase() != _selectedBookingStatus.toLowerCase()) {
            return false;
          }
          if (query.isEmpty) return true;
          return b.pg.name.toLowerCase().contains(query) ||
              b.pg.location.toLowerCase().contains(query) ||
              b.status.toLowerCase().contains(query) ||
              (b.customDateRange?.toLowerCase().contains(query) ?? false);
        }).toList();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // "Booking" Header
              const Text(
                'Booking',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 14),

              // Search pill matching screenshot
              Container(
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFD6F2EA),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _bookingSearchController,
                  onChanged: (val) {
                    setState(() {
                      _bookingSearchQuery = val;
                    });
                  },
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.black87,
                      size: 22,
                    ),
                    suffixIcon: _bookingSearchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              size: 18,
                              color: Colors.black54,
                            ),
                            onPressed: () {
                              _bookingSearchController.clear();
                              setState(() {
                                _bookingSearchQuery = '';
                              });
                            },
                          )
                        : null,
                    hintText: 'Search users..',
                    hintStyle: const TextStyle(
                      color: Color(0xFF88A89F),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Status Filter Pills
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _buildBookingFilterChip('All'),
                    const SizedBox(width: 8),
                    _buildBookingFilterChip('Confirmed'),
                    const SizedBox(width: 8),
                    _buildBookingFilterChip('Pending'),
                    const SizedBox(width: 8),
                    _buildBookingFilterChip('Cancelled'),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // List of Booking Cards
              Expanded(
                child: filteredBookings.isEmpty
                    ? Center(
                        child: Text(
                          _bookingSearchQuery.isEmpty
                              ? 'No ${_selectedBookingStatus == "All" ? "" : _selectedBookingStatus} bookings found'
                              : 'No bookings matching "$_bookingSearchQuery"',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      )
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 20),
                        itemCount: filteredBookings.length,
                        separatorBuilder: (ctx, i) =>
                            const SizedBox(height: 12),
                        itemBuilder: (ctx, index) {
                          final booking = filteredBookings[index];
                          return _buildAdminBookingCard(booking);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
