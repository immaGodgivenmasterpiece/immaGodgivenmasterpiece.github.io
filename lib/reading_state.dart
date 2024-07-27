import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReadingState extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, bool> _readStatus = {};

  Map<String, bool> get readStatus => _readStatus;

  ReadingState() {
    _loadReadStatus();
  }

  void _loadReadStatus() {
    _firestore.collection('readStatus').snapshots().listen((snapshot) {
      _readStatus = Map.fromEntries(snapshot.docs
          .map((doc) => MapEntry(doc.id, doc.data()['isRead'] ?? false)));
      notifyListeners();
    });
  }

  void markAsRead(String tileId) {
    _firestore.collection('readStatus').doc(tileId).set({'isRead': true});
  }

  void markAsUnread(String tileId) {
    _firestore.collection('readStatus').doc(tileId).set({'isRead': false});
  }

  int getNextUnreadTileIndex() {
    List<MapEntry<String, bool>> sortedEntries = _readStatus.entries.toList()
      ..sort((a, b) => int.parse(a.key.split('_')[1])
          .compareTo(int.parse(b.key.split('_')[1])));

    int lastReadIndex = -1;
    for (int i = 0; i < sortedEntries.length; i++) {
      if (sortedEntries[i].value) {
        lastReadIndex = i;
      } else if (lastReadIndex != -1) {
        return i;
      }
    }
    return lastReadIndex == -1 ? 0 : -1; // 모든 타일이 읽혔으면 -1, 아니면 첫 번째 안 읽은 타일
  }
}
