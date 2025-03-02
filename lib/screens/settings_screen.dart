// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:torret_seach/providers/theme_provider.dart';
import 'package:torret_seach/screens/cache_manager_screen.dart';
import 'package:provider/provider.dart';
import 'package:torret_seach/utils/api_url_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor:
          isDarkMode
              ? Colors.black
              : const Color(0xFFF8F1E9), // Dark mode: black, Light mode: cream
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:
                  isDarkMode
                      ? [Colors.black, Colors.black]
                      : [
                        Colors.white,
                        const Color(
                          0xFFF8E8B0,
                        ).withOpacity(0.5), // Light gold hint
                      ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Settings header
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Text(
                      "Settings",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Georgia',
                        color: textColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(width: 40, height: 2, color: primaryColor),
                  ],
                ),
              ),

              // Settings categories
              buildSettingsSection(
                context: context,
                title: 'Appearance',
                icon: Icons.palette_outlined,
                children: [
                  // Dark mode toggle using the theme provider
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return buildSettingsTile(
                        context: context,
                        title: 'Dark Mode',
                        subtitle:
                            themeProvider.isDarkMode
                                ? 'Currently using dark mode'
                                : 'Currently using light mode',
                        trailing: Switch(
                          value: themeProvider.isDarkMode,
                          onChanged: (value) {
                            themeProvider.toggleTheme();
                          },
                          activeColor: primaryColor,
                        ),
                      );
                    },
                  ),
                ],
              ),

              buildSettingsSection(
                context: context,
                title: 'API Configuration',
                icon: Icons.api_outlined,
                children: [
                  buildSettingsTile(
                    context: context,
                    title: 'Manage API URL',
                    subtitle: 'Set or update the API endpoint',
                    trailing: Icon(Icons.chevron_right, color: primaryColor),
                    onTap: () => showApiUrlDialog(context),
                  ),
                ],
              ),

              buildSettingsSection(
                context: context,
                title: 'Storage',
                icon: Icons.storage_outlined,
                children: [
                  buildSettingsTile(
                    context: context,
                    title: 'Cache Manager',
                    subtitle: 'View and manage cached data',
                    trailing: Icon(Icons.chevron_right, color: primaryColor),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CacheManagerScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              buildSettingsSection(
                context: context,
                title: 'About',
                icon: Icons.info_outline,
                children: [
                  buildSettingsTile(
                    context: context,
                    title: 'Version',
                    subtitle: '1.1.0',
                    trailing: null,
                  ),
                  buildSettingsTile(
                    context: context,
                    title: 'Licenses',
                    subtitle: 'Open source licenses',
                    trailing: Icon(
                      Icons.chevron_right,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey,
                    ),
                    onTap: () {
                      showLicensePage(
                        context: context,
                        applicationName: 'Torret Seach',
                        applicationVersion: '1.1.0',
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Extracted widget builder methods
Widget buildSettingsSection({
  required BuildContext context,
  required String title,
  required IconData icon,
  required List<Widget> children,
}) {
  final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
  final textColor = Theme.of(context).textTheme.bodyLarge?.color;
  final primaryColor = Theme.of(context).primaryColor;

  return Container(
    margin: const EdgeInsets.only(bottom: 24),
    decoration: BoxDecoration(
      color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color:
              isDarkMode
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: primaryColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: isDarkMode ? Colors.grey[800] : Colors.grey.withOpacity(0.1),
        ),
        // Section items
        ...children,
      ],
    ),
  );
}

Widget buildSettingsTile({
  required BuildContext context,
  required String title,
  required String subtitle,
  required Widget? trailing,
  VoidCallback? onTap,
}) {
  final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
  final textColor = Theme.of(context).textTheme.bodyLarge?.color;
  final secondaryTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];

  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: secondaryTextColor),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    ),
  );
}

// Method to validate and sanitize URL
String sanitizeUrl(String url) {
  String sanitizedUrl = url.trim();
  // Remove trailing slash if present
  if (sanitizedUrl.endsWith('/')) {
    sanitizedUrl = sanitizedUrl.substring(0, sanitizedUrl.length - 1);
  }
  return sanitizedUrl;
}

// Method to validate URL
Future<(bool isValid, String? errorMessage)> validateApiUrl(String url) async {
  if (url.isEmpty) {
    return (false, 'Please enter a URL');
  }

  // Basic format check
  if (!Uri.parse(url).isAbsolute || !url.startsWith('http')) {
    return (false, 'Please enter a valid URL (e.g., https://google.com)');
  }

  // Health check
  try {
    final healthUrl = url.endsWith('/') ? '${url}health' : '$url/health';

    final response = await http
        .get(Uri.parse(healthUrl))
        .timeout(Duration(seconds: 5));

    if (response.statusCode == 200) {
      final Map<String, dynamic> healthData = jsonDecode(response.body);
      if (healthData['apiSignature'] == 'anishgowda21_torrent_api' &&
          healthData['ownerIdentifier'] == 'AG21') {
        return (true, null);
      } else {
        return (false, 'Not an official API');
      }
    } else {
      return (false, 'Invalid Response');
    }
  } catch (e) {
    return (false, 'Failed to connect. Not an official API');
  }
}

// Launch URL helper
Future<void> launchInstructionsUrl() async {
  final Uri url = Uri.parse('https://github.com/anishgowda21/torret-seach-be');
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch URL';
  }
}

// API URL dialog with proper async handling
void showApiUrlDialog(BuildContext context) {
  final TextEditingController controller = TextEditingController();
  String? errorMessage;
  bool isValidating = false;

  // Use this function to get the API URL
  void getApiUrlAndSetController() async {
    final currentUrl = await ApiUrlManager.getApiUrl();
    // Store this in a local variable to avoid BuildContext issues
    final String urlText = currentUrl ?? '';

    // This is a safe callback that we can use later
    void updateController() {
      controller.text = urlText;
    }

    // Check if the widget is still mounted
    if (context.mounted) {
      updateController();
    }
  }

  // Call the function to get the API URL
  getApiUrlAndSetController();

  showDialog(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (builderContext, setStateDialog) {
          // Function to handle URL saving with proper context handling
          void saveApiUrl() async {
            // Update state to show loading
            setStateDialog(() => isValidating = true);

            // Get and sanitize URL
            String url = sanitizeUrl(controller.text);

            // Validate URL
            final (isValid, validationError) = await validateApiUrl(url);

            // Check if dialog is still in the widget tree
            if (!builderContext.mounted) return;

            if (isValid) {
              // Save URL to preferences
              await ApiUrlManager.setApiUrl(url);

              // Check if dialog is still in the widget tree before popping
              if (builderContext.mounted) {
                Navigator.pop(builderContext);

                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('API URL updated successfully')),
                );
              }
            } else {
              // Update error state
              setStateDialog(() {
                errorMessage = validationError;
                isValidating = false;
              });
            }
          }

          return AlertDialog(
            title: Text('Manage API URL'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: 'API URL',
                    errorText: errorMessage,
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                if (isValidating)
                  Center(child: CircularProgressIndicator())
                else
                  GestureDetector(
                    onTap: launchInstructionsUrl,
                    child: Text(
                      'Need help? View setup instructions for API URL',
                      style: TextStyle(
                        color: Theme.of(builderContext).primaryColor,
                      ),
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(builderContext),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: isValidating ? null : saveApiUrl,
                child: Text('Save'),
              ),
            ],
          );
        },
      );
    },
  );
}
