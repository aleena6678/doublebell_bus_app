import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:first_page/widgets/passenger_details.dart';

class SeatSelectionScreen extends StatefulWidget {
  final Map<String, dynamic> bus;
  const SeatSelectionScreen({super.key, required this.bus});

  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  double? seatPrice;

  // Fixed seat layout from the image
  List<List<String>> seats = [
    ['A', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
    ['A', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
    ['A', 'A', ' ', 'A', 'A', 'A'],
    ['B', 'A', ' ', 'A', 'A', 'B'],
    [' ', ' ', ' ', ' ', ' ', ' ', 'A', 'A', 'A'],
    ['A', 'A', ' ', 'A', 'A', 'A'],
    ['A', 'A', ' ', 'A', 'A', 'B'],
    ['B', 'A', ' ', 'A', 'A', 'A'],
    ['A', 'A', ' ', 'A', 'A', 'B'],
    ['A', 'A', ' ', 'A', 'A', 'B'],
    [' ', ' ', ' ', ' ', ' ', ' ', 'A', 'A', 'A'],
    ['A', 'A', ' ', 'A', 'A', 'B'],
  ];

  @override
  void initState() {
    super.initState();
    fetchSeatPrice();
  }

  Future<void> fetchSeatPrice() async {
    final destination = widget.bus['destination'];
    final snapshot = await FirebaseFirestore.instance
        .collection('fare_distance')
        .where('destination', isEqualTo: destination)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      setState(() {
        seatPrice = data['fare']?.toDouble() ?? 0.0;
      });
    }
  }

  List<String> getSelectedSeats() {
    List<String> selected = [];
    for (int row = 0; row < seats.length; row++) {
      for (int col = 0; col < seats[row].length; col++) {
        if (seats[row][col] == 'S') {
          selected.add("R${row + 1}C${col + 1}"); // You can customize the seat label format
        }
      }
    }
    return selected;
  }

  void toggleSeat(int row, int col) {
    setState(() {
      if (seats[row][col] == 'A') {
        seats[row][col] = 'S';
      } else if (seats[row][col] == 'S') {
        seats[row][col] = 'A';
      }
    });
  }

  int getSelectedSeatCount() {
    return seats.expand((row) => row).where((seat) => seat == 'S').length;
  }

  @override
  Widget build(BuildContext context) {
    int selectedSeats = getSelectedSeatCount();
    double totalFare = (seatPrice ?? 0.0) * selectedSeats;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Choose your seat!",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.redAccent,
      ),
      body: seatPrice == null
      ? const Center(child: CircularProgressIndicator())
      : Column(
        children: [
          // Display selected route
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Thodupuzha to ${widget.bus['destination']}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.square, color: Colors.red), Text(" Booked  "),
                Icon(Icons.square, color: Colors.grey), Text(" Available  "),
                Icon(Icons.square, color: Colors.orange), Text(" Your Seat "),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: seats.asMap().entries.map((entry) {
                  int row = entry.key;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: entry.value.asMap().entries.map((seatEntry) {
                      int col = seatEntry.key;
                      String seat = seatEntry.value;
                      if (seat == ' ') return const SizedBox(width: 20);
                      Color seatColor = (seat == 'B')
                          ? Colors.red
                          : (seat == 'A')
                            ? Colors.grey
                            : Colors.orange;
                      return GestureDetector(
                        onTap: () => toggleSeat(row, col),
                        child: Container(
                          width: 35,
                          height: 35,
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: seatColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: selectedSeats > 0
          ? Container(
        color: Colors.redAccent,
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$selectedSeats Seats  ₹${totalFare.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              onPressed: () {
                // Proceed action
                Navigator.push(context, MaterialPageRoute(builder: (context) => SeatBookingScreen(
                  busDetails: widget.bus,
                  selectedSeats: getSelectedSeats(), // You’d need to implement this
                  fare: totalFare,
                ),
                ),
                );
              },
              child: const Text(
                "Proceed",
                style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
          ],
        ),
      )
          : null, // Hide if no seat selected
    );
  }
}

 
