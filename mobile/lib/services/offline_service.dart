import 'package:hive_flutter/hive_flutter.dart';
import '../models/post.dart';

class OfflineService {
  static final OfflineService _instance = OfflineService._internal();
  factory OfflineService() => _instance;
  OfflineService._internal();

  late Box _postsBox;
  late Box _syncQueueBox;

  Future<void> init() async {
    _postsBox = await Hive.openBox('downloaded_posts');
    _syncQueueBox = await Hive.openBox('sync_queue');
  }

  // Cache single post locally
  Future<void> savePostOffline(Post post) async {
    await _postsBox.put(post.id, post.toJson());
  }

  // Remove single post from offline storage
  Future<void> removePostOffline(String postId) async {
    await _postsBox.delete(postId);
  }

  // Check if post is cached
  bool isPostDownloaded(String postId) {
    return _postsBox.containsKey(postId);
  }

  // Cache daily feed list
  Future<void> cacheDailyFeed(List<Post> posts) async {
    for (var post in posts) {
      await savePostOffline(post);
    }
  }

  // Retrieve cached posts (synchronous, returns List<Post>)
  List<Post> getCachedDailyFeed() {
    return _postsBox.values
        .map((e) => Post.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  // Queue read receipt when offline
  Future<void> queueReadReceipt(String postId) async {
    await _syncQueueBox.put(postId, {
      'postId': postId,
      'completedAt': DateTime.now().toIso8601String(),
    });
  }

  // Retrieve queued items for sync
  List<String> getQueuedPostIds() {
    return _syncQueueBox.keys.cast<String>().toList();
  }

  // Remove completed item from sync queue
  Future<void> dequeueReadReceipt(String postId) async {
    await _syncQueueBox.delete(postId);
  }
}
