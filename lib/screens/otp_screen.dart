import 'package:crash/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;

  OTPScreen({required this.phoneNumber});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _otpController = TextEditingController();
  late String verificationId;

  Future<void> sendOtp(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        print("Automatic Verification Completed");
      },
      verificationFailed: (FirebaseAuthException e) {
        print("Verification Failed: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          this.verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Called when the auto-retrieve timeout is reached
        // You can handle this as needed
      },
    );
  }

  Future<void> verifyOtp(String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
      print("Verification Successful");
      // Add code to navigate to the next screen or perform other actions upon successful verification
    } catch (e) {
      print("Verification Failed: $e");
      // Handle the verification failure
    }
  }

  @override
  void initState() {
    super.initState();
    sendOtp(widget.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter OTP sent to ${widget.phoneNumber}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            PinCodeTextField(
              appContext: context,
              length: 6,
              controller: _otpController,
              onChanged: (value) {
                // Handle OTP changes
                print(value);
              },
              onCompleted: (value) {
                // Handle OTP submission
                verifyOtp(value);
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // You can resend OTP or perform other actions if needed
                sendOtp(widget.phoneNumber);
              },
              child: Text('Resend OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
