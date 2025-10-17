import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'lib/features/trips/presentation/state/trip_provider.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) { 
    return MaterialApp(
      title: 'Trip Test',
      home: TripTestPage(),
    );
  }
}

class TripTestPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripState = ref.watch(tripProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Trips'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              ref.read(tripProvider.notifier).loadPendingTrips();
            },
            child: Text('Load Pending Trips'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(tripProvider.notifier).loadInProgressTrips();
            },
            child: Text('Load In Progress Trips'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(tripProvider.notifier).loadCompletedTrips();
            },
            child: Text('Load Completed Trips'),
          ),
          if (tripState.isLoading)
            CircularProgressIndicator(),
          if (tripState.error != null)
            Text('Error: ${tripState.error}'),
          Expanded(
            child: ListView(
              children: [
                Text('Pending: ${tripState.pendingTrips.length}'),
                Text('In Progress: ${tripState.inProgressTrips.length}'),
                Text('Completed: ${tripState.completedTrips.length}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}