import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../core/utils/env.dart';
import '../../models/chat.dart';
import '../../models/message.dart';
import '../../models/user_profile.dart';
import '../../services/chat_service.dart';
import '../../services/encrypt_service.dart';
import 'chat_view_model.dart';
import 'components/input_message.dart';
import 'components/message_bubble.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _chatViewModel = ChatViewModel();

  final _encrypt = EncryptService(
    encryptKey: Env.encryptKey,
    encryptIV: Env.encryptIV,
  );
  late ChatService _chatService;

  final TextEditingController messageEditingController =
      TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _chatService = ChatService(
      ff: FirebaseFirestore.instance,
      encryptService: _encrypt,
    );
  }

  @override
  void dispose() {
    _chatViewModel.reset();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF36393f),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0XFF23272a),
        elevation: 1,
        title: Text(
          _chatViewModel.chatTitle,
          style: const TextStyle(fontSize: 16),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Flexible(
                child: StreamBuilder<DocumentSnapshot>(
                  stream: _chatViewModel.messageList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final chat = Chat.fromDocument(snapshot.requireData);
                      final messageList = chat.messages;
                      messageList
                          .sort((a, b) => b.timestamp.compareTo(a.timestamp));

                      if (messageList.isNotEmpty) {
                        return ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: messageList.length,
                          reverse: true,
                          controller: scrollController,
                          itemBuilder: (context, index) =>
                              _buildItem(messageList[index]),
                        );
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

      _chatViewModel.sendMessage(message);

      if (scrollController.hasClients) {
        scrollController.animateTo(0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    }
  }

  _buildItem(Message message) {
    final isMe = message.author == _chatViewModel.currentUser.value!.uuid;

    return MessageBubble(
      chatMessage: message,
      isMe: isMe,
      encryptService: _encrypt,
      author: _chatViewModel.getUserById(message.author),
    );
  }
}
