import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewDiscussionPage extends StatefulWidget {
  @override
  _ReviewDiscussionPageState createState() => _ReviewDiscussionPageState();
}

class _ReviewDiscussionPageState extends State<ReviewDiscussionPage> {
  final TextEditingController _reviewController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _addReview() async {
    if (_reviewController.text.isNotEmpty) {
      try {
        // Get current user
        final user = _auth.currentUser;
        if (user == null) {
          // Handle case where user is not logged in
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please sign in to post a review')),
          );
          return;
        }

        // Add review to Firestore
        await _firestore.collection('reviews').add({
          'userId': user.uid,
          'userEmail': user.email ?? 'Anonymous',
          'review': _reviewController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });

        _reviewController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error posting review: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Review & Discussion")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome to the Review & Discussion section. Here, users can share their experiences and provide feedback.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  "Guidelines:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "1. Be respectful.\n2. Avoid spam.\n3. Share experiences.",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _reviewController,
                    decoration: InputDecoration(
                      hintText: "Write a review...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addReview,
                  child: Text("Post"),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('reviews')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var review = snapshot.data!.docs[index];
                    var data = review.data() as Map<String, dynamic>;

                    // Format timestamp
                    String formattedTime = 'Just now';
                    if (data['timestamp'] != null) {
                      formattedTime = data['timestamp'].toDate().toString().substring(0, 16);
                    }

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['userEmail'] ?? 'Anonymous',  // Changed from 'email' to 'userEmail'
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(data['review']),
                            SizedBox(height: 5),
                            Text(
                              formattedTime,
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
