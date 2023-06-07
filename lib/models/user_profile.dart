import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  static const collectionName = 'user_profiles';

  String uuid;
  String name;
  String? avatarUrl;

  UserProfile({required this.uuid, required this.name, this.avatarUrl});

  factory UserProfile.fromDocument(DocumentSnapshot ds) => UserProfile(
        uuid: ds.get('uuid'),
        name: ds.get('name'),
        avatarUrl: ds.get('avatarUrl'),
      );

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'name': name,
        'avatarUrl': avatarUrl,
      };
}
