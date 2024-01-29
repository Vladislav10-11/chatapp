import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreTestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Test'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _testFirestoreConnectivity(context);
          },
          child: Text('Test Firestore Connectivity'),
        ),
      ),
    );
  }

  Future<void> _testFirestoreConnectivity(BuildContext context) async {
    try {
      // Access a Firestore collection
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(
              'test_collection') // Replace 'test_collection' with your collection name
          .get();

      // Iterate through the documents in the collection
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        print('Document ID: ${documentSnapshot.id}');
        print('Data: ${documentSnapshot.data()}');
      }

      // Display success message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Firestore Connectivity Test'),
            content: Text('Firestore connectivity test successful!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Display error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Firestore Connectivity Test'),
            content: Text('Error connecting to Firestore: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }
}
