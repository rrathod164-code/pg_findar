import 'package:flutter/material.dart';
import '../models/pg_model.dart';
import '../widgets/app_image.dart';
import '../widgets/dashboard_background.dart';
import '../widgets/write_review_dialog.dart';
import 'book_visit_screen.dart';

/// ============================================================================
/// PG DETAIL SCREEN (BEGINNER-FRIENDLY, NON-SCROLLING, PROPORTIONAL UI)
/// ============================================================================
/// - Perfectly balanced photo height (cut only a small amount, not big size)
/// - Normal, clear, readable text and buttons (no tiny shrunken compression)
/// - Fits the entire page onto one fixed screen with 0 overflow and 0 scrolling
/// ============================================================================

class PgDetailScreen extends StatelessWidget {
  final PGAccommodation? pg;

  const PgDetailScreen({super.key, this.pg});

  @override
  Widget build(BuildContext context) {
    // ------------------------------------------------------------------------
    // DATA VALUES (Uses passed PG or sample fallback data)
    // ------------------------------------------------------------------------
    final String pgName = pg?.name ?? 'Green Valley PG';
    final String pgLocation = pg?.location ?? 'Kalawad Road, Rajkot';
    final double pgRating = pg?.rating ?? 4.8;
    final int pgPrice = pg?.price.toInt() ?? 6500;
    final String pgImage = (pg?.imageUrl != null && pg!.imageUrl.isNotEmpty)
        ? pg!.imageUrl
        : 'assets/images/GreenVally.png';

    const Color primaryGreenColor = Color(0xFF10B981);
    final double screenHeight = MediaQuery.of(context).size.height;

    // Balanced image height: around 28% of screen (cuts only a tiny amount, not big size)
    // Leaves plenty of room for full-sized, clear text and buttons below
    final double imageHeight = (screenHeight * 0.28).clamp(200.0, 230.0);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DashboardBackground(
        // Entire page is a Column with NO ScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================================================================
            // 1. TOP IMAGE WITH BACK BUTTON (Balanced banner height)
            // ================================================================
            Stack(
              children: [
                // PG Room Image with rounded bottom corners
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  child: AppImage(
                    imageUrl: pgImage,
                    width: double.infinity,
                    height: imageHeight,
                    fit: BoxFit.cover,
                  ),
                ),

                // Back Button (Circular white button on top-left)
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, top: 12),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
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
                  ),
                ),
              ],
            ),

            // ================================================================
            // 2. PG CONTENT SECTION (Clear, full-sized text & buttons)
            // ================================================================
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // --------------------------------------------------------
                    // A. TITLE & RATING ROW
                    // --------------------------------------------------------
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left: PG Name & Location
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pgName,
                                style: const TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 17,
                                    color: Colors.black87,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      pgLocation,
                                      style: const TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Right: Star Rating & Review Count (Tap to review)
                        GestureDetector(
                          onTap: () {
                            WriteReviewDialog.show(
                              context,
                              pg: pg,
                              pgName: pgName,
                              location: pgLocation,
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color: Color(0xFFFFC107),
                                    size: 21,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    pgRating.toString(),
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2EBA80),
                                    ),
                                  ),
                                ],
                              ),
                              const Text(
                                '320 Reviews',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // --------------------------------------------------------
                    // B. PRICE & VERIFIED BADGE ROW
                    // --------------------------------------------------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '₹$pgPrice',
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                              ),
                            ),
                            const Text(
                              '/month',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF7FA8A2),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8FAF3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check,
                                size: 16,
                                color: Color(0xFF10B981),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Verified',
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

                    // --------------------------------------------------------
                    // C. FACILITIES SECTION
                    // --------------------------------------------------------
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Facilities',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Row(
                          children: [
                            _buildFacilityCard('Food'),
                            _buildFacilityCard('AC'),
                            _buildFacilityCard('Wifi'),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Row(
                          children: [
                            _buildFacilityCard('Parking'),
                            _buildFacilityCard('Laundry'),
                            _buildFacilityCard('Geyser'),
                          ],
                        ),
                      ],
                    ),

                    // --------------------------------------------------------
                    // D. ABOUT PG SECTION
                    // --------------------------------------------------------
                    const Column(
                      children: [
                        Center(
                          child: Text(
                            'About PG',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 3),
                        Center(
                          child: Text(
                            'Green Valley PG offers fully furnished rooms with WiFi,\nmeals, laundry and parking. Perfect for students and\nworking professionals.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // --------------------------------------------------------
                    // E. CALL & WHATSAPP BUTTONS ROW
                    // --------------------------------------------------------
                    Row(
                      children: [
                        Expanded(
                          child: _buildContactButton(
                            icon: Icons.call_outlined,
                            label: 'Call',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Connecting call to PG owner...',
                                  ),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildContactButton(
                            icon: Icons.chat_bubble_outline_rounded,
                            label: 'WhatsApp',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Opening WhatsApp chat...'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    // --------------------------------------------------------
                    // F. "BOOK A PG" BOTTOM BUTTON
                    // --------------------------------------------------------
                    SizedBox(
                      width: double.infinity,
                      height: 48,
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
                          backgroundColor: primaryGreenColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Book a PG',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // HELPER: Facility Card (e.g. "Food", "AC", "Wifi")
  // --------------------------------------------------------------------------
  Widget _buildFacilityCard(String title) {
    return Expanded(
      child: Container(
        height: 38,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 5,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // HELPER: Rounded Action Button for "Call" and "WhatsApp"
  // --------------------------------------------------------------------------
  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(21),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: Colors.black),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
