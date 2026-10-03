import 'package:flutter/material.dart';
import '../../resources/theme.dart';
import '../../widgets/app_image.dart';
import '../../widgets/dashboard_background.dart';
import 'payment_screen.dart';
import '../../services/api_service.dart';

/// ============================================================================
/// BOOK A VISIT SCREEN (BEGINNER-FRIENDLY UI)
/// ============================================================================
/// Displays the booking & visit scheduling form.
/// Pure UI with clean comments, no backend needed!
/// ============================================================================

class BookVisitScreen extends StatefulWidget {
  final PGAccommodation? pg;
  final PGRoom? initialRoom;

  const BookVisitScreen({super.key, this.pg, this.initialRoom});

  @override
  State<BookVisitScreen> createState() => _BookVisitScreenState();
}

class _BookVisitScreenState extends State<BookVisitScreen> {
  // --------------------------------------------------------------------------
  // FORM STATE VARIABLES
  // --------------------------------------------------------------------------
  DateTime _checkInDate = DateTime.now();
  int _members = 1;
  String _selectedDuration = '6 Months';
  String _selectedVisitTime = 'Anytime';

  // Duration Options for the dropdown
  final List<String> _durationOptions = [
    '1 Month',
    '3 Months',
    '6 Months',
    '1 Year',
  ];

  // Visit Time Options for the dropdown
  final List<String> _visitTimeOptions = [
    'Anytime',
    'Morning (9 AM - 12 PM)',
    'Afternoon (12 PM - 4 PM)',
    'Evening (4 PM - 8 PM)',
  ];

  late List<PGRoom> _rooms;
  late PGRoom _selectedRoom;

  @override
  void initState() {
    super.initState();
    _checkInDate = DateTime.now();

    final currentPg = widget.pg ?? ApiService.samplePGs.first;
    _rooms = currentPg.roomsList;

    if (widget.initialRoom != null) {
      _selectedRoom = _rooms.firstWhere(
        (r) =>
            r.id == widget.initialRoom!.id ||
            r.roomNumber == widget.initialRoom!.roomNumber,
        orElse: () => widget.initialRoom!,
      );
    } else {
      _selectedRoom = _rooms.firstWhere(
        (r) => r.isAvailable,
        orElse: () => _rooms.first,
      );
    }
  }

