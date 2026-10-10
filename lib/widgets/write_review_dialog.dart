import 'package:flutter/material.dart';
import '../resources/theme.dart';
import '../screens/user/user_home_screen.dart';
import '../screens/user/user_my_reviews_screen.dart';

class WriteReviewDialog extends StatefulWidget {
  final PGAccommodation? pg;
  final String pgName;
  final String pgId;
  final String location;
  final String? bookingId;
  final UserReview? existingReview;

  WriteReviewDialog({
    super.key,
    this.pg,
    String? pgName,
    String? pgId,
    String? location,
    this.bookingId,
    this.existingReview,
  }) : pgName =
           pgName ?? pg?.name ?? existingReview?.pgName ?? 'PG Accommodation',
       pgId = pgId ?? pg?.id ?? existingReview?.pgId ?? '1',
       location =
           location ??
           pg?.location ??
           existingReview?.location ??
           'Rajkot , Gujarat';

  /// Static helper to easily show this dialog from any screen
  static Future<void> show(
    BuildContext context, {
    PGAccommodation? pg,
    String? pgName,
    String? pgId,
    String? location,
    String? bookingId,
    UserReview? existingReview,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => WriteReviewDialog(
        pg: pg,
        pgName: pgName,
        pgId: pgId,
        location: location,
        bookingId: bookingId,
        existingReview: existingReview,
      ),
    );
  }

  @override
  State<WriteReviewDialog> createState() => _WriteReviewDialogState();
}

class _WriteReviewDialogState extends State<WriteReviewDialog> {
  late double _rating;
  late TextEditingController _commentController;
  late String _selectedPgId;
  late String _selectedPgName;
  late String _selectedLocation;

  // Rating stars, header and submit button colors centralized from AppColors
  static const Color starOrange = AppColors.starAmber;
  static const Color tealDark = AppColors.primaryDark;
  static const Color submitGreen = AppColors.primary;

  @override
  void initState() {
    super.initState();
    _rating = widget.existingReview?.rating ?? 4.0;
    _commentController = TextEditingController(
      text: widget.existingReview?.comment ?? '',
    );
    _selectedPgId = widget.pgId;
    _selectedPgName = widget.pgName;
    _selectedLocation = widget.location;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  List<PGAccommodation> _getAvailablePGs() {
    final list = List<PGAccommodation>.from(HomeScreen.samplePGs);
    if (!list.any((p) => p.id == _selectedPgId)) {
      list.insert(
        0,
        PGAccommodation(
          id: _selectedPgId,
          name: _selectedPgName,
          location: _selectedLocation,
          city: 'Rajkot',
          price: 6500,
          rating: 4.8,
          category: 'Boys PG',
          gender: 'Boys',
          imageUrl: AppPlaceholders.defaultPgImage,
        ),
      );
    }
    return list;
  }

  void _submitReview() {
    final text = _commentController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please share a few words about your stay.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.existingReview != null
              ? 'Review updated successfully!'
              : 'Thank you! Your review has been submitted.',
        ),
        backgroundColor: submitGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availablePGs = _getAvailablePGs();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      backgroundColor: Colors.white,
      elevation: 8,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Write a Review',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: tealDark,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.close,
                      size: 22,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Text(
                'PG Name',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155),
                ),
              ),
              const SizedBox(height: 6),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedPgId,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF64748B),
                    ),
                    items: availablePGs.map((pg) {
                      return DropdownMenuItem<String>(
                        value: pg.id,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.apartment_rounded,
                              size: 18,
                              color: submitGreen,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                pg.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0F172A),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: widget.existingReview != null
                        ? null // Lock PG selection when editing existing review
                        : (newId) {
                            if (newId != null) {
                              final selected = availablePGs.firstWhere(
                                (p) => p.id == newId,
                                orElse: () => availablePGs.first,
                              );
                              setState(() {
                                _selectedPgId = selected.id;
                                _selectedPgName = selected.name;
                                _selectedLocation = selected.location;
                              });
                            }
                          },
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Text(
                'Overall Rating',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155),
                ),
              ),
              const SizedBox(height: 8),

              // Orange Star Rating Row
              Row(
                children: List.generate(5, (index) {
                  final starIndex = index + 1;
                  final bool isFilled = starIndex <= _rating;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _rating = starIndex.toDouble();
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Icon(
                        isFilled
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: starOrange,
                        size: 32,
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 18),
              const Text(
                'Your Review',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155),
                ),
              ),
              const SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
                ),
                child: TextField(
                  controller: _commentController,
                  maxLines: 4,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF0F172A),
                  ),
                  decoration: const InputDecoration(
                    hintText: AppPlaceholders.reviewHint,
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF94A3B8),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(14),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Cancel Text Button
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: tealDark,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Submit Review Solid Button
                  ElevatedButton(
                    onPressed: _submitReview,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: submitGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Submit Review',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
