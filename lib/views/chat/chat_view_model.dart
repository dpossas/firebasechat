import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../core/utils/env.dart';
import '../../models/chat.dart';
import '../../models/message.dart';
import '../../models/user_profile.dart';
import '../../services/chat_service.dart';
import '../../services/encrypt_service.dart';

class ChatViewModel {
  static final ChatViewModel _instance = ChatViewModel._internal();

  factory ChatViewModel() => _instance;

  ValueNotifier<UserProfile?> currentUser = ValueNotifier(null);
  ValueNotifier<UserProfile?> _anotherUser = ValueNotifier(null);
  ValueNotifier<Chat?> chat = ValueNotifier(null);
  ValueNotifier<String?> chatDRID = ValueNotifier(null);

  final _chatService = ChatService(
    ff: FirebaseFirestore.instance,
    encryptService: EncryptService(
      encryptKey: Env.encryptKey,
      encryptIV: Env.encryptIV,
    ),
  );

  Stream<DocumentSnapshot> messageList() {
    // TODO - Service
    final doc =
        _chatService.ff.collection(Chat.collectionName).doc(chatDRID.value!);
    return doc.snapshots();
  }

  Future<void> initializeP2PChat({
    required UserProfile loggedUser,
    required UserProfile anotherUser,
  }) async {
    currentUser.value = loggedUser;
    _anotherUser.value = anotherUser;
    final existentChat =
        await searchP2PChat(loggedUser: loggedUser, anotherUser: anotherUser);

    if (existentChat != null) {
      chatDRID.value = existentChat.id;

      chat.value = Chat.fromDocument((await _chatService.ff
          .collection(Chat.collectionName)
          .doc(existentChat.id)
          .get()));
    } else {
      currentUser.value = loggedUser;

      chat.value = Chat(
        uuid: const Uuid().v4(),
        type: ChatType.p2p,
        users: [
          currentUser.value!.uuid,
          _anotherUser.value!.uuid,
        ],
      );

      chatDRID.value = (await _chatService.write(
        collectionName: Chat.collectionName,
        data: chat.value!.toJson(),
      ))
          .id;
    }
  }

  Future<QueryDocumentSnapshot?> searchP2PChat({
    required UserProfile loggedUser,
    required UserProfile anotherUser,
  }) async {
    final result = await _chatService.ff
        .collection(Chat.collectionName)
        .where('type', isEqualTo: ChatType.p2p.index)
        .withConverter<Chat>(
            fromFirestore: (snapshot, _) => Chat.fromDocument(snapshot),
            toFirestore: (chat, _) => chat.toJson())
        .get();

    return result.docs.firstWhereOrNull(
      (element) {
        return element.data().users.contains(loggedUser.uuid) &&
            element.data().users.contains(anotherUser.uuid);
      },
    );
  }

  void sendMessage(String message) async {
    chat.value!.messages.add(
      Message(
        author: currentUser.value!.uuid,
        message: message,
        timestamp: Timestamp.fromDate(DateTime.now()),
      ),
    );

    _chatService.ff
        .collection(Chat.collectionName)
        .doc(chatDRID.value)
        .update(chat.value!.toJson());
  }

  String get chatTitle => _anotherUser.value!.name;

  UserProfile getUserById(String userId) {
    return [currentUser.value!, _anotherUser.value!]
        .firstWhere((e) => e.uuid == userId);
  }

  ChatViewModel._internal();

  void reset() {
    currentUser = ValueNotifier(null);
    _anotherUser = ValueNotifier(null);

    chat = ValueNotifier(null);
    chatDRID = ValueNotifier(null);
  }
}
