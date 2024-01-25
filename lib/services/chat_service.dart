import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crash/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  // get instance of firebase
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // go through each individual user
        final user = doc.data();

        return user;
        // return user
      }).toList();
    });
  }
  // get user stream

  // send message
  Future<void> sendMessage(String receivedID, message) async {
    // get current user info
    final User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      final String currentUserID = currentUser.uid;
      final String currentUserPhone = currentUser.phoneNumber ?? '';
      final Timestamp timestamp = Timestamp.now();
      // create a new message
      Message newMessage = Message(
          senderId: currentUserPhone,
          receiverId: currentUserID,
          message: message,
          phoneNumber: currentUserPhone,
          timestamp: timestamp);
      // construct chat room for two users (sorted uniquess)
      List<String> ids = [currentUserID, currentUserPhone];
      ids.sort();
      String chatroomID = ids.join('_');

      // add new message to database
      await _firestore
          .collection("chat_rooms")
          .doc(chatroomID)
          .collection('message')
          .add(newMessage.toMap());
    }

    // get message
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

    Future<List<Message>> getMessages() async {
      try {
        QuerySnapshot querySnapshot =
            await FirebaseFirestore.instance.collection('messages').get();
        return querySnapshotToMessages(querySnapshot);
      } catch (e) {
        print('Error getting messages: $e');
        return [];
      }
    }
  }
}
