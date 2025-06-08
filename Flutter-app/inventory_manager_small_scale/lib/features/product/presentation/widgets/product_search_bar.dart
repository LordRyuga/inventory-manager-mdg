import 'package:flutter/material.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/app_utils.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final String hintText;
  final String? initialValue;

  const SearchBarWidget({
    super.key,
    required this.onSearchChanged,
    this.hintText = 'Search...',
    this.initialValue,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    AppUtils.debounceSearch(() {
      widget.onSearchChanged(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppStyles.cardDecoration,
      child: TextField(
        controller: _controller,
        onChanged: _onSearchChanged,
        decoration: AppStyles.inputDecoration(
          labelText: '',
          hintText: widget.hintText,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    widget.onSearchChanged('');
                  },
                )
              : null,
        ).copyWith(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppStyles.spacingMD,
            vertical: AppStyles.spacingMD,
          ),
        ),
      ),
    );
  }
}