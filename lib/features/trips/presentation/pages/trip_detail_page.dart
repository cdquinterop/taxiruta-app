import 'package:flutter/material.dart';

class TripDetailPage extends StatelessWidget {
  final String tripId;
  
  const TripDetailPage({Key? key, required this.tripId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Trip Detail Page - ID: $tripId'),
      ),
    );
  }
}