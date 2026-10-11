import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../models/post.dart';
import 'widgets/streak_banner_widget.dart';
import '../daily_dose/daily_dose_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Post>> _dailyPostsFuture;
  final GlobalKey<StreakBannerWidgetState> _bannerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _dailyPostsFuture = _apiService.getDailyPosts();
  }

  Future<void> _openDailyDose() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DailyDoseScreen()),
    );
    // Refresh the streak widget when returning back
    _bannerKey.currentState?.refreshStreakData();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryAmber = Color(0xFFD97706);
    const Color bgLight = Color(0xFFFAF9F8);

    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: bgLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top App Bar (Logo, Title & Dynamic Streak Avatar)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        height: 32,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.shield,
                              color: primaryAmber,
                              size: 32,
                            ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'DDoS',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: primaryAmber,
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.amberAccent,
                        child: Text(
                          user?.name.isNotEmpty == true
                              ? user!.name[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${user?.streakDays ?? 0} 🔥',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 2. Dynamic Greeting Header
              Text(
                'Good Day, ${user?.name ?? 'Developer'}! 👋',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Ready for today's dose?",
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
              const SizedBox(height: 16),

              // 3. Streak & Gamification Banner Widget
              StreakBannerWidget(key: _bannerKey),
              const SizedBox(height: 20),

              // 4. Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search topics, code, patterns...',
                  prefixIcon: const Icon(Icons.search, color: Colors.black45),
                  filled: true,
                  fillColor: const Color(0xFFF0ECE8),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 5. Featured Daily Dose Section (Dynamic Data)
              const Text(
                'Featured Daily Dose',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              FutureBuilder<List<Post>>(
                future: _dailyPostsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final posts = snapshot.data ?? [];
                  if (posts.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('No featured posts for today.'),
                    );
                  }

                  final featuredPost = posts.first;

                  return GestureDetector(
                    onTap: _openDailyDose,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            featuredPost.title,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              color: Colors.lightGreenAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 14,
                                    color: Colors.white70,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${featuredPost.readTimeMinutes} min read',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFDE68A),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  featuredPost.category,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // 6. Learning Tracks Carousel
              const Text(
                'Learning Tracks',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildTrackCard('Flutter\nArchitecture', 0.6, primaryAmber),
                    _buildTrackCard('Clean Code', 0.8, primaryAmber),
                    _buildTrackCard('REST APIs', 0.4, primaryAmber),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 7. Recommended Articles List
              const Text(
                'Recommended Articles',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildArticleCard(
                      'Flutter Clean Architecture',
                      '3 min read',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildArticleCard(
                      'SOLID Principles Simplified',
                      '2 min read',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildTrackCard(
    String title,
    double progress,
    Color activeColor,
  ) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            color: activeColor,
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  static Widget _buildArticleCard(String title, String readTime) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                readTime,
                style: const TextStyle(fontSize: 11, color: Colors.black54),
              ),
              const Icon(Icons.bookmark_border, size: 18, color: Colors.amber),
            ],
          ),
        ],
      ),
    );
  }
}
