import 'package:flutter/material.dart';

class AdminMoreTab extends StatelessWidget {
  final VoidCallback onLogout;

  const AdminMoreTab({
    super.key,
    required this.onLogout,
  });

  static const Color brandTeal = Color(0xFF13B99D);

  Widget _buildMoreCardItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? titleColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFC7DFD6), width: 1.2),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Colors.black87),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: titleColor ?? Colors.black,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_rounded,
              size: 18,
              color: Colors.black87,
            ),
          ],
        ),
      ),
    );
  }

  void _showReviewsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Resident Reviews',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Reviews submitted by PG residents',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const Divider(height: 24),
            _buildReviewListItem(
              name: 'Aarav Sharma',
              pg: 'Green Valley PG',
              rating: 4.8,
              comment: 'Great amenities, fast Wi-Fi and delicious meals!',
              date: '20 May 2025',
            ),
            const SizedBox(height: 12),
            _buildReviewListItem(
              name: 'Neha Verma',
              pg: 'Royal PG',
              rating: 4.7,
              comment:
                  'Very secure premises and clean rooms. Highly recommended.',
              date: '18 May 2025',
            ),
            const SizedBox(height: 12),
            _buildReviewListItem(
              name: 'Amit Verma',
              pg: 'Shivam PG',
              rating: 4.5,
              comment: 'Peaceful location near University road with parking.',
              date: '15 May 2025',
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewListItem({
    required String name,
    required String pg,
    required double rating,
    required String comment,
    required String date,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAF9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '$rating',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            pg,
            style: const TextStyle(
              color: brandTeal,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            comment,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          Text(date, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  void _showHelpSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.help_outline_rounded, color: brandTeal),
            SizedBox(width: 8),
            Text(
              'Help & Support',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need assistance with the Admin Panel or PG listings?',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 14),
            Row(
              children: [
                Icon(Icons.email_outlined, color: brandTeal, size: 18),
                SizedBox(width: 8),
                Text(
                  'support@pgfindar.com',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.phone_outlined, color: brandTeal, size: 18),
                SizedBox(width: 8),
                Text(
                  '+91 98765 43210',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.access_time_rounded, color: Colors.grey, size: 18),
                SizedBox(width: 8),
                Text(
                  'Mon - Sat: 9:00 AM - 8:00 PM',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: brandTeal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.lock_outline_rounded, color: brandTeal),
            SizedBox(width: 8),
            Text(
              'Privacy Policy',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Data Protection & Security',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(height: 6),
              Text(
                'PG Findar is committed to protecting all resident and owner data. All sensitive records including booking confirmations, tenant contact information, and payments are strictly encrypted.',
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
              SizedBox(height: 12),
              Text(
                'Admin Privileges',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(height: 6),
              Text(
                'As an Administrator, you have access to modify property bookings, oversee users, and manage listings responsibly according to our compliance standards.',
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: brandTeal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Done', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // "More" Header matching screenshot
          const Text(
            'More',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 20),

          // 1. Reviews Card
          _buildMoreCardItem(
            icon: Icons.star_border_rounded,
            title: 'Reviews',
            onTap: () => _showReviewsSheet(context),
          ),
          const SizedBox(height: 14),

          // 2. Help & Support Card
          _buildMoreCardItem(
            icon: Icons.help_outline_rounded,
            title: 'Help & Support',
            onTap: () => _showHelpSupportDialog(context),
          ),
          const SizedBox(height: 14),

          // 3. Privacy Policy Card
          _buildMoreCardItem(
            icon: Icons.lock_outline_rounded,
            title: 'Privacy Policy',
            onTap: () => _showPrivacyPolicyDialog(context),
          ),
          const SizedBox(height: 14),

          // 4. Logout Card
          _buildMoreCardItem(
            icon: Icons.logout_rounded,
            title: 'Logout',
            titleColor: const Color(0xFFEF4444),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}
