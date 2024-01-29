import 'package:crash/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthService {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> sendOtp(
    String phoneNumber,
    Function(String) onCodeSent,
  ) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 30),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          String userId = _auth.currentUser!.uid;

          // Create a user document in the "Users" collection
          await _firestore.collection("Users").doc(userId).set({
            'phoneNumber': phoneNumber,
            // Add other user data if needed
          });
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
    } catch (e) {
      print("Error sending OTP: $e");
    }
  }

  static Future<void> verifyOtpAndNavigate(
    BuildContext context,
    String verificationId,
    String otp,
  ) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential);

      // Navigate to HomeScreen after successful verification
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
      print("Verification Successful");
    } catch (e) {
      print("Verification Failed: $e");
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
