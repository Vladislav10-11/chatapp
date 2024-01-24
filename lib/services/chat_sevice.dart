import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class ChatService {
  // get instanse
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get user stream
  /*
  <List<Map<String,dynamic>> = 
  {
    'phone'  
  }
  
  
  
  */
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();

        return user;
      }).toList();
    });
  }

  // send message

  // get message
}
