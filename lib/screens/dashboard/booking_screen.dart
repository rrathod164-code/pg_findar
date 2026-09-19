import 'package:flutter/material.dart';
import '../../models/pg_model.dart';
import '../../services/api_service.dart';

/// ============================================================================
/// BOOKING SCREEN (USER BOOKINGS HISTORY & STATUS)
/// ============================================================================
/// Displays user's active and past bookings with real-time status updates,
/// room type, check-in dates, and cancel options.
/// ============================================================================

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();

    return Scaffold(
      backgroundColor: const Color(0xFFFBFDFD),
      appBar: AppBar(
        title: const Text(
          'My Bookings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF091A2A),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ValueListenableBuilder<List<PGBooking>>(
        valueListenable: apiService.bookingsNotifier,
        builder: (context, bookings, child) {
          if (bookings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1FBFA),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.book_online_rounded,
                      size: 60,
                      color: Color(0xFF13B99D),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No Bookings yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF091A2A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Go to Home and book your first PG accommodation!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF758595),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final pg = booking.pg;

              Color statusColor = Colors.orange;
              IconData statusIcon = Icons.hourglass_empty_rounded;
              if (booking.status == 'Approved') {
                statusColor = const Color(0xFF13B99D);
                statusIcon = Icons.check_circle_rounded;
              } else if (booking.status == 'Cancelled') {
                statusColor = Colors.red;
                statusIcon = Icons.cancel_rounded;
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          pg.imageUrl,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            width: 64,
                            height: 64,
                            color: const Color(0xFFEBFDFB),
                            child: const Icon(
                              Icons.home_work_rounded,
                              color: Color(0xFF13B99D),
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        pg.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF091A2A),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('Sharing: ${booking.roomType}',
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 2),
                          Text(
                            'Check-in: ${_formatDate(booking.checkInDate)}',
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF758595)),
                          ),
                        ],
                      ),
                      trailing: Text(
                        '₹${pg.price.toInt()}/mo',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF091A2A),
                        ),
                      ),
                    ),
                    const Divider(height: 1, thickness: 1),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(statusIcon, color: statusColor, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                booking.status == 'Pending'
                                    ? 'Pending Approval'
                                    : booking.status,
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              if (booking.status == 'Pending') ...[
                                const SizedBox(width: 8),
                                const SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(
                                        Color(0xFF13B99D)),
                                  ),
                                ),
                              ]
                            ],
                          ),
                          if (booking.status != 'Cancelled')
                            TextButton(
                              onPressed: () {
                                apiService.cancelBooking(booking.id);
                              },
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.red),
                              child: const Text(
                                'Cancel Booking',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Alias for compatibility
typedef BookingTab = BookingScreen;
