import 'package:flutter/material.dart';
import 'package:pg_findar/resources/theme.dart';
import 'user_home_screen.dart';
import '../../widgets/app_image.dart';
import '../../widgets/dashboard_background.dart';
import '../booking/book_visit_screen.dart';
import '../pg_details/pg_detail_screen.dart';
import '../../widgets/write_review_dialog.dart';

/// ============================================================================
/// PG BOOKING DATA MODEL
/// ============================================================================
class PGBooking {
  final String id;
  final PGAccommodation pg;
  final DateTime checkInDate;
  final DateTime? checkOutDate;
  final String status; // 'completed', 'Cancelled', 'Pending', 'Approved'
  final String roomType; // 'Single Sharing', 'Double Sharing', 'Triple Sharing'
  final double totalPaid;
  final String? customDateRange;
  final String userName;
  final String userPhone;
  final String roomNumber;
  final String floor;

  PGBooking({
    required this.id,
    required this.pg,
    required this.checkInDate,
    this.checkOutDate,
    required this.status,
    this.roomType = 'Double Sharing',
    this.totalPaid = 0,
    this.customDateRange,
    this.userName = 'Guest Tenant',
    this.userPhone = '+91 98765 43210',
    this.roomNumber = 'Room 102',
    this.floor = '1st Floor',
  });

  String get dateRangeFormatted {
    if (customDateRange != null && customDateRange!.isNotEmpty) {
      return customDateRange!;
    }
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final inStr =
        '${checkInDate.day} ${months[checkInDate.month - 1]} ${checkInDate.year}';
    if (checkOutDate != null) {
      final outStr =
          '${checkOutDate!.day} ${months[checkOutDate!.month - 1]} ${checkOutDate!.year}';
      return '$inStr - $outStr';
    }
    return inStr;
  }
}

