import 'package:flutter/material.dart';
import '../models/pg_model.dart';
import '../services/data_service.dart';
import 'widgets/filter_bottom_sheet.dart';

enum PGListType { popular, nearby, category, all }

class PGListPage extends StatefulWidget {
  final String title;
  final PGListType listType;
  final String selectedCity;
  final String? categoryFilter;
  final PGFilterCriteria? initialFilterCriteria;

  const PGListPage({
    super.key,
    required this.title,
    required this.listType,
    required this.selectedCity,
    this.categoryFilter,
    this.initialFilterCriteria,
  });

  @override
  State<PGListPage> createState() => _PGListPageState();
}

class _PGListPageState extends State<PGListPage> {
  final DataService _dataService = DataService();
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  late String _currentCity;
  PGFilterCriteria _filterCriteria = const PGFilterCriteria();

  @override
  void initState() {
    super.initState();
    _currentCity = widget.selectedCity;
    if (widget.initialFilterCriteria != null) {
      _filterCriteria = widget.initialFilterCriteria!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
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

  void _showPGDetailsDialog(PGAccommodation pg) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          padding: EdgeInsets.only(
            top: 20,
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      pg.imageUrl,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 90,
                        height: 90,
                        color: const Color(0xFFEBFDFB),
                        child: const Icon(
                          Icons.home_work_rounded,
                          color: Color(0xFF13B99D),
                          size: 36,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pg.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF091A2A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: Color(0xFF13B99D),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${pg.location}, ${pg.city}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF758595),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEBFDFB),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                pg.category,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF13B99D),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              pg.rating.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF091A2A),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Available Facilities & Amenities',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF091A2A),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildFacilityBadge('Wifi', pg.hasWifi, Icons.wifi),
                  _buildFacilityBadge('AC', pg.hasAC, Icons.ac_unit),
                  _buildFacilityBadge('Food', pg.hasFood, Icons.restaurant),
                  _buildFacilityBadge(
                    'Parking',
                    pg.hasParking,
                    Icons.local_parking,
                  ),
                  _buildFacilityBadge(
                    'Laundry',
                    pg.hasLaundry,
                    Icons.local_laundry_service,
                  ),
                  _buildFacilityBadge('TV', pg.hasTV, Icons.tv),
                  _buildFacilityBadge('Fridge', pg.hasFridge, Icons.kitchen),
                  _buildFacilityBadge('Gyser', pg.hasGeyser, Icons.water_drop),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Monthly Rent',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF758595),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '₹${pg.price.toInt()}/mo',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF13B99D),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showBookingDialog(pg);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF13B99D),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                      ),
                      child: const Text(
                        'Book Now',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFacilityBadge(String name, bool isAvailable, IconData icon) {
    final bool isUserRequested = _filterCriteria.facilities.contains(name);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isAvailable
            ? (isUserRequested
                  ? const Color(0xFF13B99D)
                  : const Color(0xFFF1FBFA))
            : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isAvailable
              ? (isUserRequested
                    ? const Color(0xFF13B99D)
                    : const Color(0xFF13B99D).withValues(alpha: 0.3))
              : Colors.transparent,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isAvailable
                ? (isUserRequested ? Colors.white : const Color(0xFF13B99D))
                : Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isAvailable
                  ? (isUserRequested ? Colors.white : const Color(0xFF091A2A))
                  : Colors.grey,
            ),
          ),
          if (isAvailable) ...[
            const SizedBox(width: 3),
            Icon(
              Icons.check,
              size: 12,
              color: isUserRequested ? Colors.white : const Color(0xFF13B99D),
            ),
          ],
        ],
      ),
    );
  }

  void _showBookingDialog(PGAccommodation pg) {
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    String selectedRoomType = 'Double Sharing';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: EdgeInsets.only(
                top: 24,
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Book PG Accommodation',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF091A2A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    pg.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF13B99D),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Select Room Sharing Type',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF091A2A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildSharingOption(
                        title: 'Single',
                        price: pg.price + 1500,
                        isSelected: selectedRoomType == 'Single Sharing',
                        onTap: () => setModalState(
                          () => selectedRoomType = 'Single Sharing',
                        ),
                      ),
                      const SizedBox(width: 10),
                      _buildSharingOption(
                        title: 'Double',
                        price: pg.price,
                        isSelected: selectedRoomType == 'Double Sharing',
                        onTap: () => setModalState(
                          () => selectedRoomType = 'Double Sharing',
                        ),
                      ),
                      const SizedBox(width: 10),
                      _buildSharingOption(
                        title: 'Triple',
                        price: pg.price - 1000,
                        isSelected: selectedRoomType == 'Triple Sharing',
                        onTap: () => setModalState(
                          () => selectedRoomType = 'Triple Sharing',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Select Check-in Date',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF091A2A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 90)),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFF13B99D),
                                onPrimary: Colors.white,
                                onSurface: Color(0xFF091A2A),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setModalState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDate(selectedDate),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF091A2A),
                            ),
                          ),
                          const Icon(
                            Icons.calendar_today_rounded,
                            color: Color(0xFF13B99D),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        _dataService.bookPG(pg, selectedDate, selectedRoomType);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Booking request for ${pg.name} sent successfully!',
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: const Color(0xFF13B99D),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF13B99D),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Confirm & Request Booking',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSharingOption({
    required String title,
    required double price,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF1FBFA) : Colors.white,
            border: Border.all(
              color: isSelected ? const Color(0xFF13B99D) : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? const Color(0xFF13B99D)
                      : const Color(0xFF091A2A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '₹${price.toInt()}/mo',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? const Color(0xFF13B99D)
                      : const Color(0xFF758595),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveFilterChip(String label, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFEBFDFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF13B99D).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF13B99D),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close_rounded,
              size: 14,
              color: Color(0xFF13B99D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridFromList(List<PGAccommodation> list) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return _buildGridPGCard(list[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFDFD),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 6),
            // Top Bar: Back button and Search Bar with Filter Icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
                                hintText: 'Search PG, location or area...',
                                hintStyle: TextStyle(
                                  color: Color(0xFFB0BAC5),
                                  fontSize: 13.5,
                                ),
                                border: InputBorder.none,
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
                                    ? const Color(0xFF13B99D)
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

            // Active Filter Tags Row
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
                        _buildActiveFilterChip(
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
                        _buildActiveFilterChip(
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
                        _buildActiveFilterChip(facility, () {
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

            // PGs Grid List
            Expanded(
              child: ValueListenableBuilder<List<PGAccommodation>>(
                valueListenable: _dataService.pgsNotifier,
                builder: (context, pgs, child) {
                  // Filter by city
                  var list = pgs
                      .where(
                        (pg) =>
                            pg.city.toLowerCase() ==
                            _currentCity.toLowerCase(),
                      )
                      .toList();

                  // Filter by list type
                  if (widget.listType == PGListType.popular) {
                    list = list
                        .where((pg) => pg.isPopular || pg.rating >= 4.5)
                        .toList();
                  } else if (widget.listType == PGListType.nearby) {
                    list = list
                        .where((pg) => pg.isNearby || !pg.isPopular)
                        .toList();
                  } else if (widget.categoryFilter != null &&
                      widget.categoryFilter!.isNotEmpty) {
                    list = list
                        .where((pg) => pg.category == widget.categoryFilter)
                        .toList();
                  }

                  // Search query filter
                  if (_searchQuery.isNotEmpty) {
                    final q = _searchQuery.toLowerCase().trim();
                    list = list
                        .where(
                          (pg) =>
                              pg.name.toLowerCase().contains(q) ||
                              pg.location.toLowerCase().contains(q) ||
                              pg.category.toLowerCase().contains(q) ||
                              pg.facilities.any((f) => f.toLowerCase().contains(q)),
                        )
                        .toList();
                  }

                  // If user applied filters
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
                                color: Color(0xFFF1FBFA),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.home_work_outlined,
                                size: 50,
                                color: Color(0xFF13B99D),
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
                                backgroundColor: const Color(0xFF13B99D),
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
                                    color: const Color(0xFF13B99D),
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
                          _buildGridFromList(exactMatches),
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
                          _buildGridFromList(referencePgs),
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
                              color: Color(0xFFF1FBFA),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.home_work_outlined,
                              size: 50,
                              color: Color(0xFF13B99D),
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
                          childAspectRatio: 0.65,
                        ),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return _buildGridPGCard(list[index]);
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

  Widget _buildGridPGCard(PGAccommodation pg) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: _dataService.savedPgIdsNotifier,
      builder: (context, savedIds, child) {
        final isFavorited = savedIds.contains(pg.id);

        return GestureDetector(
          onTap: () => _showPGDetailsDialog(pg),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                      ),
                      child: Image.network(
                        pg.imageUrl,
                        height: 105,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 105,
                          color: const Color(0xFFEBFDFB),
                          child: const Center(
                            child: Icon(
                              Icons.home_work_rounded,
                              color: Color(0xFF13B99D),
                              size: 36,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: () {
                          _dataService.toggleFavorite(pg.id);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFavorited
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: isFavorited
                                ? Colors.red
                                : const Color(0xFF758595),
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
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
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF091A2A),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Colors.amber,
                                  size: 14,
                                ),
                                const SizedBox(width: 1),
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
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              '₹${pg.price.toInt()}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF13B99D),
                              ),
                            ),
                            const Text(
                              '/mo',
                              style: TextStyle(
                                fontSize: 9.5,
                                color: Color(0xFF758595),
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 10,
                                  color: Color(0xFF758595),
                                ),
                                const SizedBox(width: 1),
                                Text(
                                  pg.location.split(',').first,
                                  style: const TextStyle(
                                    fontSize: 9,
                                    color: Color(0xFF758595),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Amenities Row
                        Row(
                          children: [
                            if (pg.hasWifi)
                              Container(
                                margin: const EdgeInsets.only(right: 3),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 1.5,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEBFDFB),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Wifi',
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: Color(0xFF13B99D),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (pg.hasAC)
                              Container(
                                margin: const EdgeInsets.only(right: 3),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 1.5,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF0F5),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'AC',
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: Colors.pink,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (pg.hasFood)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 1.5,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0FDF4),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Food',
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          height: 26,
                          child: ElevatedButton(
                            onPressed: () => _showBookingDialog(pg),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF13B99D),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Book Now',
                              style: TextStyle(
                                fontSize: 11,
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
      },  
    );
  }
}
