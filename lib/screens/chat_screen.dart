import 'package:crash/conatans/constans.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatefulWidget {
  final String username;

  ChatScreen({required this.username});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          widget.username.toUpperCase(),
          style: GoogleFonts.spaceMono(
            color: whiteColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              // Placeholder for chat messages, you can replace this with your chat UI
              color: backgroundColor,
              child: Center(
                child: Text(
                  'Chat messages go here'.toUpperCase(),
                  style: GoogleFonts.spaceMono(color: whiteColor),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: GoogleFonts.spaceMono(color: whiteColor)),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Add logic to send the message
                    print('Message sent: ${_messageController.text}');
                    _messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
