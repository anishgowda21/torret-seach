import 'package:flutter/material.dart';

class ResSearchBar extends StatefulWidget {
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
  State<ResSearchBar> createState() => _ResSearchBarState();
}

class _ResSearchBarState extends State<ResSearchBar> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: "Search...",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              onSubmitted: (_) {
                widget.onSearch();
                _focusNode.unfocus();
              },
              textInputAction: TextInputAction.search,
            ),
          ),
          SizedBox(width: 8.0),
          widget.isLoading
              ? Container(
                height: 36,
                width: 36,
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(strokeWidth: 2.0),
              )
              : ElevatedButton(
                onPressed: () {
                  if (widget.controller.text.trim().isNotEmpty) {
                    widget.onSearch();
                    _focusNode.unfocus();
                  }
                },
                child: Text("Search"),
              ),
        ],
      ),
    );
  }
}
