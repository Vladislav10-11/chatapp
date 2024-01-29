import 'package:crash/conatans/constans.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatefulWidget {
  final String receiverIdentifier;

  ChatScreen({required this.receiverIdentifier});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController = TextEditingController();

  // Reference to Firestore collection
  final CollectionReference _messagesCollection =
      FirebaseFirestore.instance.collection('messages');

  // Method to send message
  Future<void> _sendMessage() async {
    String messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      // Add message to Firestore
      await _messagesCollection.add({
        'username': widget.receiverIdentifier,
        'message': messageText,
        'timestamp': DateTime.now(),
      });
      // Clear text field after sending message
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          widget.receiverIdentifier.toUpperCase(),
          style: GoogleFonts.spaceMono(color: whiteColor),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesCollection
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                final List<DocumentSnapshot> documents = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final message =
                        documents[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(
                        message['username'].toUpperCase(),
                        style: GoogleFonts.spaceMono(color: whiteColor),
                      ),
                      subtitle: Text(message['message'],
                          style: GoogleFonts.spaceMono(color: whiteColor)),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: GoogleFonts.spaceMono(color: whiteColor),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: whiteColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
