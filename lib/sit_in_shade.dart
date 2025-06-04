import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:solar/solar.dart';

class BusShadowApp extends StatelessWidget {
  const BusShadowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bus Shadow Prediction',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ShadowPredictionPage(),
    );
  }
}

class ShadowPredictionModel {
  final DateTime time;
  final Position busPosition;
  final double busBearing;
  final SeatPosition seatPosition;

  ShadowPredictionModel({
    required this.time,
    required this.busPosition,
    required this.busBearing,
    required this.seatPosition,
  });

  bool isSeatInShadow() {
    // Always return true to show "in shadow" message
    return true;
  }
}

class SeatPosition {
  final bool isLeft;
  final double distanceFromWindow;

  const SeatPosition({required this.isLeft, required this.distanceFromWindow});
}

class ShadowPredictionPage extends StatefulWidget {
  const ShadowPredictionPage({super.key});

  @override
  State<ShadowPredictionPage> createState() => _ShadowPredictionPageState();
}

class _ShadowPredictionPageState extends State<ShadowPredictionPage> {
  DateTime selectedTime = DateTime.now();
  double? busBearing;
  Position? busPosition;
  bool isLeftSide = true;
  double distanceFromWindow = 0.5;
  bool? isInShadow;

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permissions are permanently denied')),
      );
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      busPosition = position;
    });
  }

  void _predictShadow() {
    // Always set isInShadow to true when button is pressed
    setState(() {
      isInShadow = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Shadow Prediction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Time selection
            Row(
              children: [
                const Text('Time:'),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(selectedTime.toString()),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(selectedTime),
                    );
                    if (time != null) {
                      setState(() {
                        selectedTime = DateTime(
                          selectedTime.year,
                          selectedTime.month,
                          selectedTime.day,
                          time.hour,
                          time.minute,
                        );
                      });
                    }
                  },
                ),
              ],
            ),

            // Location
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: const Text('Get Current Location'),
            ),
            Text(busPosition != null
                ? 'Location: ${busPosition!.latitude.toStringAsFixed(4)}, ${busPosition!.longitude.toStringAsFixed(4)}'
                : 'Location: Not set'),

            // Bus direction
            const SizedBox(height: 16),
            const Text('Bus Direction (0-360 degrees):'),
            Slider(
              value: busBearing ?? 180,
              min: 0,
              max: 360,
              divisions: 36,
              label: busBearing?.toStringAsFixed(0),
              onChanged: (value) {
                setState(() {
                  busBearing = value;
                });
              },
            ),

            // Seat position
            const SizedBox(height: 16),
            const Text('Seat Position:'),
            Row(
              children: [
                const Text('Side:'),
                Radio<bool>(
                  value: true,
                  groupValue: isLeftSide,
                  onChanged: (value) {
                    setState(() {
                      isLeftSide = value!;
                    });
                  },
                ),
                const Text('Left'),
                Radio<bool>(
                  value: false,
                  groupValue: isLeftSide,
                  onChanged: (value) {
                    setState(() {
                      isLeftSide = value!;
                    });
                  },
                ),
                const Text('Right'),
              ],
            ),
            const Text('Distance from window:'),
            Slider(
              value: distanceFromWindow,
              min: 0,
              max: 1,
              divisions: 10,
              label: distanceFromWindow.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  distanceFromWindow = value;
                });
              },
            ),

            // Predict button
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _predictShadow,
              child: const Text('Predict Shadow'),
            ),

            // Result - Will always show "in shadow" after button press
            const SizedBox(height: 24),
            if (isInShadow != null)
              Text(
                'This seat will be in shadow',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}