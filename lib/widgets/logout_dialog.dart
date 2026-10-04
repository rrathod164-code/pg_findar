import 'package:flutter/material.dart';
import '../resources/theme.dart';
import '../screens/auth/login_screen.dart';

/// ============================================================================
/// LOGOUT DIALOG (BEGINNER-FRIENDLY FLUTTER CODE)
/// ============================================================================
/// This widget shows a confirmation popup when the user clicks "Logout".
///
/// Features:
/// 1. Centered door/exit icon at the top
/// 2. Bold red "Logout?" title
/// 3. Subtitle asking: "Are you sure you want to logout from your account?"
/// 4. "Cancel" button: Closes the popup without doing anything
/// 5. "Logout" button: Closes popup and navigates to the Login screen (no backend required!)
/// ============================================================================

class LogoutDialog extends StatelessWidget {
  final VoidCallback? onLogout;

  const LogoutDialog({super.key, this.onLogout});

  /// Helper function: Call `LogoutDialog.show(context)` from anywhere in your app!
  static Future<void> show(BuildContext context, {VoidCallback? onLogout}) {
    return showDialog(
      context: context,
      barrierDismissible: true, // User can tap outside to close
      builder: (BuildContext dialogContext) => LogoutDialog(onLogout: onLogout),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // Rounded corners for the dialog box
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      // Background color of the popup
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 10,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Padding(
        // Padding inside the popup: left, top, right, bottom
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        child: Column(
          // Takes only as much vertical space as its children need
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ================================================================
            // 1. TOP LOGOUT ICON
            // ================================================================
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6), // Soft light grey circle
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout_rounded, // Exit / door logout icon
                size: 28,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 16),

            // ================================================================
            // 2. TITLE: "Logout?" in Red Color
            // ================================================================
            const Text(
              'Logout?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.error, // Red / Coral color matching design
              ),
            ),

            const SizedBox(height: 10),

            // ================================================================
            // 3. SUBTITLE MESSAGE
            // ================================================================
            const Text(
              'Are you sure you want to\nlogout from your account?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textGrey, // Muted grey text
                height: 1.4, // Line spacing
                fontWeight: FontWeight.normal,
              ),
            ),

            const SizedBox(height: 24),

            // ================================================================
            // 4. ACTION BUTTONS: [Cancel] and [Logout]
            // ================================================================
            Row(
              children: [
                // ------------------------------------------------------------
                // A) CANCEL BUTTON (White/Light Grey with Dark text)
                // ------------------------------------------------------------
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {
                        // Close the popup dialog and return back
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF3F4F6), // Light grey
                        foregroundColor: const Color(0xFF374151), // Dark text
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // ------------------------------------------------------------
                // B) LOGOUT BUTTON (Red background with White text)
                // ------------------------------------------------------------
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {
                        // 1. First close the popup dialog
                        Navigator.pop(context);

                        // 2. Perform custom logout callback if provided, or default to LoginPage navigation
                        if (onLogout != null) {
                          onLogout!();
                        } else {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error, // Red button
                        foregroundColor: Colors.white, // White text
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
