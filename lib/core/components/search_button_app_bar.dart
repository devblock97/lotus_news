import 'package:flutter/material.dart';

class SearchButtonAppBar extends StatelessWidget {
  const SearchButtonAppBar({super.key, this.startSearch});

  final VoidCallback? startSearch;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: startSearch,
      color: Colors.white,
    );
  }
}
