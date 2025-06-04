import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class PaymentScreen extends StatefulWidget {
  final double fare;
  final String destination;

  const PaymentScreen({
    Key? key,
    required this.fare,
    required this.destination,
  }) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentConfiguration? _gPayConfig;
  late List<PaymentItem> _paymentItems;


  @override
  void initState() {
    super.initState();
    _paymentItems = [
      PaymentItem(
        label: 'Total',
        amount: widget.fare.toStringAsFixed(2),
        status: PaymentItemStatus.final_price,
      )
    ];
    _loadGooglePayConfig();
  }

  Future<void> _loadGooglePayConfig() async {
    final config = await PaymentConfiguration.fromAsset('assets/google_pay_config.json');
    setState(() {
      _gPayConfig = config;
    });
  }

  void _onGooglePayResult(paymentResult) {
    print("Payment Success: $paymentResult");
  }

  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('d MMM y').format(DateTime.now());
    String currentDay = DateFormat('EEEE').format(DateTime.now());
    String currentTime = DateFormat('h:mm a').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text(
          "Proceed Payment",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("$currentDate | $currentDay | $currentTime"),
                SizedBox(height: 5),
                Row(
                  children: [
                    Text("Thodupuzha", style: TextStyle(fontWeight: FontWeight.bold)),
                    Icon(Icons.arrow_right_alt, size: 24),
                    Text(widget.destination, style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 10),
                Text("Pay  ₹${widget.fare.toStringAsFixed(2)}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 20),
                const Text("UPI Payment", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: FaIcon(
                      FontAwesomeIcons.googlePay,
                      size: 40,
                      color: Colors.blue,
                    ),
                    title: Text("Take a screenshot and pay via Google Pay"),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Image.asset(
                    'build/flutter_assets/assets/images/qr.jpg',
                    width: 200,
                    height: 200,
                  ),
                ),
              ],
            ),
          ),
          // _gPayConfig != null
          //     ? GooglePayButton(
          //         paymentConfiguration: _gPayConfig!,
          //         paymentItems: _paymentItems,
          //         type: GooglePayButtonType.pay,
          //         onPaymentResult: _onGooglePayResult,
          //         loadingIndicator: Center(child: CircularProgressIndicator()),
          //       )
          //     : Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

