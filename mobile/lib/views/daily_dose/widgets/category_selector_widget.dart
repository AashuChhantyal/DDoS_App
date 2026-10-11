import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/feed_provider.dart';

class CategorySelectorWidget extends StatelessWidget {
  final List<String> categories = const [
    'All',
    'Software Engineering',
    'DevOps',
    'System Design',
    'Mobile',
  ];

  const CategorySelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final feedProvider = Provider.of<FeedProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 40,
      child: ListView.builder(
        primary: false, // Prevents PrimaryScrollController conflict
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = feedProvider.selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(
                category,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.white : colorScheme.onSurface,
                ),
              ),
              selected: isSelected,
              selectedColor: colorScheme.primary,
              backgroundColor: colorScheme.surface,
              side: BorderSide.none,
              showCheckmark: false,
              onSelected: (selected) {
                if (selected) {
                  feedProvider.setCategory(category);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
