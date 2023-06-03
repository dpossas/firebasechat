import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String author;
  String message;
  Timestamp timestamp;

  Message({
    required this.author,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'author': author,
        'message': message,
        'timestamp': timestamp,
      };

  factory Message.fromDocument(DocumentSnapshot ds) {
    String author = ds.get('author');
    String message = ds.get('message');
    Timestamp timestamp = ds.get('timestamp');

    return Message(author: author, message: message, timestamp: timestamp);
  }
}
