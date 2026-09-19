import 'package:flutter/material.dart';
import '../../models/pg_model.dart';
import '../../services/api_service.dart';

/// ============================================================================
/// SAVED SCREEN (FAVORITES)
/// ============================================================================
/// Displays user's saved / bookmarked PG accommodations in real-time.
/// ============================================================================

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();

    return Scaffold(
      backgroundColor: const Color(0xFFFBFDFD),
      appBar: AppBar(
        title: const Text(
          'Saved PGs',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF091A2A),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ValueListenableBuilder<List<String>>(
        valueListenable: apiService.savedPgIdsNotifier,
        builder: (context, savedIds, child) {
          return ValueListenableBuilder<List<PGAccommodation>>(
            valueListenable: apiService.pgsNotifier,
            builder: (context, pgs, child) {
              final savedPgs =
                  pgs.where((pg) => savedIds.contains(pg.id)).toList();

              if (savedPgs.isEmpty) {
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
                          Icons.favorite_border_rounded,
                          size: 60,
                          color: Color(0xFF13B99D),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No Saved PGs yet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF091A2A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Tap the heart icon on PGs to save them here.',
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
                itemCount: savedPgs.length,
                itemBuilder: (context, index) {
                  final pg = savedPgs[index];
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
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          pg.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            width: 80,
                            height: 80,
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
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 14, color: Color(0xFF758595)),
                              const SizedBox(width: 2),
                              Text(pg.location,
                                  style: const TextStyle(fontSize: 12)),
                              const SizedBox(width: 8),
                              const Icon(Icons.star_rounded,
                                  size: 14, color: Colors.amber),
                              const SizedBox(width: 2),
                              Text(pg.rating.toString(),
                                  style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '₹${pg.price.toInt()}/month',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF13B99D),
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite_rounded,
                            color: Colors.red),
                        onPressed: () {
                          apiService.toggleFavorite(pg.id);
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// Alias for compatibility
typedef SavedTab = SavedScreen;
