import 'package:flutter/material.dart';
import '../models/pg_model.dart';
import '../services/api_service.dart';

/// ============================================================================
/// WRITE A REVIEW POPUP DIALOG (BEGINNER-FRIENDLY UI)
/// ============================================================================
/// Matches your exact design screenshot:
/// - "Write a Review" title (dark teal) with "✕" close button
/// - "Overall Rating" with interactive orange stars (including orange outline)
/// - "Your Review" section with rounded container & "Share your experience living here..."
/// - [Cancel] text button and solid [Submit Review] green button
/// - Pure Flutter UI code with clean comments, no backend needed!
/// ============================================================================

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
  })  : pgName = pgName ??
            pg?.name ??
            existingReview?.pgName ??
            'PG Accommodation',
        pgId = pgId ?? pg?.id ?? existingReview?.pgId ?? '1',
        location = location ??
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
  final ApiService _apiService = ApiService();

  // Orange color matching the screenshot stars
  static const Color starOrange = Color(0xFFD97706);
  // Dark teal header & cancel text color
  static const Color tealDark = Color(0xFF0F3E36);
  // Submit button green color
  static const Color submitGreen = Color(0xFF00B074);

  @override
  void initState() {
    super.initState();
    _rating = widget.existingReview?.rating ?? 4.0;
    _commentController =
        TextEditingController(text: widget.existingReview?.comment ?? '');
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
    final list = List<PGAccommodation>.from(_apiService.pgsNotifier.value);
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
          imageUrl: 'assets/images/GreenVally.png',
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

    final newReview = UserReview(
      id: widget.existingReview?.id ??
          'rev_${DateTime.now().millisecondsSinceEpoch}',
      bookingId: widget.bookingId ?? widget.existingReview?.bookingId,
      pgId: _selectedPgId,
      pgName: _selectedPgName,
      location: _selectedLocation,
      rating: _rating,
      comment: text,
      createdAt: widget.existingReview?.createdAt ?? DateTime.now(),
    );

    _apiService.addReview(newReview);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.existingReview != null
            ? 'Review updated successfully!'
            : 'Thank you! Your review has been submitted.'),
        backgroundColor: submitGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availablePGs = _getAvailablePGs();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
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
              // ================================================================
              // 1. TOP HEADER: "Write a Review" & Close "✕" Button
              // ================================================================
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

              // ================================================================
              // 2. PG NAME SELECTOR (Which PG is receiving the review)
              // ================================================================
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFCBD5E1),
                    width: 1,
                  ),
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

            // ================================================================
            // 2. OVERALL RATING LABEL & INTERACTIVE ORANGE STARS
            // ================================================================
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

            // ================================================================
            // 3. YOUR REVIEW LABEL & MULTILINE TEXT INPUT
            // ================================================================
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
                border: Border.all(
                  color: const Color(0xFFCBD5E1),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _commentController,
                maxLines: 4,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF0F172A),
                ),
                decoration: const InputDecoration(
                  hintText: 'Share your experience living here...',
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

            // ================================================================
            // 4. ACTION BUTTONS: Cancel (Text) & Submit Review (Solid Green)
            // ================================================================
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
