import 'package:flutter/material.dart';

class ResSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function() onSearch;
  final bool isLoading;

  const ResSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Search...",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              onSubmitted: (_) => onSearch(),
              textInputAction: TextInputAction.search,
            ),
          ),
          SizedBox(width: 8.0),
          isLoading
              ? Container(
                height: 36,
                width: 36,
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(strokeWidth: 2.0),
              )
              : ElevatedButton(
                onPressed: controller.text.trim().isEmpty ? null : onSearch,
                child: Text("Search"),
              ),
        ],
      ),
    );
  }
}
