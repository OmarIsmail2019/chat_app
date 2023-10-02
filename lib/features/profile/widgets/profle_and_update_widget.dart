import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/features/layout/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileImageAndUpdateWidget extends StatelessWidget {
  const ProfileImageAndUpdateWidget({
    super.key,
    required this.sizeOf,
    required this.userModel,
    required this.onPressed,
  });

  final Size sizeOf;
  final UserModel userModel;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(
            sizeOf.height * .3,
          ),
          child: CachedNetworkImage(
            width: sizeOf.height * .2,
            height: sizeOf.height * .2,
            fit: BoxFit.fill,
            imageUrl: userModel.image,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: MaterialButton(
            color: Colors.white,
            shape: const CircleBorder(),
            onPressed: onPressed,
            child: const Icon(
              FontAwesomeIcons.pen,
            ),
          ),
        )
      ],
    );
  }
}
