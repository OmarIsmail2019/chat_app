import 'package:chat/features/chatting/model/message.dart';
import 'package:chat/features/chatting/view/chat_view.dart';
import 'package:chat/features/layout/model/user_model.dart';
import 'package:chat/features/layout/widgets/profile_image_dialog.dart';
import 'package:chat/utils/api.dart';
import 'package:chat/utils/colors.dart';
import 'package:chat/utils/format_date.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserCardMessageWidget extends StatefulWidget {
  const UserCardMessageWidget({
    super.key,
    required this.userModel,
  });

  final UserModel userModel;

  @override
  State<UserCardMessageWidget> createState() => _UserCardMessageWidgetState();
}

class _UserCardMessageWidgetState extends State<UserCardMessageWidget> {
  @override
  Widget build(BuildContext context) {
    MessageModel? message;
    return Card(
      shadowColor: kShadowColor,
      elevation: 7,
      semanticContainer: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatView(
                userModel: widget.userModel,
              ),
            ),
          );
        },
        child: StreamBuilder(
            stream: APIs.getLastMeesage(widget.userModel),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => MessageModel.fromJson(e.data())).toList() ??
                      [];
              if (list.isNotEmpty) message = list[0];
              return ListTile(
                title: Text(
                  widget.userModel.name,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontSize: 24,
                      ),
                ),
                subtitle: Text(
                  message != null
                      ? message!.type == Type.image
                          ? 'image'
                          : message!.msg
                      : widget.userModel.about,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 18,
                        color: Colors.grey.shade500,
                      ),
                ),
                trailing: message == null
                    ? null
                    : message!.read.isEmpty && message!.fromId != APIs.user.uid
                        ? const CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: 8,
                          )
                        : Text(
                            FormatDate.getLastMessageTime(
                              context: context,
                              time: message!.sent,
                            ),
                          ),
                leading: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: ((context) => ProfileImageDialog(
                            userModel: widget.userModel,
                          )),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      MediaQuery.sizeOf(context).height * .03,
                    ),
                    child: CachedNetworkImage(
                      width: MediaQuery.sizeOf(context).height * .055,
                      height: MediaQuery.sizeOf(context).height * .055,
                      imageUrl: widget.userModel.image,
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
              );
            }),
      ),
    );
  }
}
