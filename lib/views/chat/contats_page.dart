import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat/models/user_profile.dart';
import 'package:firebase_chat/views/chat/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../core/utils/env.dart';
import '../../services/chat_service.dart';
import '../../services/encrypt_service.dart';

class ContactsPage extends StatefulWidget {
  static const path = '/contacts-page';

  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final _chatViewModel = ChatViewModel();
  final _encrypt = EncryptService(
    encryptKey: Env.encryptKey,
    encryptIV: Env.encryptIV,
  );
  late ChatService _chatService;

  @override
  void initState() {
    super.initState();

    _chatService = ChatService(
      ff: FirebaseFirestore.instance,
      encryptService: _encrypt,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = UserProfile(
      uuid: const Uuid().v4(),
      name: currentUser(context).name,
    );

    _chatService.write(
      collectionName: UserProfile.collectionName,
      data: userProfile.toJson(),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0XFF23272a),
        elevation: 1,
        title: const Text('Contact list', style: TextStyle(fontSize: 16)),
      ),
      body: Column(children: [
        Flexible(
          child: StreamBuilder(
            stream: _chatService.readStream(
              collectionName: UserProfile.collectionName,
              sortableField: 'name',
            ),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final contactList = snapshot.data!.docs;

                if (contactList.isNotEmpty) {
                  return ListView.builder(
                    itemCount: contactList.length,
                    itemBuilder: (context, index) {
                      final contact =
                          UserProfile.fromDocument(contactList[index]);

                      return ListTile(
                        title: Text(contact.name),
                        subtitle: Text(contact.uuid),
                        onTap: () async {
                          await _chatViewModel.initializeP2PChat(
                            loggedUser: (ModalRoute.of(context)
                                ?.settings
                                .arguments as UserProfile),
                            anotherUser: contact,
                          );

                          Navigator.pushNamed(
                            context,
                            '/chat',
                          );
                        },
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text(
                      'Sem contatos',
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
      ]),
    );
  }

  UserProfile currentUser(context) =>
      ModalRoute.of(context)?.settings.arguments as UserProfile;
}
