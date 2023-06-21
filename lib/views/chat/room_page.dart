import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat/models/user_profile.dart';
import 'package:firebase_chat/views/chat/chat_view_model.dart';
import 'package:firebase_chat/views/chat/contats_page.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../core/utils/env.dart';
import '../../services/chat_service.dart';
import '../../services/encrypt_service.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({super.key});

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  final _chatViewModel = ChatViewModel();

  final TextEditingController _nicknameEditingController =
      TextEditingController();

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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0XFF23272a),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Seu nickname é...',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 12),
                _nicknameInput(),
                const SizedBox(height: 12),
                _enterButton(context),
                // _populateDatabaseButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _nicknameInput() {
    return TextFormField(
      textInputAction: TextInputAction.done,
      controller: _nicknameEditingController,
      onChanged: (value) {},
      cursorColor: const Color(0xff9b84ec),
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: EdgeInsets.all(20.0),
        filled: true,
        fillColor: Color(0xff2f3136),
        labelText: 'Nickname',
        suffixText: 'Nickname',
        hintStyle: TextStyle(color: Colors.white54),
        labelStyle: TextStyle(color: Colors.white54),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black26),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff9b84ec), width: 1),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 5),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          gapPadding: 8.0,
        ),
      ),
    );
  }

  Widget _enterButton(context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                ContactsPage.path,
                arguments: UserProfile(
                  uuid: '1234567890',
                  name: _nicknameEditingController.text,
                ),
              );
              _nicknameEditingController.clear();
            },
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              primary: const Color(0xff9b84ec),
            ),
            child: const Text('Entrar'),
          ),
        ),
      ],
    );
  }

  Widget _populateDatabaseButton(context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              primary: const Color(0xff9b84ec),
            ),
            child: const Text('Populate database'),
          ),
        ),
      ],
    );
  }

  final List<UserProfile> _userProfiles = List.generate(100, (index) {
    return UserProfile(uuid: const Uuid().v4(), name: 'User $index');
  });

  void _populateUserProfiles() {
    _chatService.writeAllData(
        collectionName: UserProfile.collectionName,
        listData: _userProfiles.map((e) => e.toJson()).toList());
  }
}
