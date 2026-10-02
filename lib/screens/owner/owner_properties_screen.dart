import 'package:flutter/material.dart';
import 'package:pg_findar/models/pg_model.dart';
import 'package:pg_findar/services/api_service.dart';
import 'package:pg_findar/widgets/app_image.dart';
import 'package:pg_findar/widgets/dashboard_background.dart';

class OwnerPropertiesTab extends StatefulWidget {
  const OwnerPropertiesTab({super.key});

  @override
  State<OwnerPropertiesTab> createState() => _OwnerPropertiesTabState();
}

class _OwnerPropertiesTabState extends State<OwnerPropertiesTab> {
  void _showAddPropertyDialog(BuildContext context) {
    final nameController = TextEditingController();
    final locationController = TextEditingController();
    final cityController = TextEditingController(text: 'Rajkot');
    final priceController = TextEditingController(text: '6500');
    final imageController = TextEditingController(
      text:
          'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?q=80&w=600&auto=format&fit=crop',
    );
    String selectedCategory = 'Boys PG';
    String selectedGender = 'Boys';
    bool hasWifi = true;
    bool hasAC = true;
    bool hasFood = true;
    bool hasParking = true;
    bool hasLaundry = true;
    bool hasTV = false;
    bool hasFridge = false;
    bool hasGeyser = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Add New Property',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF132230),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Property / PG Name',
                        hintText: 'e.g. Skyline Living PG',
                        filled: true,
                        fillColor: const Color(0xFFF6F9F8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: locationController,
                            decoration: InputDecoration(
                              labelText: 'Location / Area',
                              hintText: 'e.g. Kalawad Road',
                              filled: true,
                              fillColor: const Color(0xFFF6F9F8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: cityController,
                            decoration: InputDecoration(
                              labelText: 'City',
                              filled: true,
                              fillColor: const Color(0xFFF6F9F8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: priceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Monthly Rent (₹)',
                              hintText: 'e.g. 7000',
                              filled: true,
                              fillColor: const Color(0xFFF6F9F8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: selectedCategory,
                            decoration: InputDecoration(
                              labelText: 'Category',
                              filled: true,
                              fillColor: const Color(0xFFF6F9F8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Boys PG',
                                child: Text('Boys PG'),
                              ),
                              DropdownMenuItem(
                                value: 'Girls PG',
                                child: Text('Girls PG'),
                              ),
                              DropdownMenuItem(
                                value: 'Hostels',
                                child: Text('Hostels'),
                              ),
                              DropdownMenuItem(
                                value: 'Flats',
                                child: Text('Flats'),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setModalState(() {
                                  selectedCategory = val;
                                  if (val == 'Boys PG') selectedGender = 'Boys';
                                  if (val == 'Girls PG') {
                                    selectedGender = 'Girls';
                                  }
                                  if (val == 'Hostels' || val == 'Flats') {
                                    selectedGender = 'Both';
                                  }
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Facilities & Amenities',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Color(0xFF132230),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        FilterChip(
                          label: const Text('Wifi'),
                          selected: hasWifi,
                          selectedColor: const Color(0xFFD2F5EC),
                          checkmarkColor: const Color(0xFF13B99D),
                          onSelected: (v) => setModalState(() => hasWifi = v),
                        ),
                        FilterChip(
                          label: const Text('AC'),
                          selected: hasAC,
                          selectedColor: const Color(0xFFD2F5EC),
                          checkmarkColor: const Color(0xFF13B99D),
                          onSelected: (v) => setModalState(() => hasAC = v),
                        ),
                        FilterChip(
                          label: const Text('Food'),
                          selected: hasFood,
                          selectedColor: const Color(0xFFD2F5EC),
                          checkmarkColor: const Color(0xFF13B99D),
                          onSelected: (v) => setModalState(() => hasFood = v),
                        ),
                        FilterChip(
                          label: const Text('Parking'),
                          selected: hasParking,
                          selectedColor: const Color(0xFFD2F5EC),
                          checkmarkColor: const Color(0xFF13B99D),
                          onSelected: (v) =>
                              setModalState(() => hasParking = v),
                        ),
                        FilterChip(
                          label: const Text('Laundry'),
                          selected: hasLaundry,
                          selectedColor: const Color(0xFFD2F5EC),
                          checkmarkColor: const Color(0xFF13B99D),
                          onSelected: (v) =>
                              setModalState(() => hasLaundry = v),
                        ),
                        FilterChip(
                          label: const Text('Geyser'),
                          selected: hasGeyser,
                          selectedColor: const Color(0xFFD2F5EC),
                          checkmarkColor: const Color(0xFF13B99D),
                          onSelected: (v) => setModalState(() => hasGeyser = v),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF13B99D),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          if (nameController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter property name'),
                              ),
                            );
                            return;
                          }

                          final pgPrice =
                              double.tryParse(priceController.text) ?? 6500;

                          final newPG = PGAccommodation(
                            id: DateTime.now().millisecondsSinceEpoch
                                .toString(),
                            name: nameController.text.trim(),
                            location: locationController.text.trim().isEmpty
                                ? 'Kalawad Road, Rajkot'
                                : locationController.text.trim(),
                            city: cityController.text.trim().isEmpty
                                ? 'Rajkot'
                                : cityController.text.trim(),
                            price: pgPrice,
                            rating: 4.9,
                            category: selectedCategory,
                            gender: selectedGender,
                            imageUrl: imageController.text.trim(),
                            hasWifi: hasWifi,
                            hasAC: hasAC,
                            hasFood: hasFood,
                            hasParking: hasParking,
                            hasLaundry: hasLaundry,
                            hasTV: hasTV,
                            hasFridge: hasFridge,
                            hasGeyser: hasGeyser,
                            isPopular: true,
                            organizerId: 'owner13',
                            rooms: [
                              PGRoom(
                                id: 'r101_${DateTime.now().millisecondsSinceEpoch}',
                                roomNumber: 'Room 101',
                                floor: '1st Floor',
                                sharingType: 'Single Sharing',
                                totalBeds: 1,
                                price: pgPrice + 1000,
                                amenities: const ['Attached Bath', 'Wi-Fi', 'AC'],
                              ),
                              PGRoom(
                                id: 'r102_${DateTime.now().millisecondsSinceEpoch}',
                                roomNumber: 'Room 102',
                                floor: '1st Floor',
                                sharingType: 'Double Sharing',
                                totalBeds: 2,
                                price: pgPrice,
                                amenities: const ['Attached Bath', 'Wi-Fi'],
                              ),
                            ],
                          );

                          DataService().addPG(newPG);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${newPG.name} has been added successfully!',
                              ),
                              backgroundColor: const Color(0xFF13B99D),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: const Text(
                          'Save & Publish Property',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDeleteProperty(BuildContext context, PGAccommodation pg) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Remove Property',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to remove "${pg.name}" from your active listings?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF758595)),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                DataService().removePG(pg.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${pg.name} was removed.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteRoom(
    BuildContext context,
    PGAccommodation pg,
    PGRoom room,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Remove Room',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to remove ${room.roomNumber} (${room.sharingType}) from "${pg.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF758595)),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                DataService().deleteRoom(pg.id, room.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${room.roomNumber} was removed.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  void _showAddOrEditRoomDialog(
    BuildContext context,
    PGAccommodation pg, [
    PGRoom? roomToEdit,
  ]) {
    final isEditing = roomToEdit != null;
    final roomNumberController = TextEditingController(
      text: roomToEdit?.roomNumber ?? 'Room 103',
    );
    final priceController = TextEditingController(
      text: roomToEdit != null ? roomToEdit.price.toInt().toString() : '6500',
    );
    final bedsController = TextEditingController(
      text: roomToEdit != null ? roomToEdit.totalBeds.toString() : '2',
    );

    String selectedFloor = roomToEdit?.floor ?? '1st Floor';
    String selectedSharing = roomToEdit?.sharingType ?? 'Double Sharing';
    int occupiedBeds = roomToEdit?.occupiedBeds ?? 0;

    final availableAmenities = [
      'Attached Bath',
      'AC',
      'Wi-Fi',
      'Balcony',
      'Wardrobe',
      'Study Table',
      'Geyser',
    ];
    final selectedAmenities = List<String>.from(
      roomToEdit?.amenities ?? ['Attached Bath', 'Wi-Fi'],
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setRoomModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isEditing ? 'Edit Room Details' : 'Upload New Room Details',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF132230),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    Text(
                      'Property: ${pg.name}',
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF758595),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Room Number & Floor row
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: roomNumberController,
                            decoration: InputDecoration(
                              labelText: 'Room Number',
                              hintText: 'e.g. Room 103',
                              filled: true,
                              fillColor: const Color(0xFFF6F9F8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 3,
                          child: DropdownButtonFormField<String>(
                            initialValue: selectedFloor,
                            decoration: InputDecoration(
                              labelText: 'Floor',
                              filled: true,
                              fillColor: const Color(0xFFF6F9F8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Ground Floor',
                                child: Text('Ground Floor'),
                              ),
                              DropdownMenuItem(
                                value: '1st Floor',
                                child: Text('1st Floor'),
                              ),
                              DropdownMenuItem(
                                value: '2nd Floor',
                                child: Text('2nd Floor'),
                              ),
                              DropdownMenuItem(
                                value: '3rd Floor',
                                child: Text('3rd Floor'),
                              ),
                              DropdownMenuItem(
                                value: '4th Floor',
                                child: Text('4th Floor'),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setRoomModalState(() => selectedFloor = val);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Sharing Type Dropdown & Rent
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: DropdownButtonFormField<String>(
                            initialValue: selectedSharing,
                            decoration: InputDecoration(
                              labelText: 'Sharing Type',
                              filled: true,
                              fillColor: const Color(0xFFF6F9F8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Single Sharing',
                                child: Text('Single Sharing'),
                              ),
                              DropdownMenuItem(
                                value: 'Double Sharing',
                                child: Text('Double Sharing'),
                              ),
                              DropdownMenuItem(
                                value: 'Triple Sharing',
                                child: Text('Triple Sharing'),
                              ),
                              DropdownMenuItem(
                                value: 'Four Sharing',
                                child: Text('Four Sharing'),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setRoomModalState(() {
                                  selectedSharing = val;
                                  if (val == 'Single Sharing') {
                                    bedsController.text = '1';
                                  } else if (val == 'Double Sharing') {
                                    bedsController.text = '2';
                                  } else if (val == 'Triple Sharing') {
                                    bedsController.text = '3';
                                  } else if (val == 'Four Sharing') {
                                    bedsController.text = '4';
                                  }
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: priceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Rent / mo (₹)',
                              hintText: '6500',
                              filled: true,
                              fillColor: const Color(0xFFF6F9F8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Total Beds & Occupied Beds
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: bedsController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Total Beds',
                              filled: true,
                              fillColor: const Color(0xFFF6F9F8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            initialValue: occupiedBeds,
                            decoration: InputDecoration(
                              labelText: 'Occupied Beds',
                              filled: true,
                              fillColor: const Color(0xFFF6F9F8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            items: [
                              for (int i = 0;
                                  i <=
                                      (int.tryParse(bedsController.text) ?? 4);
                                  i++)
                                DropdownMenuItem(
                                  value: i,
                                  child: Text('$i Occupied'),
                                ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setRoomModalState(() => occupiedBeds = val);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    const Text(
                      'Room Amenities',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF132230),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        for (final amenity in availableAmenities)
                          FilterChip(
                            label: Text(amenity),
                            selected: selectedAmenities.contains(amenity),
                            selectedColor: const Color(0xFFD2F5EC),
                            checkmarkColor: const Color(0xFF13B99D),
                            onSelected: (selected) {
                              setRoomModalState(() {
                                if (selected) {
                                  selectedAmenities.add(amenity);
                                } else {
                                  selectedAmenities.remove(amenity);
                                }
                              });
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF13B99D),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          final roomNo = roomNumberController.text.trim();
                          if (roomNo.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a room number'),
                              ),
                            );
                            return;
                          }

                          final rent = double.tryParse(priceController.text) ??
                              pg.price;
                          final totalBeds =
                              int.tryParse(bedsController.text) ?? 2;

                          final newOrUpdatedRoom = PGRoom(
                            id: roomToEdit?.id ??
                                'room_${DateTime.now().millisecondsSinceEpoch}',
                            roomNumber: roomNo,
                            floor: selectedFloor,
                            sharingType: selectedSharing,
                            totalBeds: totalBeds,
                            occupiedBeds: occupiedBeds > totalBeds
                                ? totalBeds
                                : occupiedBeds,
                            price: rent,
                            amenities: selectedAmenities,
                          );

                          DataService().addOrUpdateRoom(pg.id, newOrUpdatedRoom);
                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '$roomNo uploaded successfully! Students can now see and select this room.',
                              ),
                              backgroundColor: const Color(0xFF13B99D),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: Text(
                          isEditing ? 'Save Changes' : 'Upload & Publish Room',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showManageRoomsModal(BuildContext context, PGAccommodation initialPg) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return ValueListenableBuilder<List<PGAccommodation>>(
          valueListenable: DataService().pgsNotifier,
          builder: (context, pgs, _) {
            final pg = pgs.firstWhere(
              (p) => p.id == initialPg.id,
              orElse: () => initialPg,
            );
            final rooms = pg.roomsList;

            return SafeArea(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                ),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Manage Rooms (${rooms.length})',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF132230),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                pg.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF758595),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Top Action: "+ Upload New Room"
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF13B99D),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text(
                          'Upload New Room Detail',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () => _showAddOrEditRoomDialog(context, pg),
                      ),
                    ),
                    const SizedBox(height: 14),

                    const Text(
                      'Configured Rooms (Visible to Students)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF758595),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Rooms List
                    Expanded(
                      child: rooms.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.meeting_room_outlined,
                                    size: 48,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'No rooms uploaded yet',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF758595),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Tap "Upload New Room Detail" to add room numbers and sharing types.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF9E9E9E),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              itemCount: rooms.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final room = rooms[index];
                                final isFull = room.isFull;

                                return Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF9FBFA),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: isFull
                                          ? const Color(0xFFE5E7EB)
                                          : const Color(0xFFD2F5EC),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Room Icon Box
                                      Container(
                                        width: 42,
                                        height: 42,
                                        decoration: BoxDecoration(
                                          color: isFull
                                              ? const Color(0xFFF3F4F6)
                                              : const Color(0xFFE8F8F5),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.meeting_room_outlined,
                                          color: isFull
                                              ? const Color(0xFF9CA3AF)
                                              : const Color(0xFF13B99D),
                                          size: 22,
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      // Details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${room.roomNumber} (${room.floor})',
                                                  style: const TextStyle(
                                                    fontSize: 14.5,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF132230),
                                                  ),
                                                ),
                                                Text(
                                                  '₹${room.price.toInt()} / mo',
                                                  style: const TextStyle(
                                                    fontSize: 13.5,
                                                    fontWeight: FontWeight.w800,
                                                    color: Color(0xFF13B99D),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                    horizontal: 7,
                                                    vertical: 2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                        0xFFE8F8F5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  child: Text(
                                                    room.sharingType,
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          Color(0xFF0F766E),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  isFull
                                                      ? 'Full (${room.occupiedBeds}/${room.totalBeds} beds)'
                                                      : '${room.availableBeds} of ${room.totalBeds} beds available',
                                                  style: TextStyle(
                                                    fontSize: 11.5,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                    color: isFull
                                                        ? const Color(
                                                            0xFFDC2626)
                                                        : const Color(
                                                            0xFF059669),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (room.amenities.isNotEmpty) ...[
                                              const SizedBox(height: 4),
                                              Text(
                                                room.amenities.join(' • '),
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color: Color(0xFF758595),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),

                                      // Actions: Edit and Delete
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.edit_outlined,
                                              size: 18,
                                              color: Color(0xFF13B99D),
                                            ),
                                            padding: EdgeInsets.zero,
                                            constraints:
                                                const BoxConstraints(),
                                            onPressed: () =>
                                                _showAddOrEditRoomDialog(
                                              context,
                                              pg,
                                              room,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete_outline,
                                              size: 18,
                                              color: Color(0xFFE53935),
                                            ),
                                            padding: EdgeInsets.zero,
                                            constraints:
                                                const BoxConstraints(),
                                            onPressed: () =>
                                                _confirmDeleteRoom(
                                              context,
                                              pg,
                                              room,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataService = DataService();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'My Properties',
          style: TextStyle(
            color: Color(0xFF091A2A),
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF13B99D),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              ),
              icon: const Icon(Icons.add, size: 18),
              label: const Text(
                'Add PG',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              onPressed: () => _showAddPropertyDialog(context),
            ),
          ),
        ],
      ),
      body: DashboardBackground(
        child: SafeArea(
          top: false,
          child: ValueListenableBuilder<List<PGAccommodation>>(
        valueListenable: dataService.pgsNotifier,
        builder: (context, pgs, _) {
          final myProperties = pgs
              .where((p) => p.organizerId == 'organizer13' || p.organizerId == 'owner13')
              .toList();

          if (myProperties.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.home_work_outlined,
                    size: 70,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No properties listed yet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap "Add PG" to publish your first property.',
                    style: TextStyle(color: Color(0xFF758595)),
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF13B99D),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Property'),
                    onPressed: () => _showAddPropertyDialog(context),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: myProperties.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final pg = myProperties[index];
              return Container(
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
                    // PG Image + Delete Button overlay
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          child: AppImage(
                            imageUrl: pg.imageUrl,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 18,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: Color(0xFFE53935),
                                size: 20,
                              ),
                              onPressed: () =>
                                  _confirmDeleteProperty(context, pg),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF13B99D),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              pg.category,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Details
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  pg.name,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF132230),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color: Color(0xFFFFB300),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    '${pg.rating}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: Color(0xFF758595),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  pg.location,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF758595),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Configured rooms summary badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0FAF7),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFD2F5EC),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.meeting_room_outlined,
                                      size: 15,
                                      color: Color(0xFF0F766E),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '${pg.roomsList.length} Rooms configured',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF0F766E),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${pg.roomsList.where((r) => r.isAvailable).length} Available',
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF13B99D),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),
                          // Price
                          RichText(
                            text: TextSpan(
                              text: '₹${pg.price.toInt()} ',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF13B99D),
                              ),
                              children: const [
                                TextSpan(
                                  text: '/ month',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF758595),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),
                          // Action buttons row: Upload / Manage Rooms + Remove
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF13B99D),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.meeting_room_rounded,
                                    size: 16,
                                  ),
                                  label: const Text(
                                    'Upload / Manage Rooms',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () =>
                                      _showManageRoomsModal(context, pg),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 2,
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFFE53935),
                                    side: const BorderSide(
                                      color: Color(0xFFFFCDD2),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    size: 16,
                                  ),
                                  label: const Text(
                                    'Remove',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  onPressed: () =>
                                      _confirmDeleteProperty(context, pg),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    ),
  ),
  floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF13B99D),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_business_rounded),
        label: const Text(
          'Add Property',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () => _showAddPropertyDialog(context),
      ),
    );
  }
}

// Alias for compatibility
typedef OwnerPropertiesScreen = OwnerPropertiesTab;
