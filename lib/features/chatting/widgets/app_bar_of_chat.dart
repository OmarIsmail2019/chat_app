import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/features/layout/model/user_model.dart';
import 'package:chat/features/profile/view/profile_friend_view.dart';
import 'package:chat/utils/api.dart';
import 'package:chat/utils/format_date.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppBarItems extends StatelessWidget {
  const AppBarItems({
    super.key,
    required this.userModel,
    required this.context,
  });

  final UserModel userModel;
  final BuildContext context;

  @override
  Widget build(BuildContext context) => StreamBuilder(
      stream: APIs.getUserInfo(userModel),
      builder: (context, snapshot) {
        final data = snapshot.data?.docs;
        final list = data?.map((e) => UserModel.fromJson(e.data())).toList();
        return GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ChatProfileView(
                  userModel: userModel,
                ),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  FontAwesomeIcons.angleLeft,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: CachedNetworkImage(
                  width: MediaQuery.sizeOf(context).height * 0.05,
                  height: MediaQuery.sizeOf(context).height * 0.05,
                  imageUrl: list!.isNotEmpty ? list[0].image : userModel.image,
                  errorWidget: (context, url, error) => const CircleAvatar(
                    child: Icon(
                      FontAwesomeIcons.circleInfo,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    list.isNotEmpty ? list[0].name : userModel.name,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontSize: 25,
                        ),
                  ),
                  Text(
                    list.isNotEmpty
                        ? list[0].isOnline
                            ? "Online"
                            : FormatDate.getLastActiveTime(
                                context: context,
                                lastActiveTime: list[0].lastActive,
                              )
                        : FormatDate.getLastActiveTime(
                            context: context,
                            lastActiveTime: userModel.lastActive,
                          ),
                    style: Theme.of(context).textTheme.labelLarge,
                  )
                ],
              )
            ],
          ),
        );
      });
}
