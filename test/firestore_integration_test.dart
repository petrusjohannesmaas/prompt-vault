import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  test('Creating a post should add a document to the vault collection', () async {
    final db = FakeFirebaseFirestore();

    final post = <String, dynamic>{
      "title": "My Test Post",
      "body":
          "If you want to make sure your test is working you've come to the right place!",
      "createdAt": FieldValue.serverTimestamp(),
    };

    final DocumentReference docRef = await db.collection("vault").add(post);

    final DocumentSnapshot snapshot = await db
        .collection("vault")
        .doc(docRef.id)
        .get();

    expect(snapshot.exists, true);
    expect(snapshot.get('title'), "My Test Post");
    expect(snapshot.get('body'), contains("right place!"));

    print('Test Passed: Document added with ID: ${docRef.id}');
  });
}
