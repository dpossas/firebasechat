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
      author: encryptService.encrypt(author),
      timestamp: Timestamp.now(),
      message: encryptService.encrypt(message),
    );

    ff.collection('messages').add(chatMessages.toJson());
  }
}
