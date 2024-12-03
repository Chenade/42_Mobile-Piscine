import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseDiaryService {
  // static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final CollectionReference _diaryCollection =
      FirebaseFirestore.instance.collection('diary');

  static Stream<QuerySnapshot> getDiaryEntries() {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Stream.empty();
    }
    return _diaryCollection
        .where('user_email', isEqualTo: currentUser.email)
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  static Future<void> createDiaryEntry(
      String title, String content, String feeling) async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (title.isEmpty || content.isEmpty || currentUser == null) {
      return;
    }
    try {
      await _diaryCollection.add({
        'title': title,
        'content': content,
        'feeling': feeling,
        'created_at': Timestamp.now(),
        'user_email': currentUser.email,
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<void> deleteDiaryEntry(String id) async {
    try {
      await _diaryCollection.doc(id).delete();
    } catch (e) {
      print(e);
    }
  }

  static Future<void> updateDiaryEntry(
      String id, String title, String content, String feeling) async {
    try {
      await _diaryCollection.doc(id).update({
        'title': title,
        'content': content,
        'feeling': feeling,
      });
    } catch (e) {
      print(e);
    }
  }
}
