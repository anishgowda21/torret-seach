import 'package:flutter/material.dart';
import 'package:my_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F1E9), // Soft off-white
      appBar: AppBar(
        title: Text(
          'Settings',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                // ignore: deprecated_member_use
                const Color(0xFFF8E8B0).withOpacity(0.5), // Light gold hint
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
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 40,
                      height: 2,
                      color: const Color(0xFFD4AF37),
                    ),
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
                          activeColor: const Color(0xFFD4AF37),
                        ),
                      );
                    },
                  ),
                ],
              ),

              _buildSettingsSection(
                title: 'Cache',
                icon: Icons.storage_outlined,
                children: [
                  _buildSettingsTile(
                    title: 'Clear Search Cache',
                    subtitle: 'Clear saved search results',
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: const Color(0xFFD4AF37),
                      ),
                      onPressed: () {
                        // This would be implemented to clear the cache
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Cache cleared successfully')),
                        );
                      },
                    ),
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
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
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
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
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
                Icon(icon, color: const Color(0xFFD4AF37)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          // ignore: deprecated_member_use
          Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.1)),
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
