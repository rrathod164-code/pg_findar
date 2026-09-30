import 'package:flutter/material.dart';
import 'package:pg_findar/widgets/dashboard_background.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../services/api_service.dart';

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
  String? _errorMessage; // Holds wrong username or password error
  String? _emailError;
  String? _passwordError;

  // Pre-defined demo accounts (beginner-friendly frontend validation)
  bool _checkCredentials(String loginInput, String password) {
    final validAccounts = <String, List<String>>{
      'user13': ['1234', 'user123', 'password13'],
      'user@pgfindar.com': ['1234', 'user123', 'password13'],
      'user@gmail.com': ['1234', 'user123', 'password13'],
      'admin13': ['1234', 'admin123', 'password13'],
      'admin@pgfindar.com': ['1234', 'admin123', 'password13'],
      'organizer13': ['1234', 'organizer123', 'password13'],
      'organizer@pgfindar.com': ['1234', 'organizer123', 'password13'],
    };

    // 1. Check pre-defined demo accounts
    if (validAccounts.containsKey(loginInput)) {
      final allowedPasswords = validAccounts[loginInput]!;
      return allowedPasswords.contains(password);
    }

    // 2. Check newly registered users from SignUpPage
    if (ApiService.registeredUsers.containsKey(loginInput)) {
      return ApiService.registeredUsers[loginInput] == password;
    }

    return false;
  }

  // Field validation methods
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email or username';
    }
    final input = value.trim();
    if (input.contains('@')) {
      final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegExp.hasMatch(input)) {
        return 'Please enter a valid email address';
      }
    } else {
      if (input.length < 3) {
        return 'Username must be at least 3 characters';
      }
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
    // Clear any previous error banner and validate fields
    setState(() {
      _errorMessage = null;
      _emailError = _validateEmail(_emailController.text);
      _passwordError = _validatePassword(_passwordController.text);
    });

    if (_emailError != null || _passwordError != null) {
      return;
    }

    final loginInput = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;

    setState(() {
      _isLoading = true;
    });

    // Simulate quick authentication check
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;

      // Verify credentials
      final isCorrect = _checkCredentials(loginInput, password);

      if (!isCorrect) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Incorrect username or password. Please try again.';
        });
        return;
      }

      setState(() {
        _isLoading = false;
      });

      Widget nextScreen;
      String roleName;

      if (loginInput == 'admin13' || loginInput == 'admin@pgfindar.com') {
        nextScreen = const AdminDashboardPage();
        roleName = 'Admin';
      } else if (loginInput == 'organizer13' ||
          loginInput == 'organizer@pgfindar.com') {
        nextScreen = const OrganizerDashboardPage();
        roleName = 'Organizer';
      } else {
        // Defaults to UserDashboard
        nextScreen = const BottomNavScreen();
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFDFD),
      body: DashboardBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, viewportConstraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.07,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Spacer(flex: 1),

                            // Welcome Back Heading
                            const Text(
                              'Welcome Back',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF091A2A),
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Login to continue',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF758595),
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Error Banner if wrong username/password was submitted
                            if (_errorMessage != null) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFECEC),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.red.shade300,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline_rounded,
                                      color: Colors.red.shade700,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        _errorMessage!,
                                        style: TextStyle(
                                          color: Colors.red.shade800,
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Email or Username Label
                            const Text(
                              'Email or Username',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF091A2A),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Email / Username Input
                            Container(
                              decoration: BoxDecoration(
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
                                onChanged: (_) {
                                  if (_emailError != null ||
                                      _errorMessage != null) {
                                    setState(() {
                                      _emailError = null;
                                      _errorMessage = null;
                                    });
                                  }
                                },
                                validator: (_) => _emailError,
                                decoration: InputDecoration(
                                  errorText: _emailError,
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Enter your email or username',
                                  hintStyle: const TextStyle(
                                    color: Color(0xFFB0BAC5),
                                    fontSize: 14,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.mail_outline_rounded,
                                    color: Color(0xFF091A2A),
                                    size: 20,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF13B99D),
                                      width: 1.5,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color: Colors.redAccent,
                                      width: 1.2,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color: Colors.redAccent,
                                      width: 1.5,
                                    ),
                                  ),
                                  errorStyle: const TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 16,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            // Password Label
                            const Text(
                              'Password',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF091A2A),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Password Input
                            Container(
                              decoration: BoxDecoration(
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
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                onChanged: (_) {
                                  if (_passwordError != null ||
                                      _errorMessage != null) {
                                    setState(() {
                                      _passwordError = null;
                                      _errorMessage = null;
                                    });
                                  }
                                },
                                validator: (_) => _passwordError,
                                decoration: InputDecoration(
                                  errorText: _passwordError,
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Enter your password',
                                  hintStyle: const TextStyle(
                                    color: Color(0xFFB0BAC5),
                                    fontSize: 14,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.lock_outline_rounded,
                                    color: Color(0xFF091A2A),
                                    size: 20,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: const Color(0xFF091A2A),
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF13B99D),
                                      width: 1.5,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color: Colors.redAccent,
                                      width: 1.2,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color: Colors.redAccent,
                                      width: 1.5,
                                    ),
                                  ),
                                  errorStyle: const TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 16,
                                  ),
                                ),
                              ),
                            ),

                            // Forgot Password Link
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPasswordPage(),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Forgot password?',
                                  style: TextStyle(
                                    color: Color(0xFF13B99D),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

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
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
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
                            const SizedBox(height: 24),

                            // Or continue with text
                            const Center(
                              child: Text(
                                'Or continue with',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF758595),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            // Social Login Buttons (Google, Facebook)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Google Circle Button
                                GestureDetector(
                                  onTap: () => _showFeatureNotImplemented(
                                    'Google Sign-in',
                                  ),
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.05,
                                          ),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      'assets/images/google.png',
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stack) =>
                                          const Icon(
                                            Icons.g_mobiledata,
                                            color: Colors.red,
                                            size: 26,
                                          ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 24),
                                // Facebook Circle Button
                                GestureDetector(
                                  onTap: () => _showFeatureNotImplemented(
                                    'Facebook Sign-in',
                                  ),
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.05,
                                          ),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      'assets/images/facebook.png',
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stack) =>
                                          const Icon(
                                            Icons.facebook,
                                            color: Colors.blue,
                                            size: 26,
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
                                          builder: (context) =>
                                              const SignUpPage(),
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// Placeholders for Admin and Organizer Dashboards
class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFDFD),
      appBar: AppBar(
        backgroundColor: const Color(0xFF13B99D),
        elevation: 0,
        title: const Text(
          'Admin Dashboard',
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
      body: DashboardBackground(
        child: Center(
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
                    Icons.admin_panel_settings_rounded,
                    size: 50,
                    color: Color(0xFF13B99D),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Admin Panel - PG Finder',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF091A2A),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Logged in as admin13. Manage bookings and listings here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Color(0xFF758595)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OrganizerDashboardPage extends StatelessWidget {
  const OrganizerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFDFD),
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
      body: DashboardBackground(
        child: Center(
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
      ),
    );
  }
}

// Alias for compatibility
typedef LoginScreen = LoginPage;
