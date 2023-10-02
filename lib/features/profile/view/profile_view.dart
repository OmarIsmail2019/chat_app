import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/features/layout/model/user_model.dart';
import 'package:chat/features/profile/widgets/circle_avatar_of_chose_image.dart';
import 'package:chat/features/profile/widgets/elevated_button_widget.dart';
import 'package:chat/features/profile/widgets/floating_action_button_widget_log_out.dart';
import 'package:chat/features/profile/widgets/text_form_field_widget.dart';
import 'package:chat/utils/api.dart';
import 'package:chat/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends StatefulWidget {
  final UserModel userModel;

  const ProfileView({
    super.key,
    required this.userModel,
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    var sizeOf = MediaQuery.sizeOf(context);
    var formState = GlobalKey<FormState>();
    File? image;
    return GestureDetector(
      // to hide keyboard when tap on anywhere in screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        floatingActionButton: Padding(
          padding: EdgeInsets.all(
            sizeOf.height * .011,
          ),
          child: const FloatingActionButtonLogOutWidget(),
        ),
        appBar: AppBar(
          title: const Text('Profile'),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              FontAwesomeIcons.angleLeft,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: sizeOf.width * .05,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formState,
              child: Column(
                children: [
                  SizedBox(
                    height: sizeOf.height * .03,
                    width: sizeOf.width,
                  ),
                  Stack(
                    children: [
                      // solve show image from gallery or camera

                      image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(
                                sizeOf.height * .3,
                              ),
                              child: Image.file(
                                width: sizeOf.height * .2,
                                height: sizeOf.height * .2,
                                fit: BoxFit.fill,
                                File(image.path),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(
                                sizeOf.height * .3,
                              ),
                              child: CachedNetworkImage(
                                width: sizeOf.height * .2,
                                height: sizeOf.height * .2,
                                fit: BoxFit.fill,
                                imageUrl: widget.userModel.image,
                              ),
                            ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          color: Colors.white,
                          shape: const CircleBorder(),
                          onPressed: () {
                            showModalBottomSheet<void>(
                              elevation: 10,
                              // showDragHandle: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                      MediaQuery.sizeOf(context).height * 0.05),
                                  topRight: Radius.circular(
                                      MediaQuery.sizeOf(context).height * 0.05),
                                ),
                              ),
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.2,
                                  width: MediaQuery.sizeOf(context).width,
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        'Picked profile image',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge!
                                            .copyWith(
                                              fontSize: 24,
                                            ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          CircleAvaterOfChoseImage(
                                            imagePath:
                                                'assets/app_icon/camera.png',
                                            onTap: () async {
                                              // Capture a photo.
                                              final ImagePicker picker =
                                                  ImagePicker();

                                              final XFile? cameraImage =
                                                  await picker.pickImage(
                                                source: ImageSource.camera,
                                              );
                                              if (cameraImage != null) {
                                                log('Image path: ${cameraImage.path}  .... Mime type: ${cameraImage.mimeType}');
                                                setState(() {
                                                  image =
                                                      File(cameraImage.path);
                                                });
                                                APIs.updateProfilePicture(
                                                  image!,
                                                );
                                                Navigator.pop(context);
                                              }
                                            },
                                          ),
                                          CircleAvaterOfChoseImage(
                                            imagePath:
                                                'assets/app_icon/photo.png',
                                            onTap: () async {
                                              final ImagePicker picker =
                                                  ImagePicker();

                                              final XFile? galleryImage =
                                                  await picker.pickImage(
                                                source: ImageSource.gallery,
                                              );
                                              if (galleryImage != null) {
                                                log('Image path: ${galleryImage.path}  .... Mime type: ${galleryImage.mimeType}');
                                                setState(() {
                                                  image =
                                                      File(galleryImage.path);
                                                });
                                                APIs.updateProfilePicture(
                                                  image!,
                                                );
                                                Navigator.pop(context);
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: const Icon(
                            FontAwesomeIcons.pen,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: sizeOf.height * 0.04,
                  ),
                  Text(
                    widget.userModel.email,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 30,
                        ),
                  ),
                  SizedBox(
                    height: sizeOf.height * 0.04,
                  ),
                  DefaultTextFormOfUser(
                    onSaved: (val) => APIs.me.name = val ?? '',
                    validator: (val) {
                      if (val == null && val!.isEmpty) {
                        return 'Required Field';
                      } else {
                        return null;
                      }
                    },
                    initailValue: widget.userModel.name,
                    labelText: 'User Name',
                    prefix: FontAwesomeIcons.faceSmile,
                    sizeOf: sizeOf,
                  ),
                  SizedBox(
                    height: sizeOf.height * 0.02,
                  ),
                  DefaultTextFormOfUser(
                    onSaved: (val) => APIs.me.about = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    initailValue: widget.userModel.about,
                    labelText: 'About',
                    prefix: FontAwesomeIcons.circleInfo,
                    sizeOf: sizeOf,
                  ),
                  SizedBox(
                    height: sizeOf.height * 0.04,
                  ),
                  ElevatedButtonWidget(
                    sizeOf: sizeOf,
                    onPressed: () {
                      if (formState.currentState!.validate()) {
                        formState.currentState!.save();
                        APIs.updateUserData().then((value) {
                          Dialogs.showSnackBar(context, 'Success Update');
                        });
                        log('inside validation state');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
