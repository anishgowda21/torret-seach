import 'package:flutter/material.dart';

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
    // Always show pagination, even on last page
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
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
              color: const Color(0xFFD4AF37),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '$currentPage / $totalPages',
              style: TextStyle(
                color: Colors.white,
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
              ),

              // Previous page
              _buildNavButton(
                icon: Icons.arrow_back_ios,
                iconSize: 16,
                onPressed:
                    currentPage > 1 && !isLoading
                        ? () => onPageChanged(currentPage - 1)
                        : null,
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
                                const Color(0xFFD4AF37),
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
              ),

              // Last page
              _buildNavButton(
                icon: Icons.last_page,
                onPressed:
                    currentPage < totalPages && !isLoading
                        ? () => onPageChanged(totalPages)
                        : null,
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
    double iconSize = 20,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: onPressed != null ? const Color(0xFFF8E8B0) : Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        constraints: BoxConstraints(minWidth: 36, minHeight: 36),
        padding: EdgeInsets.all(8),
        icon: Icon(
          icon,
          size: iconSize,
          color: onPressed != null ? Colors.black87 : Colors.grey,
        ),
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
