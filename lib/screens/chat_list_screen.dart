import 'package:crash/components/user_tile.dart';
import 'package:crash/conatans/constans.dart';
import 'package:crash/screens/chat_screen.dart';
import 'package:crash/services/auth_sevice.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatListScreen extends StatelessWidget {
  final AuthService _authService =
      AuthService(); // Create an instance of AuthService

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
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _authService.getUsersStream(), // Stream of user data
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Map<String, dynamic>> users = snapshot.data ?? [];
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> userData = users[index];
              return UserTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        receiverIdentifier: userData['identifier'],
                      ),
                    ),
                  );
                },
                avatar: ' ', // Provide avatar data
                name: userData['identifier'], // Display user's identifier
                msg: "", // You may display additional user information here
              );
            },
          );
        }
      },
    );
  }
}
