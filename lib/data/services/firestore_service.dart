import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> collection(String path) =>
      _db.collection(path);

  FieldValue get serverTimestamp => FieldValue.serverTimestamp();

  Map<String, dynamic> _withServerTimestamps(
    Map<String, dynamic> data, {
    bool setCreatedAt = false,
  }) {
    final copy = Map<String, dynamic>.from(data);
    copy['updatedAt'] = serverTimestamp;
    if (setCreatedAt) copy['createdAt'] = serverTimestamp;
    return copy;
  }

  Future<DocumentReference<Map<String, dynamic>>> add(
    String collectionPath,
    Map<String, dynamic> data, {
    bool setCreatedAt = true,
  }) {
    return collection(
      collectionPath,
    ).add(_withServerTimestamps(data, setCreatedAt: setCreatedAt));
  }
}
