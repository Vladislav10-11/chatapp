import 'package:crash/conatans/constans.dart';
import 'package:crash/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserTile extends StatelessWidget {
  final String avatar;

  final String name;
  final String msg;
  final Function onTap;
  const UserTile({
    super.key,
    required this.onTap,
    required this.avatar,
    required this.name,
    required this.msg,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        // You can use an image here if you have user avatars
        backgroundColor: Colors.white,
        child: Text(avatar.toUpperCase()),
      ),
      title: Text(
        name,
        style: GoogleFonts.spaceMono(color: whiteColor),
      ),
      subtitle: Text(
        msg,
        style: GoogleFonts.spaceMono(),
      ), // Add your logic for last message
      onTap: () {
        onTap();
      },
    );
  }
}
