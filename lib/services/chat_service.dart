import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat/services/encrypt_service.dart';

import '../models/message.dart';

class ChatService {
  final FirebaseFirestore ff;
  final EncryptService encryptService;

  ChatService({required this.ff, required this.encryptService});

  Stream<QuerySnapshot> getMessageList() {
    return ff
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  void sendMessage(String message, String author) {
    Message chatMessages = Message(
      author: author, // encryptService.encrypt(author),
      timestamp: Timestamp.now(),
      message: message, //encryptService.encrypt(message),
    );

    ff.collection('messages').add(chatMessages.toJson());
  }

  Future<DocumentReference> write({
    required String collectionName,
    required Map<String, dynamic> data,
  }) async {
    return await ff.collection(collectionName).add(data);
  }

  void writeAllData({
    required String collectionName,
    required List<Map<String, dynamic>> listData,
  }) {
    for (var data in listData) {
      ff.collection(collectionName).add(data);
    }
  }

  Stream<QuerySnapshot> readStream({
    required String collectionName,
    String? sortableField,
    bool descending = false,
  }) {
    if (sortableField != null) {
      return ff
          .collection(collectionName)
          .orderBy(sortableField, descending: descending)
          .snapshots();
    }
    return ff.collection(collectionName).snapshots();
  }
}
