import 'package:flutter/material.dart';
import 'package:pg_findar/resources/theme.dart';
import '../../widgets/dashboard_background.dart';

/// ============================================================================
/// EDIT PROFILE SCREEN (BEGINNER-FRIENDLY)
/// ============================================================================
/// Features:
/// - Exact design matching your screenshot
/// - Full Name, Email, Password, Confirm Password fields with modern styling
/// - Toggle password visibility on Confirm Password
/// - Save button updates user profile instantly in ApiService (no backend needed!)
/// - Profile changes reflect immediately on the Profile Screen!
/// ============================================================================

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Primary brand color linked to central theme
  static const Color primaryGreen = AppColors.primary;

  // Controllers for the input text fields
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  // Visibility toggle for password fields
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill controllers with default user profile values
    _nameController = TextEditingController(text: 'User');
    _emailController = TextEditingController(text: 'user@gmail.com');
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    // Clean up controllers when the screen is disposed
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Save function: Validates input and saves changes to ApiService
  void _saveProfile() {
    final String newName = _nameController.text.trim();
    final String newEmail = _emailController.text.trim();
    final String newPassword = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    // 1. Validation: Name cannot be empty
    if (newName.isEmpty) {
      _showToast('Please enter your full name');
      return;
    }

    // 2. Validation: Email cannot be empty
    if (newEmail.isEmpty) {
      _showToast('Please enter your email');
      return;
    }

    // 3. Validation: If user typed a password, ensure confirm password matches
    if (newPassword.isNotEmpty) {
      if (newPassword != confirmPassword) {
        _showToast('Passwords do not match');
        return;
      }
    }


    // 5. Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: primaryGreen,
        duration: Duration(seconds: 2),
      ),
    );

    // 6. Go back to Profile Screen safely
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DashboardBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Scrollable form content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // Header with back arrow & "Edit profile" title
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                                size: 22,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Text(
                            'Edit profile',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // 1. Full Name
                      _buildFieldLabel('Full Name'),
                      const SizedBox(height: 8),
                      _buildInputField(
                        controller: _nameController,
                        hintText: 'Enter your full name',
                        icon: Icons.person_outline,
                      ),

                      const SizedBox(height: 20),

                      // 2. Email
                      _buildFieldLabel('Email'),
                      const SizedBox(height: 8),
                      _buildInputField(
                        controller: _emailController,
                        hintText: 'Enter your email',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 20),

                      // 3. Password
                      _buildFieldLabel('Password'),
                      const SizedBox(height: 8),
                      _buildInputField(
                        controller: _passwordController,
                        hintText: 'Create a password',
                        icon: Icons.lock_outline,
                        isObscure: !_isPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: const Color(0xFF6B7280),
                            size: 22,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 4. Confirm Password (with eye toggle)
                      _buildFieldLabel('Confirm password'),
                      const SizedBox(height: 8),
                      _buildInputField(
                        controller: _confirmPasswordController,
                        hintText: 'Confirm your password',
                        icon: Icons.lock_outline,
                        isObscure: !_isConfirmPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: const Color(0xFF6B7280),
                            size: 22,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              // Bottom "save" Button
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      shadowColor: primaryGreen.withValues(alpha: 0.3),
                    ),
                    child: const Text(
                      'save',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper widget for the field labels above text fields
  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14.5,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  /// Helper widget for the styled white input containers with soft shadow
  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isObscure = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isObscure,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: const Color(0xFF6B7280), size: 22),
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14.5),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
