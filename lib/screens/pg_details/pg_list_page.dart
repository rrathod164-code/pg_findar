import 'package:flutter/material.dart';
import '../../resources/theme.dart';
import '../user/user_home_screen.dart';
import '../../widgets/app_image.dart';
import '../../widgets/user_bottom_nav_bar.dart';
import '../../widgets/dashboard_background.dart';
import '../../widgets/filter_bottom_sheet.dart';
import 'pg_detail_screen.dart';

enum PGListType { popular, nearby, category, all }

class PGListPage extends StatefulWidget {
  final String title;
  final PGListType listType;
  final String selectedCity;
  final String? categoryFilter;
  final PGFilterCriteria? initialFilterCriteria;
  final bool autoFocusSearch;
  final bool showBottomNav;

  const PGListPage({
    super.key,
    required this.title,
    required this.listType,
    required this.selectedCity,
    this.categoryFilter,
    this.initialFilterCriteria,
    this.autoFocusSearch = false,
    this.showBottomNav = true,
  });

  @override
  State<PGListPage> createState() => _PGListPageState();
}

class _PGListPageState extends State<PGListPage> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  late String _currentCity;
  PGFilterCriteria _filterCriteria = const PGFilterCriteria();
  String _selectedCategory = '';

  @override
  void initState() {
    super.initState();
    _currentCity = widget.selectedCity;
    if (widget.initialFilterCriteria != null) {
      _filterCriteria = widget.initialFilterCriteria!;
    }
    if (widget.categoryFilter != null && widget.categoryFilter!.isNotEmpty) {
      _selectedCategory = widget.categoryFilter!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matchesCategory(PGAccommodation pg, String category) {
    if (category.isEmpty) return true;

    final filter = category.toLowerCase().trim();
    final pgCategory = pg.category.toLowerCase().trim();
    final pgGender = pg.gender.toLowerCase().trim();

    if (filter.contains('boy')) {
      return pgCategory.contains('boy') || pgGender == 'boys';
    }
    if (filter.contains('girl')) {
      return pgCategory.contains('girl') || pgGender == 'girls';
    }
    if (filter.contains('hostel')) {
      return pgCategory.contains('hostel');
    }
    if (filter.contains('flat')) {
      return pgCategory.contains('flat');
    }

    return pgCategory == filter || pgGender == filter;
  }

  void _openFilterSheet() {
    FilterBottomSheet.show(
      context,
      initialCriteria: _filterCriteria,
      onApply: (newCriteria) {
        setState(() {
          _filterCriteria = newCriteria;
        });
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    Widget buildGridPGCard(PGAccommodation pg) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF091A2A).withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 5),
            ),
            BoxShadow(
              color: const Color(0xFF091A2A).withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                  child: AppImage(
                    imageUrl: pg.imageUrl,
                    height: 96,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border_rounded,
                      color: Color(0xFF758595),
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            pg.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF091A2A),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 13,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              pg.rating.toString(),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF758595),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Text(
                          '₹${pg.price.toInt()}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                        const Text(
                          '/month',
                          style: TextStyle(
                            fontSize: 9.5,
                            color: Color(0xFF758595),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 11,
                          color: Color(0xFF758595),
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            pg.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF758595),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            pg.gender,
                            style: const TextStyle(
                              fontSize: 8.5,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (pg.hasAC) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 1.5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF0F5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.ac_unit,
                                  size: 9,
                                  color: Colors.pink,
                                ),
                                SizedBox(width: 2),
                                Text(
                                  'A.C',
                                  style: TextStyle(
                                    fontSize: 7.5,
                                    color: Colors.pink,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: double.infinity,
                      height: 24,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PgDetailScreen(pg: pg),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'Book Now',
                          style: TextStyle(
                            fontSize: 11.5,
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
      );
    }

    Widget buildGridFromList(List<PGAccommodation> list) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 12,
          childAspectRatio: 0.68,
        ),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return buildGridPGCard(list[index]);
        },
      );
    }

    Widget buildActiveFilterChip(String label, VoidCallback onRemove) {
      return Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onRemove,
              child: const Icon(
                Icons.close_rounded,
                size: 14,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: DashboardBackground(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF091A2A),
                        size: 26,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search,
                              color: Color(0xFF758595),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                autofocus: widget.autoFocusSearch,
                                onChanged: (val) {
                                  setState(() {
                                    _searchQuery = val;
                                  });
                                },
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  color: Color(0xFF091A2A),
                                ),
                                decoration: const InputDecoration(
                                  hintText: AppPlaceholders.searchHint,
                                  hintStyle: TextStyle(
                                    color: Color(0xFFB0BAC5),
                                    fontSize: 13.5,
                                  ),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                  filled: false,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                ),
                              ),
                            ),
                            if (_searchQuery.isNotEmpty)
                              GestureDetector(
                                onTap: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: Icon(
                                    Icons.clear,
                                    size: 18,
                                    color: Color(0xFF758595),
                                  ),
                                ),
                              ),
                            GestureDetector(
                              onTap: _openFilterSheet,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: _filterCriteria.hasActiveFilters
                                      ? AppColors.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.tune_rounded,
                                  color: _filterCriteria.hasActiveFilters
                                      ? Colors.white
                                      : const Color(0xFF091A2A),
                                  size: 20,
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

              if (_filterCriteria.hasActiveFilters) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        if (_filterCriteria.gender != 'Both')
                          buildActiveFilterChip(
                            'Gender: ${_filterCriteria.gender}',
                            () {
                              setState(() {
                                _filterCriteria = _filterCriteria.copyWith(
                                  gender: 'Both',
                                );
                              });
                            },
                          ),
                        if (_filterCriteria.minPrice > 3000 ||
                            _filterCriteria.maxPrice < 10000)
                          buildActiveFilterChip(
                            '₹${_filterCriteria.minPrice.toInt()} - ₹${_filterCriteria.maxPrice.toInt()}',
                            () {
                              setState(() {
                                _filterCriteria = _filterCriteria.copyWith(
                                  minPrice: 3000,
                                  maxPrice: 10000,
                                );
                              });
                            },
                          ),
                        for (final facility in _filterCriteria.facilities)
                          buildActiveFilterChip(facility, () {
                            final updated = List<String>.from(
                              _filterCriteria.facilities,
                            )..remove(facility);
                            setState(() {
                              _filterCriteria = _filterCriteria.copyWith(
                                facilities: updated,
                              );
                            });
                          }),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _filterCriteria = const PGFilterCriteria();
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Clear All',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              Expanded(
                child: Builder(
                  builder: (context) {
                    final pgs = HomeScreen.samplePGs;
                    var list = pgs
                        .where(
                          (pg) =>
                              pg.city.toLowerCase() ==
                              _currentCity.toLowerCase(),
                        )
                        .toList();

                    if (_selectedCategory.isNotEmpty) {
                      list = list
                          .where(
                            (pg) => _matchesCategory(pg, _selectedCategory),
                          )
                          .toList();
                    } else if (widget.listType == PGListType.popular) {
                      list = list
                          .where((pg) => pg.isPopular || pg.rating >= 4.5)
                          .toList();
                    } else if (widget.listType == PGListType.nearby) {
                      list = list
                          .where((pg) => pg.isNearby || !pg.isPopular)
                          .toList();
                    }

                    if (_searchQuery.isNotEmpty) {
                      final q = _searchQuery.toLowerCase().trim();
                      list = list
                          .where(
                            (pg) =>
                                pg.name.toLowerCase().contains(q) ||
                                pg.location.toLowerCase().contains(q) ||
                                pg.category.toLowerCase().contains(q) ||
                                pg.facilities.any(
                                  (f) => f.toLowerCase().contains(q),
                                ),
                          )
                          .toList();
                    }

                    if (_filterCriteria.hasActiveFilters) {
                      final exactMatches = list.where((pg) {
                        final inPrice =
                            pg.price >= _filterCriteria.minPrice &&
                            pg.price <= _filterCriteria.maxPrice;
                        final matchGender =
                            _filterCriteria.gender == 'Both' ||
                            pg.gender == _filterCriteria.gender ||
                            pg.gender == 'Both';
                        final matchesAllFacilities = _filterCriteria.facilities
                            .every((f) => pg.hasFacility(f));
                        return inPrice && matchGender && matchesAllFacilities;
                      }).toList();

                      final referencePgs = list.where((pg) {
                        final isNotExact = !exactMatches.contains(pg);
                        final matchCount = pg.matchingFacilitiesCount(
                          _filterCriteria.facilities,
                        );
                        final inPrice =
                            pg.price >= _filterCriteria.minPrice &&
                            pg.price <= _filterCriteria.maxPrice;
                        final matchGender =
                            _filterCriteria.gender == 'Both' ||
                            pg.gender == _filterCriteria.gender ||
                            pg.gender == 'Both';

                        if (_filterCriteria.facilities.isNotEmpty) {
                          return isNotExact && matchCount > 0;
                        } else {
                          return isNotExact && (inPrice || matchGender);
                        }
                      }).toList();

                      referencePgs.sort(
                        (a, b) => b
                            .matchingFacilitiesCount(_filterCriteria.facilities)
                            .compareTo(
                              a.matchingFacilitiesCount(
                                _filterCriteria.facilities,
                              ),
                            ),
                      );

                      if (exactMatches.isEmpty && referencePgs.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryLight,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.home_work_outlined,
                                  size: 50,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 14),
                              const Text(
                                'No PGs Found',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF091A2A),
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Try changing search query or reset filters',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF758595),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _searchQuery = '';
                                    _filterCriteria = const PGFilterCriteria();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text('Reset All'),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView(
                        padding: const EdgeInsets.fromLTRB(14, 4, 14, 16),
                        physics: const BouncingScrollPhysics(),
                        children: [
                          if (exactMatches.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 4,
                                bottom: 8,
                                top: 4,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '${exactMatches.length}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Exact Matches',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF091A2A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            buildGridFromList(exactMatches),
                            const SizedBox(height: 16),
                          ],
                          if (referencePgs.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 4,
                                bottom: 4,
                                top: 6,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.shade700,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '${referencePgs.length}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Reference PGs (Matching Amenities)',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF091A2A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 4, bottom: 8),
                              child: Text(
                                'These accommodations fulfill some of your requested amenities',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: Color(0xFF758595),
                                ),
                              ),
                            ),
                            buildGridFromList(referencePgs),
                          ],
                        ],
                      );
                    }

                    if (list.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                color: AppColors.primaryLight,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.home_work_outlined,
                                size: 50,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'No PGs Found',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF091A2A),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Try changing search query or reset filters',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF758595),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.fromLTRB(14, 4, 14, 16),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.68,
                          ),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return buildGridPGCard(list[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: widget.showBottomNav
          ? CustomBottomNavBar(
              currentIndex: 0,
              onTap: (index) {
                if (index == 0) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BottomNavScreen(initialIndex: index),
                    ),
                    (route) => false,
                  );
                }
              },
            )
          : null,
    );
  }
}
