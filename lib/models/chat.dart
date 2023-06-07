import 'package:cloud_firestore/cloud_firestore.dart';

import 'message.dart';

class Chat {
  static const collectionName = 'chats';

  String uuid;
  late List<String> users;
  late List<Message> messages;
  ChatType type;
  String? groupTitle;

  Chat({
    required this.uuid,
    users,
    messages,
    this.type = ChatType.p2p,
    this.groupTitle,
  }) {
    this.users = users ?? [];
    this.messages = messages ?? [];
  }

  factory Chat.fromDocument(DocumentSnapshot ds) => Chat(
        uuid: ds.get('uuid'),
        users: List<String>.from(ds.get('users')),
        type: ChatType.values[ds.get('type')],
        messages: List.from(ds.get('messages'))
            .map((e) => Message(
                author: e['author'],
                timestamp: e['timestamp'],
                message: e['message']))
            .toList(),
        groupTitle: ds.get('groupTitle'),
      );

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'users': users,
        'messages': messages.map((e) => e.toJson()).toList(),
        'type': type.index,
        'groupTitle': groupTitle,
      };

  String get title => type == ChatType.p2p ? 'Chat P2P' : groupTitle!;

  bool get canAddUsers =>
      (type == ChatType.p2p && users.length < 2) || type == ChatType.group;
}

enum ChatType {
  p2p('P2P Chat'),
  group('Group Chat');

  final String label;
  const ChatType(this.label);
}
