import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/features/layout/model/user_model.dart';
import 'package:chat/features/profile/view/profile_friend_view.dart';
import 'package:chat/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileImageDialog extends StatelessWidget {
  const ProfileImageDialog({
    super.key,
    required this.userModel,
  });

  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    var sizeOf = MediaQuery.sizeOf(context);
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: SizedBox(
        height: MediaQuery.sizeOf(context).height * .36,
        width: MediaQuery.sizeOf(context).width * 0.4,
        child: Stack(
          children: [
            Positioned(
              top: sizeOf.height * 0.06,
              left: sizeOf.width * 0.07,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  sizeOf.height * 0.2,
                ),
                child: CachedNetworkImage(
                  width: sizeOf.width * .4,
                  fit: BoxFit.contain,
                  imageUrl: userModel.image,
                  errorWidget: (
                    context,
                    url,
                    error,
                  ) =>
                      const CircleAvatar(
                    child: Icon(
                      Icons.person,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: MediaQuery.sizeOf(context).width * 0.04,
              top: MediaQuery.sizeOf(context).height * 0.013,
              width: MediaQuery.sizeOf(context).width * 0.55,
              child: Text(
                userModel.name,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontSize: 20,
                      color: kTextColor,
                    ),
              ),
            ),
            Positioned(
              right: 8,
              child: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatProfileView(
                              userModel: userModel,
                            )),
                  );
                },
                icon: const Icon(
                  FontAwesomeIcons.circleInfo,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