/// ============================================================================
/// BOOKING SCREEN (USER PAST & ACTIVE BOOKINGS)
/// ============================================================================
/// Matches your exact design screenshot:
/// - "My Bookings" title & "View and manage your past bookings" subtitle
/// - "Your Past Bookings" section header
/// - Cards with PG photo, status badge (completed / Cancelled), dates, price,
///   total paid, amenities chips, and action buttons:
///     * [View Details] (outline teal)
///     * [Book Again]   (solid teal)
///     * [Review]       (outline orange)
/// - Unified DashboardBackground with mint circles and soft background
/// - Pure Flutter UI code with clean comments, no backend needed!
/// ============================================================================

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  // Getter for sampleBookings
  static List<PGBooking> get sampleBookings => staticBookings;

  // --------------------------------------------------------------------------
  // STATIC BOOKINGS DATA (Pure Frontend, Beginner Friendly)
  // --------------------------------------------------------------------------
  static final List<PGBooking> staticBookings = [
    PGBooking(
      id: 'b1',
      pg: PGAccommodation(
        id: '2',
        name: 'Sunshine Residency',
        location: '150 Feet Ring Road, Rajkot',
        city: 'Rajkot',
        price: 7500,
        rating: 4.9,
        category: 'Girls PG',
        gender: 'Girls',
        imageUrl: 'assets/images/Sunshine.png',
        hasWifi: true,
        hasAC: true,
        hasFood: true,
        hasParking: false,
        hasLaundry: true,
        hasTV: true,
        hasFridge: true,
        hasGeyser: true,
        isPopular: true,
        isNearby: false,
      ),
      checkInDate: DateTime(2025, 5, 10),
      checkOutDate: DateTime(2025, 6, 10),
      status: 'completed',
      roomType: 'Double Sharing',
      totalPaid: 13000,
      customDateRange: '10 May 2025 - 10 Jun 2025',
    ),
    PGBooking(
      id: 'b2',
      pg: PGAccommodation(
        id: '1',
        name: 'Green Valley PG',
        location: 'Kalawad Road, Rajkot',
        city: 'Rajkot',
        price: 6500,
        rating: 4.8,
        category: 'Boys PG',
        gender: 'Boys',
        imageUrl: 'assets/images/GreenVally.png',
        hasWifi: true,
        hasAC: true,
        hasFood: true,
        hasParking: true,
        hasLaundry: true,
        hasTV: true,
        hasFridge: true,
        hasGeyser: true,
        isPopular: true,
        isNearby: false,
      ),
      checkInDate: DateTime(2024, 12, 1),
      checkOutDate: DateTime(2025, 3, 1),
      status: 'completed',
      roomType: 'Double Sharing',
      totalPaid: 19500,
      customDateRange: '1 Dec 2024 - 1 Mar 2025',
    ),
    PGBooking(
      id: 'b3',
      pg: PGAccommodation(
        id: '3',
        name: 'Royal Living PG',
        location: 'University Road, Rajkot',
        city: 'Rajkot',
        price: 6000,
        rating: 4.7,
        category: 'Boys PG',
        gender: 'Boys',
        imageUrl: 'assets/images/royal.png',
        hasWifi: true,
        hasAC: true,
        hasFood: true,
        hasParking: true,
        hasLaundry: true,
        hasTV: true,
        hasFridge: true,
        hasGeyser: true,
        isPopular: true,
        isNearby: true,
      ),
      checkInDate: DateTime(2025, 3, 5),
      checkOutDate: DateTime(2025, 5, 5),
      status: 'Cancelled',
      roomType: 'Single Sharing',
      totalPaid: 0,
      customDateRange: '5 Mar 2025 - 5 May 2025',
    ),
  ];

  // --------------------------------------------------------------------------
  // HELPER: Format Amenities Pills Row
  // --------------------------------------------------------------------------
  Widget _buildAmenitiesChips(PGAccommodation pg) {
    final List<String> tags = [];
    if (pg.hasAC) tags.add('AC');
    if (pg.hasWifi) tags.add('Wi-Fi');
    if (pg.hasFood) tags.add('Food');
    if (pg.hasLaundry) tags.add('Laundry');

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: [
        for (final tag in tags.take(4))
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              tag,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
          ),
        if (tags.length > 3)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              '+1 more',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
      ],
    );
  }

  // --------------------------------------------------------------------------
  // HELPER: Booking Card matching design
  // --------------------------------------------------------------------------
  Widget _buildBookingCard(BuildContext context, PGBooking booking) {
    final pg = booking.pg;
    final String statusLower = booking.status.toLowerCase();
    final bool isCancelled = statusLower == 'cancelled';
    final bool isPending = statusLower == 'pending';
    final bool isConfirmed =
        statusLower == 'confirmed' || statusLower == 'approved';

    // Status pill colors
    final Color badgeBg;
    final Color badgeText;
    final String badgeLabel;

    if (isPending) {
      badgeBg = const Color(0xFFFFF6E0);
      badgeText = const Color(0xFFE67E22);
      badgeLabel = 'Pending Approval';
    } else if (isConfirmed) {
      badgeBg = AppColors.successLight;
      badgeText = AppColors.success;
      badgeLabel = 'Confirmed';
    } else if (isCancelled) {
      badgeBg = AppColors.errorLight;
      badgeText = AppColors.error;
      badgeLabel = 'Cancelled';
    } else {
      badgeBg = AppColors.successLight;
      badgeText = AppColors.success;
      badgeLabel = 'Completed';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row: Image on left, Details on right
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PG Room Thumbnail Image
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: AppImage(
                  imageUrl: pg.imageUrl,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),

              // Booking details column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: PG Name & Status Badge
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            pg.name,
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF091A2A),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 3.5,
                          ),
                          decoration: BoxDecoration(
                            color: badgeBg,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            badgeLabel,
                            style: TextStyle(
                              color: badgeText,
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 3),

                    // Location Pin & Text
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 13,
                          color: Color(0xFF6B7280),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            pg.location.contains(',')
                                ? pg.location
                                : '${pg.location} , Gujarat',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 3),

                    // Room & Sharing Type
                    Row(
                      children: [
                        const Icon(
                          Icons.meeting_room_outlined,
                          size: 13,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${booking.roomNumber} (${booking.floor}) • ${booking.roomType}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 3),

                    // Calendar & Dates
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 12,
                          color: Color(0xFF6B7280),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            booking.customDateRange ??
                                '${booking.checkInDate.day}/${booking.checkInDate.month}/${booking.checkInDate.year}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFF4B5563),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 3),

                    // Price per month on left & Total Paid on right
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹ ${pg.price.toInt()} / month',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF111827),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Total Paid',
                              style: TextStyle(
                                fontSize: 9.5,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                            Text(
                              '₹${booking.totalPaid.toInt()}',
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Amenities chips (AC, Wi-Fi, Food, etc.)
                    _buildAmenitiesChips(pg),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
          const SizedBox(height: 10),

          // Action Buttons Row matching the screenshot:
          // If cancelled: [View Details] (full width)
          // If pending: [View Details] + [Awaiting Approval]
          // If completed/confirmed: [View Details] [Book Again] [Review]
          if (isCancelled)
            SizedBox(
              width: double.infinity,
              height: 36,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PgDetailScreen(pg: pg),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary, width: 1.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: const Text(
                  'View Details',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                ),
              ),
            )
          else if (isPending)
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 36,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PgDetailScreen(pg: pg),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(
                          color: AppColors.primary,
                          width: 1.2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'View Details',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    alignment: Alignment.center,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.schedule, size: 14, color: Color(0xFFB45309)),
                        SizedBox(width: 4),
                        Text(
                          'Awaiting Approval',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB45309),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                // 1. View Details (White with teal border)
                Expanded(
                  child: SizedBox(
                    height: 36,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PgDetailScreen(pg: pg),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(
                          color: AppColors.primary,
                          width: 1.2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'View Details',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // 2. Book Again (Solid teal background)
                Expanded(
                  child: SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookVisitScreen(pg: pg),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'Book Again',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // 3. Review (White with orange/coral border)
                Expanded(
                  child: SizedBox(
                    height: 36,
                    child: OutlinedButton(
                      onPressed: () {
                        WriteReviewDialog.show(
                          context,
                          pg: pg,
                          bookingId: booking.id,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFF97316),
                        side: const BorderSide(
                          color: Color(0xFFF97316),
                          width: 1.2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'Review',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool canPop = Navigator.canPop(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DashboardBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==============================================================
              // TOP HEADER: Title, Subtitle, and Back Button if pushed
              // ==============================================================
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (canPop) ...[
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 40,
                              height: 40,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.06),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.arrow_back,
                                color: Color(0xFF091A2A),
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                        const Text(
                          'My Bookings',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF091A2A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'View and manage your past bookings',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF5B6E7D),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Your Past Bookings',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF091A2A),
                      ),
                    ),
                  ],
                ),
              ),

              // ==============================================================
              // BOOKINGS LIST (STATIC DATA)
              // ==============================================================
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: staticBookings.length,
                  itemBuilder: (context, index) {
                    return _buildBookingCard(context, staticBookings[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
