import 'package:flutter/material.dart';
import 'package:pg_findar/resources/owner_theme.dart';
import 'package:pg_findar/screens/user/user_booking_screen.dart';

class OwnerBookingsScreen extends StatefulWidget {
  const OwnerBookingsScreen({super.key});

  @override
  State<OwnerBookingsScreen> createState() => _OwnerBookingsScreenState();
}

class _OwnerBookingsScreenState extends State<OwnerBookingsScreen> {
  String _selectedFilter = 'All'; // 'All', 'Pending', 'Confirmed', 'Completed'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Booking Requests',
          style: TextStyle(
            color: OwnerColors.textHeading,
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
            children: [
              // Filter Chips
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildFilterChip('All'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Pending'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Confirmed'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Completed'),
                ],
              ),
            ),
          ),

          Expanded(
            child: Builder(
              builder: (context) {
                final bookings = BookingScreen.sampleBookings;
                var filtered = bookings;
                if (_selectedFilter == 'Pending') {
                  filtered = bookings
                      .where((b) => b.status.toLowerCase() == 'pending')
                      .toList();
                } else if (_selectedFilter == 'Confirmed') {
                  filtered = bookings
                      .where(
                        (b) =>
                            b.status.toLowerCase() == 'confirmed' ||
                            b.status.toLowerCase() == 'approved',
                      )
                      .toList();
                } else if (_selectedFilter == 'Completed') {
                  filtered = bookings
                      .where((b) => b.status.toLowerCase() == 'completed')
                      .toList();
                }

                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      'No bookings found in "$_selectedFilter"',
                      style: const TextStyle(
                        color: OwnerColors.textGrey,
                        fontSize: 15,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final booking = filtered[index];
                    final isPending = booking.status.toLowerCase() == 'pending';

                    return Container(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  booking.userName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: OwnerColors.textDark,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              _buildStatusBadge(booking.status),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.apartment_rounded,
                                size: 15,
                                color: OwnerColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  booking.pg.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: OwnerColors.textDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: OwnerColors.mintBg,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: OwnerColors.mintBorder,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.meeting_room_outlined,
                                  size: 16,
                                  color: OwnerColors.tealMedium,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Requested: ${booking.roomNumber} (${booking.floor}) • ${booking.roomType}',
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      color: OwnerColors.tealDeep,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Dates: ${booking.dateRangeFormatted}',
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: OwnerColors.textGrey,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Phone: ${booking.userPhone} • Total: ₹${booking.totalPaid.toInt()}',
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: OwnerColors.textGrey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          if (isPending) ...[
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: OwnerColors.error,
                                      side: const BorderSide(
                                        color: OwnerColors.errorBorder,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Request declined'),
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    },
                                    child: const Text('Decline'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: OwnerColors.primary,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Request approved!'),
                                          backgroundColor: OwnerColors.primary,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    },
                                    child: const Text('Approve'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? OwnerColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isSelected ? 0.08 : 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : OwnerColors.textGrey,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final lower = status.toLowerCase();
    Color bg;
    Color text;

    if (lower == 'confirmed' || lower == 'approved') {
      bg = OwnerColors.successBg;
      text = OwnerColors.success;
    } else if (lower == 'pending') {
      bg = OwnerColors.warningBgAlt;
      text = OwnerColors.warningAlt;
    } else {
      bg = OwnerColors.errorBg;
      text = OwnerColors.error;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: text,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
