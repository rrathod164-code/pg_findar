import 'package:flutter/material.dart';

class AdminUsersTab extends StatefulWidget {
  const AdminUsersTab({super.key});

  @override
  State<AdminUsersTab> createState() => _AdminUsersTabState();
}

class _AdminUsersTabState extends State<AdminUsersTab> {
  final TextEditingController _userSearchController = TextEditingController();
  String _userSearchQuery = '';

  // Registered users list matching the design
  final List<Map<String, dynamic>> _users = [
    {'id': 'u1', 'name': 'Aarav Sharma', 'email': 'aarav@example.com'},
    {'id': 'u2', 'name': 'Neha Verma', 'email': 'neha@example.com'},
    {'id': 'u3', 'name': 'Priya Patel', 'email': 'priya@example.com'},
    {'id': 'u4', 'name': 'Vikram Singh', 'email': 'vikram@example.com'},
    {'id': 'u5', 'name': 'Rohan Gupta', 'email': 'rohan@example.com'},
    {'id': 'u6', 'name': 'Ananya Reddy', 'email': 'ananya@example.com'},
  ];

  @override
  void dispose() {
    _userSearchController.dispose();
    super.dispose();
  }

  void _confirmDeleteUser(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
            SizedBox(width: 8),
            Text('Delete User', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text('Are you sure you want to delete ${user['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              final deletedIndex = _users.indexOf(user);
              setState(() {
                _users.remove(user);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('User "${user['name']}" deleted'),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  action: SnackBarAction(
                    label: 'Undo',
                    textColor: Colors.white,
                    onPressed: () {
                      setState(() {
                        if (deletedIndex >= 0 &&
                            deletedIndex <= _users.length) {
                          _users.insert(deletedIndex, user);
                        } else {
                          _users.add(user);
                        }
                      });
                    },
                  ),
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = _userSearchQuery.trim().toLowerCase();
    final filteredUsers = _users.where((u) {
      if (query.isEmpty) return true;
      final name = (u['name'] ?? '').toString().toLowerCase();
      final email = (u['email'] ?? '').toString().toLowerCase();
      return name.contains(query) || email.contains(query);
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // "Users" Header matching screenshot
          const Text(
            'Users',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 14),

          // Search pill matching screenshot
          Container(
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFD6F2EA),
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextField(
              controller: _userSearchController,
              onChanged: (val) {
                setState(() {
                  _userSearchQuery = val;
                });
              },
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.black87,
                  size: 22,
                ),
                suffixIcon: _userSearchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          size: 18,
                          color: Colors.black54,
                        ),
                        onPressed: () {
                          _userSearchController.clear();
                          setState(() {
                            _userSearchQuery = '';
                          });
                        },
                      )
                    : null,
                hintText: 'Search users..',
                hintStyle: const TextStyle(
                  color: Color(0xFF88A89F),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // List of Users
          Expanded(
            child: filteredUsers.isEmpty
                ? Center(
                    child: Text(
                      _userSearchQuery.isEmpty
                          ? 'No users registered'
                          : 'No users found matching "$_userSearchQuery"',
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  )
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: filteredUsers.length,
                    separatorBuilder: (ctx, i) => const SizedBox(height: 12),
                    itemBuilder: (ctx, index) {
                      final user = filteredUsers[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // User Name & Email
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user['name'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    user['email'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF8E9EA8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Delete User Button
                            InkWell(
                              onTap: () => _confirmDeleteUser(user),
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFEBEE),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.delete_outline_rounded,
                                      color: Colors.redAccent,
                                      size: 18,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Delete',
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
}
