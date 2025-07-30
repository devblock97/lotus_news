import 'package:flutter/material.dart';

class SearchBarAppBar extends StatelessWidget {
  const SearchBarAppBar({
    super.key,
    required this.isSearching,
    this.controller,
  });

  final bool isSearching;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1000),
      transitionBuilder: (child, animation) => SizeTransition(
        sizeFactor: animation,
        axisAlignment: -1.0,
        child: FadeTransition(opacity: animation, child: child),
      ),
      child: isSearching
          ? SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                controller: controller,
                padding: const WidgetStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 8.0),
                ),
                onTap: () {
                  controller.openView();
                },
                onChanged: (_) {
                  controller.openView();
                },
                leading: const Icon(Icons.search),
              );
            },
            suggestionsBuilder: (BuildContext context, SearchController controller) {
              return List.generate(20, (index) => Text('data at index: $index'));
            },
          )
          : const Text('Expandable Search Bar', key: ValueKey('title')),
    );
  }
}
