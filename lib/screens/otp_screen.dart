import 'package:crash/services/auth_sevice.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  OtpScreen({required this.phoneNumber});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late String verificationId;
  TextEditingController _otpController = TextEditingController();

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
                AuthService.verifyOtpAndNavigate(
                    context, verificationId, value);
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // You can resend OTP or perform other actions if needed
                AuthService.sendOtp(widget.phoneNumber, (String id) {
                  setState(() {
                    verificationId = id;
                  });
                });
              },
              child: Text('Resend OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
