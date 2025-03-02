// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:my_app/providers/theme_provider.dart';
import 'package:my_app/screens/cache_manager_screen.dart';
import 'package:provider/provider.dart';

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
              _buildSettingsSection(
                title: 'Appearance',
                icon: Icons.palette_outlined,
                children: [
                  // Dark mode toggle using the theme provider
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return _buildSettingsTile(
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

              _buildSettingsSection(
                title: 'Storage',
                icon: Icons.storage_outlined,
                children: [
                  _buildSettingsTile(
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

              _buildSettingsSection(
                title: 'About',
                icon: Icons.info_outline,
                children: [
                  _buildSettingsTile(
                    title: 'Version',
                    subtitle: '1.0.0',
                    trailing: null,
                  ),
                  _buildSettingsTile(
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
                        applicationVersion: '1.0.0',
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

  Widget _buildSettingsSection({
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

  Widget _buildSettingsTile({
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
}
