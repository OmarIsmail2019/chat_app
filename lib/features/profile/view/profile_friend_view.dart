import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/features/layout/model/user_model.dart';
import 'package:chat/utils/colors.dart';
import 'package:chat/utils/format_date.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatProfileView extends StatefulWidget {
  final UserModel userModel;

  const ChatProfileView({
    super.key,
    required this.userModel,
  });

  @override
  State<ChatProfileView> createState() => _ChatProfileViewState();
}

class _ChatProfileViewState extends State<ChatProfileView> {
  @override
  Widget build(BuildContext context) {
    var sizeOf = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.userModel.name),
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
            horizontal: sizeOf.width * .03,
          ),
          child: Column(
            children: [
              SizedBox(
                height: sizeOf.height * .03,
                width: sizeOf.width,
              ),
              ClipRRect(
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
              SizedBox(
                height: sizeOf.height * 0.04,
              ),
              Text(
                widget.userModel.email,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 20,
                      color: kTextColor,
                    ),
              ),
              SizedBox(
                height: sizeOf.height * 0.04,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'About : ',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: kTextColor,
                          fontSize: 15,
                        ),
                  ),
                  Text(
                    widget.userModel.about,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Join : ',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: kTextColor,
                          fontSize: 15,
                        ),
                  ),
                  Text(
                    FormatDate.getLastMessageTime(
                      context: context,
                      time: widget.userModel.createdAt,
                      showYear: true,
                    ),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
