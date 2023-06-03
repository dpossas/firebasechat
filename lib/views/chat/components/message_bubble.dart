import 'package:flutter/material.dart';

import '../../../models/message.dart';
import '../../../services/encrypt_service.dart';
import 'message_timestamp.dart';

class MessageBubble extends StatelessWidget {
  final Message chatMessage;
  final bool isMe;
  final EncryptService encryptService;

  const MessageBubble({
    Key? key,
    required this.chatMessage,
    required this.isMe,
    required this.encryptService,
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
                    encryptService.decrypt(chatMessage.author),
                    style: const TextStyle(fontSize: 13, color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    encryptService.decrypt(chatMessage.message),
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
