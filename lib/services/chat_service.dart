import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crash/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  Future<void> sendMessage(String receivedID, String message) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        final String currentUserID = currentUser.uid;
        final String currentUserPhone = currentUser.phoneNumber ?? '';
        final Timestamp timestamp = Timestamp.now();

        Message newMessage = Message(
          senderId: currentUserPhone,
          receiverId: currentUserID,
          message: message,
          phoneNumber: currentUserPhone,
          timestamp: timestamp,
        );

        List<String> ids = [currentUserID, receivedID];
        ids.sort();
        String chatroomID = ids.join('_');

        await _firestore
            .collection("chat_rooms")
            .doc(chatroomID)
            .collection('messages')
            .add(newMessage.toMap());
      }
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  List<Message> querySnapshotToMessages(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((DocumentSnapshot doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Message(
        senderId: data['senderId'],
        receiverId: data['receiverId'],
        message: data['message'],
        phoneNumber: data['phoneNumber'],
        timestamp: data['timestamp'],
      );
    }).toList();
  }

  Future<List<Message>> getMessages(String chatroomID) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('chat_rooms')
          .doc(chatroomID)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .get();
      return querySnapshotToMessages(querySnapshot);
    } catch (e) {
      print('Error getting messages: $e');
      return [];
    }
  }
}
