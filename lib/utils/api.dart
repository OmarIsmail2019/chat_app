import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chat/features/chatting/model/message.dart';
import 'package:chat/features/layout/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  static FirebaseStorage fireStorage = FirebaseStorage.instance;
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  static get user => auth.currentUser!;

  static late UserModel me;

//check if user is existing or not
  static Future<bool> userExist() async {
    return (await fireStore.collection('users').doc(user.uid).get()).exists;
  }

// function get message token

  static Future<void> getMessageToken() async {
    await fMessaging.requestPermission();
    await fMessaging.getToken().then(
      (token) {
        if (token != null) {
          me.pushToken = token;
          log("Token Message: $token");
        }
      },
    );
    // for handling foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('MessageData :${message.data}');
      if (message.notification != null) {
        log('Message also contained a notification ${message.notification}');
      }
    });
  }

  // send notification
  static Future<void> sendNotificationMessage(
    UserModel model,
    String msg,
  ) async {
    try {
      final body = {
        "to": model.pushToken,
        "notification": {
          "title": model.name,
          "body": msg,
          "android_channel_id": "chats",
        },
        "data": {
          "click_action": "User ID : ${me.id}",
        },
      };
      var response = await post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'key=AAAAM-6CoYc:APA91bE-pXAtz0TQBnv3LRtm8qCz8a94ovgPinHTVx8TPPE23ThoYfimeAkWFwo6RA8Lj3U8TVUUu4cuKjrSZvqwk1l2o4Jm_ek0GdT_7cyrhPpQq36XmohTKFu1ZyzTMPgTOGLiuhqw',
        },
        body: jsonEncode(body),
      );
      log("Response Status: ${response.statusCode}");
    } catch (e) {
      log("\nsendNotificationError $e");
    }
  }
  // for getting current user information

  static Future<void> getSellInfo() async {
    return await fireStore
        .collection('users')
        .doc(user.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me = UserModel.fromJson(user.data()!);
        await getMessageToken();
        log('My Data: ${user.data()}');
        APIs.getLastActivityStatus(true);
      } else {
        await createUser().then((value) => getSellInfo());
      }
    });
  }

  static Future<void> createUser() async {
    final time = DateTime.now().toString();
    final userModel = UserModel(
      name: user.displayName.toString(),
      about: 'It is about me',
      email: user.email.toString(),
      id: user.uid,
      image: user.photoURL.toString(),
      createdAt: time,
      pushToken: '',
      isOnline: false,
      lastActive: time,
    );
    return await fireStore.collection('users').doc(user.uid).set(
          userModel.toJson(),
        );
  }

//get all users form firestore
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
    return APIs.fireStore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

//get user information from firestore
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      UserModel userModel) {
    return APIs.fireStore
        .collection('users')
        .where('id', isEqualTo: userModel.id)
        .snapshots();
  }

  // function to get last activity status of user
  static Future<void> getLastActivityStatus(bool isOnline) async {
    fireStore.collection('users').doc(user.uid).update({
      'isOnline': isOnline,
      'lastActive': DateTime.now().millisecondsSinceEpoch.toString(),
      'pushToken': me.pushToken,
    });
  }

// function to update a user data

  static Future<void> updateUserData() async {
    await fireStore.collection('users').doc(user.uid).update({
      'name': me.name,
      'about': me.about,
    });
  }

  static Future<void> updateProfilePicture(file) async {
    final ext = file.path.split('.').last;
    final ref = fireStorage.ref().child('profilePicture/${user.uid}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transeferred : ${p0.bytesTransferred / 1000} kb');
    });
    me.image = await ref.getDownloadURL();
    await fireStore.collection('users').doc(user.uid).update({
      'image': me.image,
    });
  }

  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';
// get all messgaes from firebase
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      UserModel userModel) {
    return APIs.fireStore
        .collection('chats/${getConversationID(userModel.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(
      String msg, UserModel userModel, Type type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final MessageModel messageModel = MessageModel(
        fromId: user.uid,
        type: type,
        read: '',
        msg: msg,
        toId: userModel.id,
        sent: time);
    final ref = fireStore
        .collection('chats/${getConversationID(userModel.id)}/messages/');

    await ref.doc(time).set(messageModel.toJson()).then(
          (value) => sendNotificationMessage(
            userModel,
            type == Type.text ? msg : 'image',
          ),
        );
  }

// function to update state of message read or not
  static Future<void> updateMessageReadStatus(MessageModel messageModel) async {
    fireStore
        .collection('chats/${getConversationID(messageModel.fromId)}/messages/')
        .doc(messageModel.sent)
        .update({
      'read': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  // function to get last meesage in list of messages

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMeesage(
      UserModel model) {
    return fireStore
        .collection('chats/${getConversationID(model.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  // function send camera image as message

  static Future<void> sendCameraImageChat(UserModel userModel, file) async {
    final ext = file.path.split('.').last;
    final ref = fireStorage.ref().child(
        'images/${getConversationID(userModel.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transeferred : ${p0.bytesTransferred / 1000} kb');
    });
    final image = await ref.getDownloadURL();
    await sendMessage(image, userModel, Type.image);
  }

  // function send camera image as message

  // static Future<void> sendGalleryImageChat(
  //     UserModel userModel, File file) async {
  //   final ext = file.path.split('.').last;
  //   final ref = fireStorage.ref().child(
  //       'images/${getConversationID(userModel.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
  //   await ref
  //       .putFile(file, SettableMetadata(contentType: 'image/$ext'))
  //       .then((p0) {
  //     log('Data Transeferred : ${p0.bytesTransferred / 1000} kb');
  //   });
  //   final image = await ref.getDownloadURL();
  //   await sendMessage(image, userModel, Type.image);
  // }
}
