import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/streak_service.dart';

class StreakBannerWidget extends StatefulWidget {
  const StreakBannerWidget({super.key});

  @override
  State<StreakBannerWidget> createState() => StreakBannerWidgetState();
}

class StreakBannerWidgetState extends State<StreakBannerWidget> {
  Timer? _timer;

  int _streakDays = 0;
  int _dailyProgress = 0;
  final int _dailyGoal = 1;
  bool _hasTriggeredCompletion = false;

  @override
  void initState() {
    super.initState();

    _loadStreakData();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      final authProvider = context.read<AuthProvider>();
      final remaining = authProvider.remainingDelayDuration;

      // Reload streak data automatically once timer hits zero
      if (remaining <= Duration.zero && !_hasTriggeredCompletion) {
        _hasTriggeredCompletion = true;
        _loadStreakData();
      } else if (remaining > Duration.zero) {
        _hasTriggeredCompletion = false;
      }

      setState(() {});
    });
  }

  Future<void> _loadStreakData() async {
    final streak = await StreakService.getStreak();
    final progress = await StreakService.getTodayProgress();

    if (!mounted) return;

    setState(() {
      _streakDays = streak;
      _dailyProgress = progress;
    });
  }

  /// Refreshes the streak metrics; can be called externally via a GlobalKey.
  Future<void> refreshStreakData() async {
    await _loadStreakData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    if (duration <= Duration.zero) return '00:00';

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    if (hours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final remaining = authProvider.remainingDelayDuration;
    final progressRatio = (_dailyProgress / _dailyGoal).clamp(0.0, 1.0);
    final isCompleted = _dailyProgress >= _dailyGoal;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD97706), Color(0xFFB45309)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 8),
                  Text(
                    '$_streakDays Day Streak!',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isCompleted
                      ? 'Completed'
                      : remaining > Duration.zero
                      ? '⏱️ ${_formatDuration(remaining)}'
                      : 'Ready',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Daily Progress: $_dailyProgress/$_dailyGoal completed',
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progressRatio,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.amberAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
