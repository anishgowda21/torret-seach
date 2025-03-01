// lib/widgets/pagination_control.dart

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
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Page slider
          Row(
            children: [
              Text(
                'Page:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Expanded(
                child: Slider(
                  value: currentPage.toDouble(),
                  min: 1,
                  max: totalPages.toDouble(),
                  divisions: totalPages > 1 ? totalPages - 1 : 1,
                  label: currentPage.toString(),
                  activeColor: const Color(0xFFD4AF37),
                  onChanged:
                      isLoading
                          ? null
                          : (value) {
                            onPageChanged(value.round());
                          },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37),
                  borderRadius: BorderRadius.circular(12),
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
            ],
          ),

          // Page navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // First page
              _buildPageButton(
                icon: Icons.first_page,
                onPressed:
                    currentPage > 1 && !isLoading
                        ? () => onPageChanged(1)
                        : null,
              ),

              // Previous page
              _buildPageButton(
                icon: Icons.arrow_back_ios,
                onPressed:
                    currentPage > 1 && !isLoading
                        ? () => onPageChanged(currentPage - 1)
                        : null,
              ),

              // Loading indicator or spacer
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
              _buildPageButton(
                icon: Icons.arrow_forward_ios,
                onPressed:
                    currentPage < totalPages && !isLoading
                        ? () => onPageChanged(currentPage + 1)
                        : null,
              ),

              // Last page
              _buildPageButton(
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

  Widget _buildPageButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: onPressed != null ? const Color(0xFFF8E8B0) : Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          size: 18,
          color: onPressed != null ? Colors.black87 : Colors.grey,
        ),
        onPressed: onPressed,
        splashRadius: 24,
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
