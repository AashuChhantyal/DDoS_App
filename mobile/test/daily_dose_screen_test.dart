import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Represents an article item shown inside DailyDoseScreen
class DoseArticle {
  final String title;
  final String category;

  const DoseArticle({required this.title, required this.category});
}

// Minimal DailyDoseScreen implementation for verification
class DailyDoseScreen extends StatefulWidget {
  final List<DoseArticle> articles;

  const DailyDoseScreen({super.key, required this.articles});

  @override
  State<DailyDoseScreen> createState() => _DailyDoseScreenState();
}

class _DailyDoseScreenState extends State<DailyDoseScreen> {
  String selectedCategory = 'All';
  String searchQuery = '';

  List<DoseArticle> get filteredArticles {
    return widget.articles.where((article) {
      final matchesCategory =
          selectedCategory == 'All' || article.category == selectedCategory;
      final matchesSearch = article.title.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    const categories = [
      'All',
      'Software Engineering',
      'DevOps',
      'System Design',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Dose')),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              key: const Key('search_field'),
              decoration: const InputDecoration(
                hintText: 'Search articles...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((cat) {
                final isSelected = selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    key: Key('chip_$cat'),
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          selectedCategory = cat;
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          // Article List
          Expanded(
            child: filteredArticles.isEmpty
                ? const Center(child: Text('No articles found'))
                : ListView.builder(
                    itemCount: filteredArticles.length,
                    itemBuilder: (context, index) {
                      final item = filteredArticles[index];
                      return ListTile(
                        title: Text(item.title),
                        subtitle: Text(item.category),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

void main() {
  final mockArticles = [
    const DoseArticle(
      title: 'Flutter State Management',
      category: 'Software Engineering',
    ),
    const DoseArticle(title: 'Kubernetes Pod Scaling', category: 'DevOps'),
    const DoseArticle(
      title: 'Designing Distributed Caches',
      category: 'System Design',
    ),
    const DoseArticle(title: 'CI/CD Pipeline Security', category: 'DevOps'),
  ];

  Widget createWidgetUnderTest() {
    return MaterialApp(home: DailyDoseScreen(articles: mockArticles));
  }

  group('DailyDoseScreen Widget Tests', () {
    testWidgets('Renders all articles by default when "All" chip is selected', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Flutter State Management'), findsOneWidget);
      expect(find.text('Kubernetes Pod Scaling'), findsOneWidget);
      expect(find.text('Designing Distributed Caches'), findsOneWidget);
      expect(find.text('CI/CD Pipeline Security'), findsOneWidget);
    });

    testWidgets('Filters articles when a category chip is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Tap on DevOps chip
      await tester.tap(find.byKey(const Key('chip_DevOps')));
      await tester.pumpAndSettle();

      // Should show DevOps articles
      expect(find.text('Kubernetes Pod Scaling'), findsOneWidget);
      expect(find.text('CI/CD Pipeline Security'), findsOneWidget);

      // Should hide non-DevOps articles
      expect(find.text('Flutter State Management'), findsNothing);
      expect(find.text('Designing Distributed Caches'), findsNothing);
    });

    testWidgets(
      'Filters articles in real-time when query is typed into search bar',
      (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        // Type "Distributed" into search field
        await tester.enterText(
          find.byKey(const Key('search_field')),
          'Distributed',
        );
        await tester.pumpAndSettle();

        expect(find.text('Designing Distributed Caches'), findsOneWidget);
        expect(find.text('Flutter State Management'), findsNothing);
        expect(find.text('Kubernetes Pod Scaling'), findsNothing);
      },
    );

    testWidgets('Displays empty state when search query matches no items', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byKey(const Key('search_field')), 'xyz123');
      await tester.pumpAndSettle();

      expect(find.text('No articles found'), findsOneWidget);
    });
  });
}