  // --------------------------------------------------------------------------
  // HELPER: Format date to "DD Month YYYY" (e.g. "25 July 2026")
  // --------------------------------------------------------------------------
  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // --------------------------------------------------------------------------
  // HELPER: Open Flutter Date Picker Dialog
  // --------------------------------------------------------------------------
  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime initial = _checkInDate.isBefore(today)
        ? today
        : _checkInDate;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: today,
      lastDate: DateTime(today.year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _checkInDate = pickedDate;
      });
    }
  }

  // --------------------------------------------------------------------------
  // HELPER: Calculate Approx Total Price
  // --------------------------------------------------------------------------
  int _calculateTotalPrice(int monthlyPrice) {
    int multiplier = 6;
    if (_selectedDuration == '1 Month') multiplier = 1;
    if (_selectedDuration == '3 Months') multiplier = 3;
    if (_selectedDuration == '6 Months') multiplier = 6;
    if (_selectedDuration == '1 Year') multiplier = 12;

    return monthlyPrice * multiplier * _members;
  }

  @override
  Widget build(BuildContext context) {
    // PG details with defaults matching the design
    final String pgName = widget.pg?.name ?? 'Green Valley PG';
    final String pgLocation = widget.pg?.location ?? 'Kalawad Road, Rajkot';
    final int monthlyPrice = _selectedRoom.price.toInt();
    final String pgImage =
        (widget.pg?.imageUrl != null && widget.pg!.imageUrl.isNotEmpty)
        ? widget.pg!.imageUrl
        : 'assets/images/GreenVally.png';

    // Total price calculation
    final int totalPrice = _calculateTotalPrice(monthlyPrice);

    const Color primaryGreen = AppColors.primary;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DashboardBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==============================================================
                // 1. TOP BAR (BACK BUTTON & "BOOK A VISIT" TITLE)
                // ==============================================================
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
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
                    const SizedBox(width: 14),
                    const Text(
                      'Book a Visit',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // ==============================================================
                // 2. PG SUMMARY CARD
                // ==============================================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // PG Thumbnail Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: AppImage(
                          imageUrl: pgImage,
                          width: 75,
                          height: 75,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 14),

                      // PG Name & Location
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pgName,
                              style: const TextStyle(
                                fontSize: 16.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              pgLocation,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF8692A6), // Muted grey-blue
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // ==============================================================
                // 2.5 SELECT ROOM & SHARING (TRANSPARENT ROOM IDENTIFIER)
                // ==============================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSectionLabel('Select Room & Sharing'),
                    Text(
                      '${_rooms.length} Rooms',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 104,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _rooms.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final room = _rooms[index];
                      final isSelected = room.id == _selectedRoom.id;
                      final isFull = room.isFull;

                      return GestureDetector(
                        onTap: isFull
                            ? null
                            : () {
                                setState(() {
                                  _selectedRoom = room;
                                });
                              },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 155,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFE8F8F4)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : (isFull
                                      ? Colors.grey.shade200
                                      : Colors.grey.shade300),
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? AppColors.primary.withValues(alpha: 0.1)
                                    : Colors.black.withValues(alpha: 0.03),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    room.roomNumber,
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.bold,
                                      color: isFull
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                  ),
                                  if (isSelected)
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: AppColors.primary,
                                      size: 16,
                                    )
                                  else
                                    Text(
                                      room.floor,
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary.withValues(alpha: 0.15)
                                      : const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  room.sharingType,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? AppColors.primary
                                        : const Color(0xFF374151),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '₹${room.price.toInt()}/mo',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: isFull
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                  ),
                                  Text(
                                    isFull
                                        ? 'Full'
                                        : '${room.availableBeds} bed left',
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.bold,
                                      color: isFull
                                          ? Colors.red
                                          : const Color(0xFF10B981),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFDCFCE7)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.meeting_room_outlined,
                        size: 15,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Selected: ${_selectedRoom.roomNumber} (${_selectedRoom.floor}) • ${_selectedRoom.sharingType}',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF166534),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // ==============================================================
                // 3. CHECK-IN DATE FIELD
                // ==============================================================
                _buildSectionLabel('Check-in Date'),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickDate,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDate(_checkInDate),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.black,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // ==============================================================
                // 4. MEMBERS COUNTER FIELD
                // ==============================================================
                _buildSectionLabel('Members'),
                const SizedBox(height: 8),
                Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      // Member count text
                      Text(
                        '$_members',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),

                      // Minus Button
                      GestureDetector(
                        onTap: () {
                          if (_members > 1) {
                            setState(() => _members--);
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 4,
                          ),
                          child: Icon(
                            Icons.remove,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),

                      // Vertical Divider Line "|"
                      Container(
                        height: 18,
                        width: 1.2,
                        color: const Color(0xFFCBD5E1),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                      ),

                      // Plus Button
                      GestureDetector(
                        onTap: () {
                          setState(() => _members++);
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 4,
                          ),
                          child: Icon(Icons.add, color: Colors.black, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // ==============================================================
                // 5. DURATION DROPDOWN FIELD
                // ==============================================================
                _buildSectionLabel('Duration'),
                const SizedBox(height: 8),
                Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedDuration,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.black,
                        size: 24,
                      ),
                      isExpanded: true,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      items: _durationOptions.map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          setState(() => _selectedDuration = newValue);
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // ==============================================================
                // 6. VISIT TIME DROPDOWN FIELD
                // ==============================================================
                _buildSectionLabel('Visit Time'),
                const SizedBox(height: 8),
                Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedVisitTime,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.black,
                        size: 24,
                      ),
                      isExpanded: true,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      items: _visitTimeOptions.map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          setState(() => _selectedVisitTime = newValue);
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ==============================================================
                // 7. TOTAL (APPROX.) PRICE ROW
                // ==============================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total (Approx.)',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '₹$totalPrice',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // ==============================================================
                // 8. "CONFIRM BOOKING" BUTTON
                // ==============================================================
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to the Payment screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(
                            pg: widget.pg,
                            totalAmount: totalPrice,
                            duration: _selectedDuration,
                            members: _members,
                            selectedRoom: _selectedRoom,
                            checkInDate: _checkInDate,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Confirm Booking',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // HELPER WIDGET: Section Title Label (e.g. "Check-in Date", "Members")
  // --------------------------------------------------------------------------
  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}
