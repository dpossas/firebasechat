import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat/core/utils/env.dart';
import 'package:firebase_chat/services/encrypt_service.dart';
import '../../services/chat_service.dart';
import 'components/input_message.dart';
import 'package:flutter/material.dart';

import '../../models/message.dart';
import 'components/message_bubble.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _encrypt = EncryptService(
    encryptKey: Env.encryptKey,
    encryptIV: Env.encryptIV,
  );
  late ChatService _chatService;

  final TextEditingController messageEditingController =
      TextEditingController();
  List<QueryDocumentSnapshot> messageList = [];
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    _chatService = ChatService(
      ff: FirebaseFirestore.instance,
      encryptService: _encrypt,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF36393f),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0XFF23272a),
        elevation: 1,
        title: const Text('My.chat', style: TextStyle(fontSize: 16)),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _chatService.getMessageList(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      messageList = snapshot.data!.docs;

                      if (messageList.isNotEmpty) {
                        return ListView.builder(
                            padding: const EdgeInsets.all(10),
                            itemCount: messageList.length,
                            reverse: true,
                            controller: scrollController,
                            itemBuilder: (context, index) =>
                                _buildItem(index, messageList[index]));
                      } else {
                        return const Center(
                          child: Text(
                            'Sem mensagens',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      );
                    }
                  },
                ),
              ),
              InputMessage(
                messageEditingController: messageEditingController,
                handleSubmit: sendMessage,
              ),
            ],
          )
        ],
      ),
    );
  }

  void sendMessage(String message) {
    if (message.isNotEmpty) {
      messageEditingController.clear();
      _chatService.sendMessage(message.trim(), currentUser(context));
      if (scrollController.hasClients) {
        scrollController.animateTo(0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    }
  }

  currentUser(context) => ModalRoute.of(context)?.settings.arguments as String;

  _buildItem(int index, DocumentSnapshot? documentSnapshot) {
    if (documentSnapshot != null) {
      final chatMessage = Message.fromDocument(documentSnapshot);
      final isMe = _encrypt.decrypt(chatMessage.author) == currentUser(context);

      return MessageBubble(
        chatMessage: chatMessage,
        isMe: isMe,
        encryptService: _encrypt,
      );
    }
  }
}
