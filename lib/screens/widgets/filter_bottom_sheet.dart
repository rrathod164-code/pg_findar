import 'package:flutter/material.dart';
import '../../models/pg_model.dart';

class FilterBottomSheet extends StatefulWidget {
  final PGFilterCriteria initialCriteria;
  final Function(PGFilterCriteria) onApply;

  const FilterBottomSheet({
    super.key,
    required this.initialCriteria,
    required this.onApply,
  });

  static Future<PGFilterCriteria?> show(
    BuildContext context, {
    required PGFilterCriteria initialCriteria,
    required Function(PGFilterCriteria) onApply,
  }) {
    return showModalBottomSheet<PGFilterCriteria>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        initialCriteria: initialCriteria,
        onApply: onApply,
      ),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late RangeValues _priceRange;
  late String _selectedGender;
  late Set<String> _selectedFacilities;

  final List<String> _availableFacilities = [
    'Wifi',
    'AC',
    'Food',
    'Parking',
    'Laundry',
    'TV',
    'Fridge',
    'Gyser',
  ];

  @override
  void initState() {
    super.initState();
    _priceRange = RangeValues(
      widget.initialCriteria.minPrice.clamp(1000, 20000),
      widget.initialCriteria.maxPrice.clamp(1000, 20000),
    );
    _selectedGender = widget.initialCriteria.gender;
    _selectedFacilities = Set<String>.from(widget.initialCriteria.facilities);
  }

  void _resetFilters() {
    setState(() {
      _priceRange = const RangeValues(3000, 10000);
      _selectedGender = 'Both';
      _selectedFacilities.clear();
    });
  }

  void _applyFilters() {
    final criteria = PGFilterCriteria(
      minPrice: _priceRange.start,
      maxPrice: _priceRange.end,
      gender: _selectedGender,
      facilities: _selectedFacilities.toList(),
    );
    widget.onApply(criteria);
    Navigator.pop(context, criteria);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFEAF8F5), // Ambient mint background matching screenshot
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Title & Close
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Apply Filters',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF091A2A),
                      letterSpacing: -0.3,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF758595)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Main Filter Card matching screenshot
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Price Range
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Price Range',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF091A2A),
                          ),
                        ),
                        Text(
                          '₹${_priceRange.start.toInt()} – ₹${_priceRange.end.toInt()}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF091A2A),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Price Slider
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: const Color(0xFF13B99D),
                        inactiveTrackColor: const Color(0xFFD7EFEB),
                        trackHeight: 4.5,
                        thumbColor: const Color(0xFF9EABA9),
                        overlayColor: const Color(0xFF13B99D).withValues(alpha: 0.15),
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 9,
                          elevation: 2,
                        ),
                        rangeThumbShape: const RoundRangeSliderThumbShape(
                          enabledThumbRadius: 9,
                          elevation: 2,
                        ),
                      ),
                      child: RangeSlider(
                        values: _priceRange,
                        min: 1000,
                        max: 15000,
                        divisions: 28,
                        onChanged: (RangeValues values) {
                          setState(() {
                            _priceRange = values;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 2. Gender Selection
                    const Text(
                      'Gender',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF091A2A),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(child: _buildGenderOption('Boys')),
                        const SizedBox(width: 10),
                        Expanded(child: _buildGenderOption('Girls')),
                        const SizedBox(width: 10),
                        Expanded(child: _buildGenderOption('Both')),
                      ],
                    ),

                    const SizedBox(height: 22),

                    // 3. Facilities Selection
                    const Text(
                      'Facilities',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF091A2A),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 2-Column Grid of Facility Chips
                    Column(
                      children: [
                        for (int i = 0; i < _availableFacilities.length; i += 2)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 14.0),
                            child: Row(
                              children: [
                                Expanded(child: _buildFacilityChip(_availableFacilities[i])),
                                const SizedBox(width: 14),
                                if (i + 1 < _availableFacilities.length)
                                  Expanded(child: _buildFacilityChip(_availableFacilities[i + 1]))
                                else
                                  const Expanded(child: SizedBox()),
                              ],
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // 4. Apply Filters Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _applyFilters,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF13B99D),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Apply filters',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 5. Reset Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _resetFilters,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF13B99D),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Reset',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderOption(String gender) {
    final bool isSelected = _selectedGender == gender;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF13B99D) : Colors.black.withValues(alpha: 0.08),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? const Color(0xFF13B99D) : const Color(0xFFCFD6DC),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              gender,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: const Color(0xFF091A2A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFacilityChip(String facility) {
    final bool isSelected = _selectedFacilities.contains(facility);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedFacilities.remove(facility);
          } else {
            _selectedFacilities.add(facility);
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF13B99D) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? null
              : Border.all(color: Colors.black.withValues(alpha: 0.04), width: 1),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFF13B99D).withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: isSelected ? 10 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            facility,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : const Color(0xFF091A2A),
            ),
          ),
        ),
      ),
    );
  }
}
