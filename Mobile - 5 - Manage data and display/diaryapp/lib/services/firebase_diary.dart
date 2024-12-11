import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseDiaryService {
  // static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final CollectionReference _diaryCollection =
      FirebaseFirestore.instance.collection('diary');

  static Stream<QuerySnapshot> getDairyCount() {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Stream.empty();
    }
    
    return _diaryCollection
        .where('user_email', isEqualTo: currentUser.email)
        .snapshots();
  }

  static Stream<QuerySnapshot> getAllDiaryEntries() {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Stream.empty();
    }
    return _diaryCollection
        .where('user_email', isEqualTo: currentUser.email)
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot> getDiaryTwoEntries() {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Stream.empty();
    }
    return _diaryCollection
        .where('user_email', isEqualTo: currentUser.email)
        .orderBy('created_at', descending: true)
        .limit(2)
        .snapshots();
  }

  static Stream<QuerySnapshot> getDiaryEntriesByDate(DateTime date) {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Stream.empty();
    }
    DateTime startOfDayUtc = DateTime(date.year, date.month, date.day).toUtc();
    DateTime endOfDayUtc = startOfDayUtc.add(const Duration(days: 1));

    return _diaryCollection
        .where('user_email', isEqualTo: currentUser.email)
        .where(
          'created_at',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDayUtc),
          isLessThan: Timestamp.fromDate(endOfDayUtc),
        )
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
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }
    try {
      await _diaryCollection.doc(id).delete();
    } catch (e) {
      print(e);
    }
  }

  static Future<void> updateDiaryEntry(
      String id, String title, String content, String feeling) async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }
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
