import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crash/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  // get instanse
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> sendOtp(
      String phoneNumber, Function(String) onCodeSent) async {
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
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Called when the auto-retrieve timeout is reached
        // You can handle this as needed
      },
    );
  }

  static Future<void> verifyOtpAndNavigate(
      BuildContext context, String verificationId, String otp) async {
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

  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();

        return user;
      }).toList();
    });
  }
}
