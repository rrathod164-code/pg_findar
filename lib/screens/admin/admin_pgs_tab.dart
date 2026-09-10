import 'package:flutter/material.dart';
import '../../models/pg_model.dart';
import '../../services/data_service.dart';

class AdminPgsTab extends StatefulWidget {
  const AdminPgsTab({super.key});

  @override
  State<AdminPgsTab> createState() => _AdminPgsTabState();
}

class _AdminPgsTabState extends State<AdminPgsTab> {
  static const Color brandTeal = Color(0xFF13B99D);

  void _showAddPgDialog() {
    final nameCtrl = TextEditingController();
    final locationCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    String category = 'Boys PG';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.add_business_rounded, color: brandTeal),
              SizedBox(width: 8),
              Text(
                'Add New PG Property',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: 'PG Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: locationCtrl,
                  decoration: InputDecoration(
                    labelText: 'Location / City',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Monthly Rent (₹)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Boys PG', child: Text('Boys PG')),
                    DropdownMenuItem(
                      value: 'Girls PG',
                      child: Text('Girls PG'),
                    ),
                    DropdownMenuItem(value: 'Hostels', child: Text('Hostels')),
                    DropdownMenuItem(value: 'Flats', child: Text('Flats')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() => category = val);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: brandTeal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (nameCtrl.text.trim().isNotEmpty &&
                    priceCtrl.text.trim().isNotEmpty) {
                  final newPg = PGAccommodation(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameCtrl.text.trim(),
                    location: locationCtrl.text.trim().isNotEmpty
                        ? locationCtrl.text.trim()
                        : 'Rajkot',
                    city: 'Rajkot',
                    price: double.tryParse(priceCtrl.text.trim()) ?? 6000,
                    rating: 4.5,
                    category: category,
                    imageUrl:
                        'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?q=80&w=600&auto=format&fit=crop',
                    hasWifi: true,
                    hasFood: true,
                    hasAC: true,
                  );
                  final currentList = List<PGAccommodation>.from(
                    DataService().pgsNotifier.value,
                  );
                  currentList.insert(0, newPg);
                  DataService().pgsNotifier.value = currentList;
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Successfully added "${newPg.name}"'),
                      backgroundColor: brandTeal,
                    ),
                  );
                }
              },
              child: const Text(
                'Add PG',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<PGAccommodation>>(
      valueListenable: DataService().pgsNotifier,
      builder: (context, pgs, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PG Listings',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Manage inventory & pricing',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF7A929E),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: brandTeal,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.add),
                    onPressed: _showAddPgDialog,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: pgs.length,
                  separatorBuilder: (ctx, i) => const SizedBox(height: 12),
                  itemBuilder: (ctx, index) {
                    final pg = pgs[index];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: brandTeal.withValues(alpha: 0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.network(
                              pg.imageUrl,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pg.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  pg.location,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      '₹${pg.price.toInt()}/mo',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: brandTeal,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        pg.category,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              final list = List<PGAccommodation>.from(
                                DataService().pgsNotifier.value,
                              );
                              list.removeAt(index);
                              DataService().pgsNotifier.value = list;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Removed ${pg.name}')),
                              );
                            },
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
      },
    );
  }
}
