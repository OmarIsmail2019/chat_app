import 'dart:developer';
import 'dart:io';

import 'package:chat/features/chatting/model/message.dart';
import 'package:chat/features/layout/model/user_model.dart';
import 'package:chat/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class BottonsAndTextFormOfChat extends StatefulWidget {
  const BottonsAndTextFormOfChat({
    super.key,
    required this.userModel,
  });
  final UserModel userModel;

  @override
  State<BottonsAndTextFormOfChat> createState() =>
      _BottonsAndTextFormOfChatState();
}

class _BottonsAndTextFormOfChatState extends State<BottonsAndTextFormOfChat> {
  @override
  Widget build(BuildContext context) {
    final ImagePicker picker = ImagePicker();
    final TextEditingController messageController = TextEditingController();
    // bool isUploaded = false;
    return Row(
      children: [
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: messageController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Type Something.....',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final List<XFile> galleryImage =
                        await picker.pickMultiImage(
                      imageQuality: 70,
                    );
                    for (var i in galleryImage) {
                      log('Image path: ${i.path}  .... Mime type: ${i.mimeType}');
                      await APIs.sendCameraImageChat(
                        widget.userModel,
                        File(i.path),
                      );
                    }
                  },
                  icon: const Icon(FontAwesomeIcons.image),
                ),
                IconButton(
                  onPressed: () async {
                    final XFile? cameraImage = await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 70,
                    );
                    if (cameraImage != null) {
                      log('Image path: ${cameraImage.path}  .... Mime type: ${cameraImage.mimeType}');

                      await APIs.sendCameraImageChat(
                        widget.userModel,
                        File(cameraImage.path),
                      );
                    }
                  },
                  icon: const Icon(FontAwesomeIcons.camera),
                ),
              ],
            ),
          ),
        ),
        MaterialButton(
          color: Colors.green,
          padding: const EdgeInsets.all(10),
          shape: const CircleBorder(),
          onPressed: () {
            if (messageController.text.isNotEmpty) {
              APIs.sendMessage(
                messageController.text,
                widget.userModel,
                Type.text,
              );
              messageController.text = '';
            }
          },
          child: const Center(
            child: Icon(
              FontAwesomeIcons.paperPlane,
              size: 25,
            ),
          ),
        )
      ],
    );
  }
}
