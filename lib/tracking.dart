import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Tracking extends StatelessWidget{
  final String url = "https://www.google.com/android/find/";

  Future<void> _launchURL() async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Track your bus")),
      body: Center(
        child: ElevatedButton(
          onPressed: _launchURL,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero, // Remove default padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.deepOrange],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              child: Text(
                "Track",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}