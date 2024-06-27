import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ride_share/models/message.dart';

class ChatService {
  // get instace of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user stream
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // go through each individual user
        final user = doc.data();

        return user;
      }).toList();
    });
  }

  // send message
  Future<void> SendMessage(String receiverId, message) async {
    // get current user info
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email ?? "None";
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    // construct chat room ID
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');

    // Add message to Firestore
    DocumentReference chatRoomRef =
        _firestore.collection("chat_rooms").doc(chatRoomId);

    // Use a transaction to ensure atomicity
    await _firestore.runTransaction((transaction) async {
      // Check if the chat room document exists
      DocumentSnapshot chatRoomSnapshot = await transaction.get(chatRoomRef);
      if (!chatRoomSnapshot.exists) {
        // If the chat room does not exist, create it with the members field
        transaction.set(chatRoomRef, {
          'members': ids,
        });
      }

      // Add the new message to the messages subcollection
      transaction.set(
        chatRoomRef.collection("messages").doc(),
        newMessage.toMap(),
      );
    });

    // // add message to db
    // await _firestore
    //     .collection("chat_rooms")
    //     .doc(chatRoomId)
    //     .collection("messages")
    //     .add(newMessage.toMap());
  }

  // get message
  Stream<QuerySnapshot> getMessages(String userId, otherUserId) {
    // const chatroom
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection("messages")
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Get users who have sent messages to the current user as a stream
  Stream<List<Map<String, dynamic>>> getUsersWithMessagesToCurrentUser() {
    final String currentUserId = _auth.currentUser!.uid;

    // Stream to listen to chat rooms where the current user is a member
    Stream<QuerySnapshot> chatRoomsStream = _firestore
        .collection("chat_rooms")
        .where('members', arrayContains: currentUserId)
        .snapshots();

    // Transform the chat rooms stream to user data stream
    return chatRoomsStream.asyncMap((chatRoomsSnapshot) async {
      // Map to store senderId and their latest message timestamp
      Map<String, Timestamp> senderTimestampMap = {};

      for (var chatRoom in chatRoomsSnapshot.docs) {
        String chatRoomId = chatRoom.id;
        List<String> members = chatRoomId.split('_');
        String senderId = members.firstWhere((id) => id != currentUserId);

        // Get the latest message in this chat room
        QuerySnapshot latestMessageSnapshot = await _firestore
            .collection("chat_rooms")
            .doc(chatRoomId)
            .collection("messages")
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (latestMessageSnapshot.docs.isNotEmpty) {
          Timestamp latestTimestamp =
              latestMessageSnapshot.docs.first.get('timestamp');
          senderTimestampMap[senderId] = latestTimestamp;
        }
      }

      // Sort sender IDs by the latest message timestamp in descending order
      List<String> sortedSenderIds = senderTimestampMap.keys.toList()
        ..sort(
            (a, b) => senderTimestampMap[b]!.compareTo(senderTimestampMap[a]!));

      // Fetch user details based on the sorted sender IDs
      List<Map<String, dynamic>> users = [];
      for (String senderId in sortedSenderIds) {
        DocumentSnapshot userDoc =
            await _firestore.collection("Users").doc(senderId).get();
        if (userDoc.exists) {
          users.add(userDoc.data() as Map<String, dynamic>);
        }
      }

      return users;
    });
  }
}
