import 'package:flutter/material.dart';
import 'package:torret_seach/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class LoadingDialog extends StatelessWidget {
  final String message;

  const LoadingDialog({super.key, this.message = 'Loading details...'});

  static void show(
    BuildContext context, {
    String message = 'Loading details...',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoadingDialog(message: message),
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Gold colors - slightly darker for dark mode
    final goldColor =
        isDarkMode
            ? const Color(0xFFA48929) // Darker gold for dark mode
            : const Color(0xFFD4AF37); // Standard gold

    final bgColor =
        isDarkMode
            ? const Color(0xFF2D2D2D) // Darker background for dark mode
            : Colors.white;

    final textColorPrimary = isDarkMode ? Colors.white : Colors.black87;

    final textColorSecondary =
        isDarkMode ? Colors.grey.shade300 : Colors.grey.shade600;

    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black54 : Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Gold shimmer effect
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 241, 230, 188), // Light gold
                    const Color.fromARGB(
                      255,
                      230,
                      206,
                      134,
                    ), // Medium light gold
                    const Color.fromARGB(255, 243, 186, 14), // Standard gold
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: goldColor.withOpacity(isDarkMode ? 0.3 : 0.5),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: const Color.fromARGB(255, 249, 249, 248),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColorPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Please wait while we fetch the details',
              style: TextStyle(fontSize: 14, color: textColorSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
