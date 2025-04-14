import 'package:flutter/material.dart';
import 'package:trendycart_of_seller/features/auth/presentation/screens/onboarding.dart';

import '../../data/_auth_service.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber; // Pass the phone number from the previous screen

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _verifyOtp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authService.verifyPhoneOtp(
        widget.phoneNumber, // phone number passed from previous screen
        _otpController.text.trim(), // OTP entered by the user
      );

      if (response.session != null) {
        // If OTP is valid and the session is active
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Onboard()),
        ); // Redirect to the home screen
      } else {
        // Invalid OTP
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid OTP. Please try again.')),
        );
      }
    } catch (e) {
      // Error in OTP verification
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Displaying the phone number
            Text(
              'Enter the OTP sent to ${widget.phoneNumber}',
              style: const TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            // OTP input field
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'OTP',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            // Verify button
            ElevatedButton(
              onPressed: _isLoading ? null : _verifyOtp,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child:
                  _isLoading
                      ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      )
                      : const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
