import 'package:flutter/material.dart';
import 'package:my_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class PaginationControl extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;
  final bool isLoading;

  const PaginationControl({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final backgroundColor =
        isDarkMode ? Theme.of(context).cardColor : Colors.white;

    final primaryColor = Theme.of(context).primaryColor;
    final disabledColor =
        isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200;
    final iconDisabledColor = isDarkMode ? Colors.grey.shade600 : Colors.grey;

    // Always show pagination, even on last page
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black38 : Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side - page indicator
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '$currentPage / $totalPages',
              style: TextStyle(
                color: isDarkMode ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),

          // Right side - navigation buttons
          Row(
            children: [
              // First page
              _buildNavButton(
                icon: Icons.first_page,
                onPressed:
                    currentPage > 1 && !isLoading
                        ? () => onPageChanged(1)
                        : null,
                isDarkMode: isDarkMode,
                primaryColor: primaryColor,
                disabledColor: disabledColor,
                iconDisabledColor: iconDisabledColor,
              ),

              // Previous page
              _buildNavButton(
                icon: Icons.arrow_back_ios,
                iconSize: 16,
                onPressed:
                    currentPage > 1 && !isLoading
                        ? () => onPageChanged(currentPage - 1)
                        : null,
                isDarkMode: isDarkMode,
                primaryColor: primaryColor,
                disabledColor: disabledColor,
                iconDisabledColor: iconDisabledColor,
              ),

              // Loading indicator
              SizedBox(
                width: 40,
                height: 40,
                child:
                    isLoading
                        ? Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                primaryColor,
                              ),
                            ),
                          ),
                        )
                        : Container(),
              ),

              // Next page
              _buildNavButton(
                icon: Icons.arrow_forward_ios,
                iconSize: 16,
                onPressed:
                    currentPage < totalPages && !isLoading
                        ? () => onPageChanged(currentPage + 1)
                        : null,
                isDarkMode: isDarkMode,
                primaryColor: primaryColor,
                disabledColor: disabledColor,
                iconDisabledColor: iconDisabledColor,
              ),

              // Last page
              _buildNavButton(
                icon: Icons.last_page,
                onPressed:
                    currentPage < totalPages && !isLoading
                        ? () => onPageChanged(totalPages)
                        : null,
                isDarkMode: isDarkMode,
                primaryColor: primaryColor,
                disabledColor: disabledColor,
                iconDisabledColor: iconDisabledColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required bool isDarkMode,
    required Color primaryColor,
    required Color disabledColor,
    required Color iconDisabledColor,
    double iconSize = 20,
  }) {
    final buttonColor =
        onPressed != null
            ? (isDarkMode
                // ignore: deprecated_member_use
                ? primaryColor.withOpacity(0.2)
                : const Color(0xFFF8E8B0))
            : disabledColor;

    final iconColor =
        onPressed != null
            ? (isDarkMode ? primaryColor : Colors.black87)
            : iconDisabledColor;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        constraints: BoxConstraints(minWidth: 36, minHeight: 36),
        padding: EdgeInsets.all(8),
        icon: Icon(icon, size: iconSize, color: iconColor),
        onPressed: onPressed,
        splashRadius: 20,
        tooltip:
            icon == Icons.first_page
                ? 'First Page'
                : icon == Icons.last_page
                ? 'Last Page'
                : icon == Icons.arrow_back_ios
                ? 'Previous Page'
                : 'Next Page',
      ),
    );
  }
}
