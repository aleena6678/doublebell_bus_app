import 'package:first_page/widgets/bus_search_app.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_page/widgets/signin_screen.dart';
import 'package:flutter/gestures.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _username = '';
  String _password = '';
  bool _isLoading = false;

  Future<void> _registerUser() async {
    try {
      final auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      // Store user info in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': _name,
        'email': _email,
        'username': _username,
        'createdAt': Timestamp.now(),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NextPage()),
      );
    } catch (e) {
      print('Error during sign up: $e');

    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset('build/flutter_assets/assets/images/green_bus.png', height: 200), // Add asset image here
                const SizedBox(height: 20),
                const Text("Welcome", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const Text("You are just one step away", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                _buildTextField("Name", onChanged: (v) => _name = v, validator: (v) => v!.isEmpty ? 'Name required' : null),
                _buildTextField("Email", onChanged: (v) => _email = v, validator: (v) => !v!.contains('@') ? 'Valid email required' : null),
                _buildTextField("Username", onChanged: (v) => _username = v, validator: (v) => v!.isEmpty ? 'Username required' : null),
                _buildTextField("Password", isPassword: true, onChanged: (v) => _password = v, validator: (v) => v!.length < 6 ? 'Min 6 chars' : null),
                const SizedBox(height: 12),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    text: "Already have an account? ",
                    children: [
                      TextSpan(
                        text: "Sign in",
                        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,MaterialPageRoute(builder: (context) => SignInScreen()));
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                    if (_formKey.currentState!.validate()) {
                      setState(() => _isLoading = true);
                      _registerUser();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Sign up", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                const SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    text: "By clicking on Continue, you agree to our ",
                    children: [
                      TextSpan(text: "Privacy Policy", style: TextStyle(color: const Color.fromARGB(255, 210, 16, 25))),
                      TextSpan(text: " and "),
                      TextSpan(text: "Terms & Conditions", style: TextStyle(color: const Color.fromARGB(255, 245, 8, 8))),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label,
      {bool isPassword = false,
        required Function(String) onChanged,
        String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}

class NextPage extends StatelessWidget {
  const NextPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigate to HomePage after 2 seconds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BusSearchApp()),
        );
      });
    });

    return const Scaffold(
      body: Center(
        child: Text('Registration Successful'),
      ),
    );
  }
}
