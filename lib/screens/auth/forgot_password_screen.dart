import 'package:flutter/material.dart';
import 'package:pg_findar/resources/theme.dart';
import 'package:pg_findar/widgets/dashboard_background.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSendResetLink() {
    // Use Flutter's built-in Form validation
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Simulate a network request to send password reset link
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Reset link sent to ${_emailController.text}'),
                ),
              ],
            ),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: DashboardBackground(
        child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.04),

                      // Back Arrow Button (Round)
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Heading Title
                      const Text(
                        'Forgot password?',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Subtitle Text
                      const Text(
                        "Don't worry! It happens. Please enter the email address linked with your account.",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textGrey,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 36),

                      // Email Label
                      const Text(
                        'Email Address',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Email Input Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email';
                            }
                            final emailRegExp = RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            );
                            if (!emailRegExp.hasMatch(value.trim())) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Enter your email',
                            hintStyle: TextStyle(
                              color: AppColors.inputHint,
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(
                              Icons.mail_outline_rounded,
                              color: AppColors.textDark,
                              size: 20,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Sub-label Info Row
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 14,
                            color: AppColors.textGrey.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'We will sent you a password reset link',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textGrey.withValues(alpha: 0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 50),

                      // Send Reset Link Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _handleSendResetLink,
                          icon: _isLoading
                              ? const SizedBox.shrink()
                              : const Icon(Icons.send_rounded, size: 18),
                          label: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Send Reset Link',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // OR Divider
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 10, right: 15),
                              child: Divider(
                                color: AppColors.textGrey.withValues(alpha: 0.3),
                              ),
                            ),
                          ),
                          Text(
                            "OR",
                            style: TextStyle(
                              color: AppColors.textGrey.withValues(alpha: 0.5),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 15, right: 10),
                              child: Divider(
                                color: AppColors.textGrey.withValues(alpha: 0.3),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Back to Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_rounded, size: 18),
                          label: const Text(
                            'Back to login',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            backgroundColor: Colors.white,
                            side: const BorderSide(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
    );
  }
}
