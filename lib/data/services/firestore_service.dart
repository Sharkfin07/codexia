import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> collection(String path) =>
      _db.collection(path);

  DocumentReference<Map<String, dynamic>> doc(String path) => _db.doc(path);

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

  // * Add Functionality
  Future<DocumentReference<Map<String, dynamic>>> add(
    String collectionPath,
    Map<String, dynamic> data, {
    bool setCreatedAt = true,
  }) {
    return collection(
      collectionPath,
    ).add(_withServerTimestamps(data, setCreatedAt: setCreatedAt));
  }

  // * Set Functionality
  Future<void> set(
    String docPath,
    Map<String, dynamic> data, {
    bool merge = false,
    bool setCreatedAt = false,
  }) {
    return doc(docPath).set(
      _withServerTimestamps(data, setCreatedAt: setCreatedAt),
      SetOptions(merge: merge),
    );
  }
}
