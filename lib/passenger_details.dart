import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:first_page/widgets/payment_screen.dart';

class SeatBookingScreen extends StatefulWidget {
  final Map<String, dynamic> busDetails;
  final List<String> selectedSeats;
  final double fare;

  const SeatBookingScreen({
    Key? key,
    required this.busDetails,
    required this.selectedSeats,
    required this.fare,
  }) : super(key: key);


  @override
  _SeatBookingScreenState createState() => _SeatBookingScreenState();
}

class _SeatBookingScreenState extends State<SeatBookingScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String? selectedGender;

  Future<void> bookSeats() async {
    try {
      await FirebaseFirestore.instance.collection('bookings').add({
        'busName': widget.busDetails['busName'],
        'destination': widget.busDetails['destination'],
        'departureTime': widget.busDetails['departureTime'],
        'route': widget.busDetails['route'],
        'selectedSeats': widget.selectedSeats,
        'fare': widget.fare,
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'passenger': {
          'name': nameController.text.trim(),
          'age': int.tryParse(ageController.text.trim()) ?? 0,
          'gender': selectedGender,
        },
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Booking proceeded")),
      );

      // Navigate or reset
      Navigator.pop(context);
    } catch (e) {
      print("Error booking: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error booking. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        leading: BackButton(color: Colors.white),
          title: const Text("Passenger Details", style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text(
                  "${widget.busDetails['busName']}",
                  style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "Thodupuzha ➜ ${widget.busDetails['destination']}",
                  style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Time: ${widget.busDetails['departureTime']}",
                  style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Seats: ${widget.selectedSeats.join(", ")}",
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(labelText: "Phone (optional)", border: OutlineInputBorder()),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: "Full Name", border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: ageController,
                            decoration: const InputDecoration(labelText: "Age", border: OutlineInputBorder()),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Row(
                            children: [
                              Radio<String>(
                                value: "Male",
                                groupValue: selectedGender,
                                onChanged: (value) => setState(() => selectedGender = value),
                              ),
                              const Text("Male"),
                              Radio<String>(
                                value: "Female",
                                groupValue: selectedGender,
                                onChanged: (value) => setState(() => selectedGender = value),
                              ),
                              const Text("Female"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "By clicking on Book Now, you agree to our Privacy Policy & Terms & Conditions",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    //Spacer(),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Amount", style: TextStyle(color: Colors.white, fontSize: 16)),
                                  Text(
                                    "₹${widget.fare.toStringAsFixed(2)}",
                                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  const Text("Incl. all taxes", style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ],
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () async{
                              await bookSeats(); // Save to Firestore first

                              // Navigate to payment only if booking succeeds
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentScreen(fare: widget.fare,
                                    destination: widget.busDetails['destination'],),
                                ),
                              );
                            },
                            child: Text(
                              "Book Now",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
