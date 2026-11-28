import 'package:flutter/material.dart';
import 'package:pg_findar/widgets/app_image.dart';

/// Admin Properties / Pgs Tab (Screenshot 3)
class AdminPropertiesTab extends StatefulWidget {
  const AdminPropertiesTab({super.key});

  @override
  State<AdminPropertiesTab> createState() => _AdminPropertiesTabState();
}

class _AdminPropertiesTabState extends State<AdminPropertiesTab> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _allProperties = [
    {
      'name': 'Green Valley PG',
      'location': 'Rajkot, Gujarat',
      'type': 'PG',
      'price': '₹ 6,500',
      'status': 'Active',
      'image': 'assets/images/GreenVally.png',
    },
    {
      'name': 'Royal PG',
      'location': 'Rajkot, Gujarat',
      'type': 'PG',
      'price': '₹ 6,500',
      'status': 'Active',
      'image': 'assets/images/royal.png',
    },
    {
      'name': 'Shivam PG',
      'location': 'Rajkot, Gujarat',
      'type': 'PG',
      'price': '₹ 8,500',
      'status': 'Active',
      'image': 'assets/images/Shanti.png',
    },
    {
      'name': 'Maple PG',
      'location': 'Rajkot, Gujarat',
      'type': 'PG',
      'price': '₹ 7,500',
      'status': 'Active',
      'image': 'assets/images/Sunshine.png',
    },
    {
      'name': 'Beary besti hostel',
      'location': 'Rajkot, Gujarat',
      'type': 'PG',
      'price': '₹ 8,500',
      'status': 'Active',
      'image': 'assets/images/Comfert.png',
    },
    {
      'name': 'Galaxy Prime Hostel',
      'location': 'Rajkot, Gujarat',
      'type': 'PG',
      'price': '₹ 10,500',
      'status': 'Active',
      'image': 'assets/images/metro.png',
    },
    {
      'name': "Kashmira's PG",
      'location': 'Rajkot, Gujarat',
      'type': 'PG',
      'price': '₹ 6,500',
      'status': 'Active',
      'image': 'assets/images/Shanti.png',
    },
    {
      'name': 'Divine Girls Hostel',
      'location': 'Rajkot, Gujarat',
      'type': 'Hostel',
      'price': '₹ 7,500',
      'status': 'Active',
      'image': 'assets/images/Sunshine.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.toLowerCase().trim();

    final filteredProperties = _allProperties.where((prop) {
      return query.isEmpty ||
          prop['name']!.toLowerCase().contains(query) ||
          prop['location']!.toLowerCase().contains(query);
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Properties',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD6F5E8),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.search, color: Colors.black87, size: 22),
                      hintText: 'Search users..',
                      hintStyle: TextStyle(
                        color: Color(0xFF7CA397),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _showAddPropertyBottomSheet,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5DF0A6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    '+ Add Property',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          Expanded(
            child: filteredProperties.isEmpty
                ? const Center(
                    child: Text(
                      'No properties found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredProperties.length,
                    itemBuilder: (context, index) {
                      final item = filteredProperties[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x06000000),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: AppImage(
                                imageUrl: item['image']!,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name']!,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['location']!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  item['type']!,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item['price']!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2E7D32),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFC3F3D8),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Text(
                                    item['status']!,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2E7D32),
                                    ),
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
    );
  }

  /// Add Property Bottom Sheet Dialog
  void _showAddPropertyBottomSheet() {
    final nameController = TextEditingController();
    final locationController = TextEditingController();
    final priceController = TextEditingController();
    String selectedType = 'PG';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add New Property',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Property Name',
                      hintText: 'e.g. Sunrise PG',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      labelText: 'Location',
                      hintText: 'e.g. Rajkot, Gujarat',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: priceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Price (Monthly)',
                            hintText: 'e.g. 7000',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      DropdownButton<String>(
                        value: selectedType,
                        items: ['PG', 'Hostel'].map((t) {
                          return DropdownMenuItem(
                            value: t,
                            child: Text(t),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setSheetState(() {
                              selectedType = val;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF13B99D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        if (nameController.text.trim().isEmpty) return;
                        setState(() {
                          _allProperties.insert(0, {
                            'name': nameController.text.trim(),
                            'location': locationController.text.trim().isEmpty
                                ? 'Rajkot, Gujarat'
                                : locationController.text.trim(),
                            'type': selectedType,
                            'price':
                                '₹ ${priceController.text.trim().isEmpty ? '6,500' : priceController.text.trim()}',
                            'status': 'Active',
                            'image': 'assets/images/GreenVally.png',
                          });
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Property added successfully'),
                          ),
                        );
                      },
                      child: const Text(
                        'Add Property',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
}
