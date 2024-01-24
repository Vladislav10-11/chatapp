import 'package:crash/components/user_tile.dart';
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
          return UserTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChatScreen(username: chatItems[index]),
                    ));
              },
              avatar: chatItems[index],
              name: chatItems[index],
              msg: chatItems[index]);
        },
      ),
    );
  }
}
