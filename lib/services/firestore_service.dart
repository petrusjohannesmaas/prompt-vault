import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference _vaultCollection = FirebaseFirestore.instance
      .collection('vault');

  // Save a new prompt result to Firestore
  Future<void> savePrompt(String title, String body) async {
    await _vaultCollection.add({
      'title': title,
      'body': body,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Get a stream of prompts ordered by creation time (newest first)
  Stream<QuerySnapshot> getPromptsStream() {
    return _vaultCollection.orderBy('createdAt', descending: true).snapshots();
  }

  // Delete a prompt by its document ID
  Future<void> deletePrompt(String docId) async {
    await _vaultCollection.doc(docId).delete();
  }

  // Update an existing prompt
  Future<void> updatePrompt(String docId, String title, String body) async {
    await _vaultCollection.doc(docId).update({
      'title': title,
      'body': body,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
