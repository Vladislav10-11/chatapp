import 'package:crash/conatans/constans.dart';
import 'package:crash/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatListScreen extends StatelessWidget {
  final List<String> chatItems = [
    'John Doe',
    'Alice Smith',
    'Bob Johnson',
    'Eva Williams',
    'Charlie Brown',
    'Grace Davis',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          'Chats'.toUpperCase(),
          style: GoogleFonts.spaceMono(color: whiteColor),
        ),
      ),
      body: ListView.builder(
        itemCount: chatItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              // You can use an image here if you have user avatars
              backgroundColor: Colors.white,
              child: Text(chatItems[index][0].toUpperCase()),
            ),
            title: Text(
              chatItems[index],
              style: GoogleFonts.spaceMono(color: whiteColor),
            ),
            subtitle: Text(
              'Last message received...',
              style: GoogleFonts.spaceMono(),
            ), // Add your logic for last message
            onTap: () {
              // Navigate to chat screen or perform other actions when tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(username: chatItems[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
