import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sync_service_test.mocks.dart';

abstract class ReceiptRepository {
  Future<void> sendReceipt(String receiptId);
}

class SyncManager {
  final Connectivity connectivity;
  final ReceiptRepository repository;
  final List<String> queue = [];
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  SyncManager({required this.connectivity, required this.repository});

  void queueReceipt(String receiptId) {
    queue.add(receiptId);
  }

  void initialize() {
    _subscription = connectivity.onConnectivityChanged.listen((results) async {
      final isOnline = results.any((r) => r != ConnectivityResult.none);
      if (isOnline && queue.isNotEmpty) {
        await processQueue();
      }
    });
  }

  Future<void> processQueue() async {
    final itemsToSync = List<String>.from(queue);
    for (final id in itemsToSync) {
      await repository.sendReceipt(id);
      queue.remove(id);
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}

@GenerateMocks([Connectivity, ReceiptRepository])
void main() {
  group('Connectivity Background Sync Tests', () {
    late MockConnectivity mockConnectivity;
    late MockReceiptRepository mockRepository;
    late SyncManager syncManager;
    late StreamController<List<ConnectivityResult>> connectivityController;

    setUp(() {
      mockConnectivity = MockConnectivity();
      mockRepository = MockReceiptRepository();
      connectivityController =
          StreamController<List<ConnectivityResult>>.broadcast();

      when(
        mockConnectivity.onConnectivityChanged,
      ).thenAnswer((_) => connectivityController.stream);

      syncManager = SyncManager(
        connectivity: mockConnectivity,
        repository: mockRepository,
      );
      syncManager.initialize();
    });

    tearDown(() {
      connectivityController.close();
      syncManager.dispose();
    });

    test('Queues items offline and does not trigger sendReceipt', () async {
      syncManager.queueReceipt('receipt_101');
      connectivityController.add([ConnectivityResult.none]);

      await pumpEventQueue();

      expect(syncManager.queue, contains('receipt_101'));
      verifyNever(mockRepository.sendReceipt(argThat(isNotNull)));
    });

    test(
      'Flushes queued read receipts upon switching to online status',
      () async {
        syncManager.queueReceipt('receipt_101');
        syncManager.queueReceipt('receipt_102');

        when(
          mockRepository.sendReceipt(argThat(isNotNull)),
        ).thenAnswer((_) async {});

        // Simulate coming back online via Wi-Fi
        connectivityController.add([ConnectivityResult.wifi]);

        await pumpEventQueue();

        verify(mockRepository.sendReceipt('receipt_101')).called(1);
        verify(mockRepository.sendReceipt('receipt_102')).called(1);
        expect(syncManager.queue, isEmpty);
      },
    );
  });
}
