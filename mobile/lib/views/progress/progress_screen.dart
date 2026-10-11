import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/progress_provider.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = const Color(0xFFF9F6EE);
    final cardBgColor = const Color(0xFFEFECE3);
    final orangePrimary = const Color(0xFFD96B18);

    const weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Consumer<ProgressProvider>(
          builder: (context, progressProvider, child) {
            if (progressProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final progress = progressProvider.progressData;
            final xp = progress?.monthlyXp ?? 0;

            return SingleChildScrollView(
              primary: true,
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Top Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            color: orangePrimary,
                            size: 28,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'DDoS',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: cardBgColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 14,
                                  color: Colors.black54,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${DateTime.now().year}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: orangePrimary,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Title
                  const Text(
                    'My Progress',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // 2. Main Dark Streak Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: weekDays
                              .asMap()
                              .entries
                              .map(
                                (entry) => _StreakDay(
                                  day: entry.value,
                                  isActive:
                                      entry.key < (progress?.streakDays ?? 0),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${progress?.streakDays ?? 0} Days Streak 🔥',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Custom Semi-Circle Gauge Arc
                        SizedBox(
                          height: 100,
                          width: 180,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CustomPaint(
                                size: const Size(180, 90),
                                painter: ArcGaugePainter(
                                  progress: (xp / 2000).clamp(0.0, 1.0),
                                  activeColor: orangePrimary,
                                  inactiveColor: Colors.white24,
                                ),
                              ),
                              Positioned(
                                bottom: 25,
                                child: Column(
                                  children: [
                                    Text(
                                      'Level ${xp ~/ 500 + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '$xp XP earned this month',
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // 3. Analytics Overview Section
                  const Text(
                    'Analytics Overview',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.6,
                    children: [
                      _MetricCard(
                        icon: Icons.check_circle,
                        iconColor: orangePrimary,
                        title: 'Concepts Mastered',
                        value: '${progress?.conceptsMastered ?? 0}',
                        cardBgColor: cardBgColor,
                      ),
                      _MetricCard(
                        icon: Icons.trending_up,
                        iconColor: Colors.green,
                        title: 'Quiz Accuracy',
                        value: '${progress?.quizAccuracy ?? 0}% ↗',
                        cardBgColor: cardBgColor,
                      ),
                      _MetricCard(
                        icon: Icons.access_time_filled,
                        iconColor: orangePrimary,
                        title: 'Total Read Time',
                        value: '${progress?.totalReadHours ?? 0} hrs',
                        cardBgColor: cardBgColor,
                      ),
                      _MetricCard(
                        icon: Icons.emoji_events,
                        iconColor: orangePrimary,
                        title: 'Global Rank',
                        value: '#${progress?.globalRank ?? "-"}',
                        cardBgColor: cardBgColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // 4. Weekly Activity Section
                  const Text(
                    'Weekly Activity',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: weekDays.asMap().entries.map((entry) {
                        final index = entry.key;
                        final day = entry.value;
                        final weeklyData = progress?.weeklyActivity;
                        final height =
                            (weeklyData != null && index < weeklyData.length)
                            ? weeklyData[index]
                            : 0.1;

                        return _BarItem(
                          day: day,
                          heightFactor: height,
                          isHighlighted: height >= 0.8,
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // 5. Earned Badges Section
                  const Text(
                    'Earned Badges',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 45,
                    child: ListView.builder(
                      primary: false,
                      scrollDirection: Axis.horizontal,
                      itemCount: progress?.badges.length ?? 0,
                      itemBuilder: (context, index) {
                        final badge = progress!.badges[index];
                        return _BadgeChip(
                          label: badge.label,
                          icon: badge.icon,
                          cardBgColor: cardBgColor,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StreakDay extends StatelessWidget {
  final String day;
  final bool isActive;
  const _StreakDay({required this.day, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.local_fire_department,
          color: isActive ? Colors.orange : Colors.white24,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(day, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final Color cardBgColor;

  const _MetricCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.cardBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  final String day;
  final double heightFactor;
  final bool isHighlighted;

  const _BarItem({
    required this.day,
    required this.heightFactor,
    required this.isHighlighted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 100 * heightFactor.clamp(0.1, 1.0),
          width: 18,
          decoration: BoxDecoration(
            color: isHighlighted
                ? const Color(0xFFD96B18)
                : const Color(0xFFE5DEC9),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 8),
        Text(day, style: const TextStyle(fontSize: 11, color: Colors.black54)),
      ],
    );
  }
}

class _BadgeChip extends StatelessWidget {
  final String label;
  final String icon;
  final Color cardBgColor;

  const _BadgeChip({
    required this.label,
    required this.icon,
    required this.cardBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class ArcGaugePainter extends CustomPainter {
  final double progress;
  final Color activeColor;
  final Color inactiveColor;

  ArcGaugePainter({
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 14.0;
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - strokeWidth;

    final backgroundPaint = Paint()
      ..color = inactiveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final activePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14,
      3.14,
      false,
      backgroundPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14,
      3.14 * progress.clamp(0.0, 1.0),
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
