import 'package:flutter/material.dart';

import '../../../models/message.dart';
import '../../../models/user_profile.dart';
import '../../../services/encrypt_service.dart';
import 'message_timestamp.dart';

class MessageBubble extends StatelessWidget {
  final Message chatMessage;
  final bool isMe;
  final EncryptService encryptService;
  final UserProfile author;

  const MessageBubble({
    Key? key,
    required this.chatMessage,
    required this.isMe,
    required this.encryptService,
    required this.author,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              margin: isMe
                  ? const EdgeInsets.only(right: 10)
                  : const EdgeInsets.only(left: 10),
              width: 200,
              decoration: BoxDecoration(
                color: isMe ? Colors.green : Colors.black12,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    author.name, //encryptService.decrypt(chatMessage.author),
                    style: const TextStyle(fontSize: 13, color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    chatMessage
                        .message, //encryptService.decrypt(chatMessage.message),
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
        MessageTimestampWidget(timestamp: chatMessage.timestamp),
      ],
    );
  }
}
