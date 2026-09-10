import 'package:flutter/material.dart';
import 'forgot_password.dart';
import 'signup.dart';
import 'screens/user_dashboard.dart';
import 'screens/admin_dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  String? _emailError;
  String? _passwordError;

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email or username';
    }
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final valLower = value.trim().toLowerCase();
    if (valLower == 'user13' ||
        valLower == 'admin13' ||
        valLower == 'organizer13') {
      return null;
    }
    if (!emailRegExp.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 4) {
      return 'Password must be at least 4 characters';
    }
    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    setState(() {
      _emailError = _validateEmail(_emailController.text);
      _passwordError = _validatePassword(_passwordController.text);
    });

    if (_emailError == null && _passwordError == null) {
      setState(() {
        _isLoading = true;
      });

      // Simulate a login delay
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });

        final loginInput = _emailController.text.trim().toLowerCase();
        Widget nextScreen;
        String roleName;

        if (loginInput == 'admin13') {
          nextScreen = const AdminDashboardPage();
          roleName = 'Admin';
        } else if (loginInput == 'organizer13') {
          nextScreen = const OrganizerDashboardPage();
          roleName = 'Organizer';
        } else {
          // Defaults to UserDashboard for 'user13' or any other generic user account
          nextScreen = const UserDashboardPage();
          roleName = 'User';
        }

        // Show successful login toast/snackbar and navigate
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text('Logged in successfully as $roleName'),
              ],
            ),
            backgroundColor: const Color(0xFF13B99D),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        // Navigate to the NextPage/Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => nextScreen),
        );
      });
    }
  }

  void _showFeatureNotImplemented(String featureName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$featureName is not implemented in this demo.'),
        backgroundColor: const Color(0xFF0C1B2A),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF1FBFA), Color(0xFFB9F2E9)],
              ),
            ),
          ),

          // Translucent Decorative Circles (as seen in design)
          // Top right large circle
          Positioned(
            top: -screenHeight * 0.1,
            right: -screenWidth * 0.2,
            child: Container(
              width: screenWidth * 0.7,
              height: screenWidth * 0.7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF13B99D).withValues(alpha: 0.06),
              ),
            ),
          ),
          // Middle right smaller circle
          Positioned(
            top: screenHeight * 0.2,
            right: screenWidth * 0.15,
            child: Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF13B99D).withValues(alpha: 0.08),
              ),
            ),
          ),
          // Middle right edge circle
          Positioned(
            top: screenHeight * 0.45,
            right: -20,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF13B99D).withValues(alpha: 0.08),
              ),
            ),
          ),
          // Bottom right circle
          Positioned(
            bottom: -30,
            right: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF13B99D).withValues(alpha: 0.08),
              ),
            ),
          ),
          // Bottom left circle
          Positioned(
            bottom: -40,
            left: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF13B99D).withValues(alpha: 0.08),
              ),
            ),
          ),

          // Login Form and Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.03),

                    // Title
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF091A2A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Login to continue',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF758595),
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const Spacer(flex: 1),

                    // Email Label & Input Field
                    const Text(
                      'Email or Username',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF091A2A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _emailError != null
                              ? const Color(0xFFD32F2F)
                              : Colors.transparent,
                          width: 1.5,
                        ),
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
                        onChanged: (val) {
                          if (_emailError != null) {
                            setState(() {
                              _emailError = null;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter your email or username',
                          hintStyle: const TextStyle(
                            color: Color(0xFFB0BAC5),
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.mail_outline_rounded,
                            color: _emailError != null
                                ? const Color(0xFFD32F2F)
                                : const Color(0xFF091A2A),
                            size: 20,
                          ),
                          suffixIcon: _emailError != null
                              ? const Icon(
                                  Icons.error_outline_rounded,
                                  color: Color(0xFFD32F2F),
                                  size: 20,
                                )
                              : null,
                          border: InputBorder.none,
                          errorStyle: const TextStyle(height: 0, fontSize: 0),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                        ),
                      ),
                    ),
                    if (_emailError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6, left: 8),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              color: Color(0xFFD32F2F),
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                _emailError!,
                                style: const TextStyle(
                                  color: Color(0xFFD32F2F),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Password Label & Input Field
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF091A2A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _passwordError != null
                              ? const Color(0xFFD32F2F)
                              : Colors.transparent,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        onChanged: (val) {
                          if (_passwordError != null) {
                            setState(() {
                              _passwordError = null;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          hintStyle: const TextStyle(
                            color: Color(0xFFB0BAC5),
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.lock_outline_rounded,
                            color: _passwordError != null
                                ? const Color(0xFFD32F2F)
                                : const Color(0xFF091A2A),
                            size: 20,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: _passwordError != null
                                  ? const Color(0xFFD32F2F)
                                  : const Color(0xFF091A2A),
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: InputBorder.none,
                          errorStyle: const TextStyle(height: 0, fontSize: 0),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                        ),
                      ),
                    ),
                    if (_passwordError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6, left: 8),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              color: Color(0xFFD32F2F),
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                _passwordError!,
                                style: const TextStyle(
                                  color: Color(0xFFD32F2F),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 10),

                    // Admin Login & Forgot Password Links
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF13B99D),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 50),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF13B99D),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: _isLoading
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
                                'Login',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),

                    const Spacer(flex: 1),

                    // Divider "or continue with"
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 10, right: 15),
                            child: Divider(
                              color: const Color(
                                0xFF758595,
                              ).withValues(alpha: 0.3),
                              height: 36,
                            ),
                          ),
                        ),
                        Text(
                          "or continue with",
                          style: TextStyle(
                            color: const Color(
                              0xFF758595,
                            ).withValues(alpha: 0.7),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 15, right: 10),
                            child: Divider(
                              color: const Color(
                                0xFF758595,
                              ).withValues(alpha: 0.3),
                              height: 36,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Social Login (Google & Facebook)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Google Circle Button
                        GestureDetector(
                          onTap: () =>
                              _showFeatureNotImplemented('Google Sign-in'),
                          child: Container(
                            width: 50,
                            height: 50,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'assets/images/google.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                    child: Text(
                                      'G',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFEA4335),
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Facebook Circle Button
                        GestureDetector(
                          onTap: () =>
                              _showFeatureNotImplemented('Facebook Sign-in'),
                          child: Container(
                            width: 50,
                            height: 50,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'assets/images/facebook.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                    child: Text(
                                      'f',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1877F2),
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(flex: 1),

                    // Sign Up text
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF758595),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF13B99D),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Placeholder for Organizer Dashboard

class OrganizerDashboardPage extends StatelessWidget {
  const OrganizerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1FBFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF13B99D),
        elevation: 0,
        title: const Text(
          'Organizer Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF13B99D).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.business_center_rounded,
                  size: 50,
                  color: Color(0xFF13B99D),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Organizer Panel - PG Finder',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF091A2A),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Logged in as organizer13. List PGs and approve booking requests here.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Color(0xFF758595)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
