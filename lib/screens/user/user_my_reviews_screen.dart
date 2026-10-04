import 'package:flutter/material.dart';
import 'package:pg_findar/resources/theme.dart';
import '../../widgets/user_bottom_nav_bar.dart';
import '../../widgets/dashboard_background.dart';

/// ============================================================================
/// USER REVIEW DATA MODEL
/// ============================================================================
class UserReview {
  final String id;
  final String? bookingId;
  final String pgId;
  final String pgName;
  final String location;
  final String roomType;
  final double rating;
  final String comment;
  final DateTime createdAt;

  UserReview({
    required this.id,
    this.bookingId,
    required this.pgId,
    required this.pgName,
    required this.location,
    this.roomType = 'Double Sharing',
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  String get formattedDate {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${createdAt.day.toString().padLeft(2, '0')} ${months[createdAt.month - 1]} ${createdAt.year}';
  }
}

/// ============================================================================
/// MY REVIEWS SCREEN
/// ============================================================================
/// Displays user's reviews for PG accommodations with star ratings, dates,
/// edit actions, and seamless integration with the user dashboard theme.
/// ============================================================================

class MyReviewsScreen extends StatefulWidget {
  final bool showBottomNav;

  const MyReviewsScreen({super.key, this.showBottomNav = true});

  static final List<UserReview> sampleReviews = [
    UserReview(
      id: 'rev_1',
      pgId: '1',
      pgName: 'Green Valley PG',
      location: 'Kalawad Road, Rajkot',
      roomType: 'Double Sharing',
      rating: 5.0,
      comment:
          'The rooms are extremely clean and spacious. The high-speed Wi-Fi was amazing for my remote work, and hot delicious food is served on time daily!',
      createdAt: DateTime(2025, 5, 12),
    ),
    UserReview(
      id: 'rev_2',
      pgId: '3',
      pgName: 'Royal PG',
      location: 'University Road, Rajkot',
      roomType: 'Triple Sharing',
      rating: 4.0,
      comment:
          'Overall a great stay. The air conditioning works perfectly, though laundry service was occasionally delayed. Prime location close to transit hubs.',
      createdAt: DateTime(2025, 3, 28),
    ),
  ];

  @override
  State<MyReviewsScreen> createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends State<MyReviewsScreen> {
  // --------------------------------------------------------------------------
  // WIDGET: Single Review Card Matching Screenshot
  // --------------------------------------------------------------------------
  Widget _buildReviewCard(UserReview review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
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
          // PG Name & Date
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                review.pgName,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF091A2A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                review.formattedDate,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF8C9BA8),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Teal Stars Row
          Row(
            children: List.generate(5, (starIndex) {
              final bool isFilled = starIndex < review.rating.round();
              return Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(
                  isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: isFilled
                      ? AppColors.primary
                      : const Color(0xFFCBD5E1),
                  size: 22,
                ),
              );
            }),
          ),
          const SizedBox(height: 12),

          // Review text paragraph
          Text(
            review.comment,
            style: const TextStyle(
              fontSize: 13.5,
              color: Color(0xFF4B5563),
              height: 1.45,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DashboardBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==============================================================
              // TOP HEADER: Circular Back Button & Title
              // ==============================================================
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Circular Back Button
                        GestureDetector(
                          onTap: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const BottomNavScreen(initialIndex: 3),
                                ),
                              );
                            }
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Color(0xFF091A2A),
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            'My Reviews',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF091A2A),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Your feedback helps others in the community find their perfect paying guest accommodation.',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF5B6E7D),
                        height: 1.4,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // ==============================================================
              // REVIEWS LIST: Static List of Review Cards
              // ==============================================================
              Expanded(
                child: Builder(
                  builder: (context) {
                    final reviews = MyReviewsScreen.sampleReviews;
                    if (reviews.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.rate_review_outlined,
                                size: 48,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No Reviews Yet',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF091A2A),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Share your stay experience to help others.',
                              style: TextStyle(
                                fontSize: 13.5,
                                color: Color(0xFF758595),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        return _buildReviewCard(reviews[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // ======================================================================
      // BOTTOM NAVIGATION BAR (Matching screenshot dashboard tabs)
      // ======================================================================
      bottomNavigationBar: widget.showBottomNav
          ? CustomBottomNavBar(
              currentIndex:
                  3, // Highlights Profile tab where My Reviews resides
              onTap: (index) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => BottomNavScreen(initialIndex: index),
                  ),
                  (route) => false,
                );
              },
            )
          : null,
    );
  }
}
