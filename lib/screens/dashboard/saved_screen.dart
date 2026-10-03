import 'package:flutter/material.dart';
import 'package:pg_findar/resources/theme.dart';
import 'package:pg_findar/widgets/app_image.dart';
import 'package:pg_findar/widgets/dashboard_background.dart';
import '../../services/api_service.dart';
import '../pg_details/pg_detail_screen.dart';

/// ============================================================================
/// SAVED SCREEN (STATIC SAVED PGS)
/// ============================================================================
/// Displays user's saved / bookmarked PG accommodations statically.
/// Beginner friendly, no backend or dynamic state required.
/// ============================================================================

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  // --------------------------------------------------------------------------
  // STATIC SAVED PGS DATA (Pure Frontend, Beginner Friendly)
  // --------------------------------------------------------------------------
  static final List<PGAccommodation> staticSavedPgs = [
    PGAccommodation(
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
    PGAccommodation(
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
    PGAccommodation(
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Saved PGs',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF091A2A),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
      ),
      body: DashboardBackground(
        child: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: staticSavedPgs.length,
            itemBuilder: (context, index) {
              final pg = staticSavedPgs[index];
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
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PgDetailScreen(pg: pg),
                      ),
                    );
                  },
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AppImage(
                      imageUrl: pg.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    pg.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: Color(0xFF758595),
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              pg.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            pg.rating.toString(),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '₹${pg.price.toInt()}/month',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  // Static Heart Icon (Disabled action, display only)
                  trailing: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF0F5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_rounded,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
