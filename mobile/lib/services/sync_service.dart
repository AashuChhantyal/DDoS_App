import 'package:connectivity_plus/connectivity_plus.dart';
import 'api_service.dart';
import 'offline_service.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final OfflineService _offlineService = OfflineService();
  final ApiService _apiService = ApiService();

  void startListening() {
    Connectivity().onConnectivityChanged.listen((results) {
      if (results.isNotEmpty && !results.contains(ConnectivityResult.none)) {
        syncPendingReceipts();
      }
    });
  }

  Future<void> syncPendingReceipts() async {
    final queuedIds = _offlineService.getQueuedPostIds();
    if (queuedIds.isEmpty) return;

    for (final postId in queuedIds) {
      final success = await _apiService.markPostCompleted(postId);
      if (success) {
        await _offlineService.dequeueReadReceipt(postId);
      }
    }
  }
}
