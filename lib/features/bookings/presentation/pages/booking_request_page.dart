import 'package:flutter/material.dart';

class BookingRequestPage extends StatefulWidget {
  final String tripId;
  
  const BookingRequestPage({Key? key, required this.tripId}) : super(key: key);

  @override
  State<BookingRequestPage> createState() => _BookingRequestPageState();
}

class _BookingRequestPageState extends State<BookingRequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Booking Request Page - Trip ID: ${widget.tripId}'),
      ),
    );
  }
}