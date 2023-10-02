import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/features/chatting/model/message.dart';
import 'package:chat/utils/api.dart';
import 'package:chat/utils/colors.dart';
import 'package:chat/utils/format_date.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({
    super.key,
    required this.messgaeModel,
  });
  final MessageModel messgaeModel;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.messgaeModel.fromId
        ? Directionality(
            textDirection: TextDirection.rtl,
            child: _sendMessgae(),
          )
        : Directionality(
            textDirection: TextDirection.ltr,
            child: _reciveMessgae(),
          );
  }

  Widget _reciveMessgae() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(
              widget.messgaeModel.type == Type.image
                  ? MediaQuery.sizeOf(context).width * 0.02
                  : MediaQuery.sizeOf(context).width * 0.04,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * 0.04,
              vertical: MediaQuery.sizeOf(context).width * 0.01,
            ),
            decoration: BoxDecoration(
              color: widget.messgaeModel.type == Type.image
                  ? Colors.white
                  : const Color.fromARGB(255, 179, 214, 247),
              border: Border.all(
                color: widget.messgaeModel.type == Type.image
                    ? Colors.grey
                    : const Color.fromARGB(255, 48, 85, 102),
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: widget.messgaeModel.type == Type.text
                ? Text(
                    widget.messgaeModel.msg,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: kTextColor,
                          fontSize: 18,
                        ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: CachedNetworkImage(
                      imageUrl: widget.messgaeModel.msg,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const CircleAvatar(
                        child: Icon(
                          FontAwesomeIcons.circleInfo,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
        Text(
          FormatDate.getFormatDate(
            context: context,
            time: widget.messgaeModel.sent,
          ),
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: kTextColor,
                fontSize: 13,
              ),
        ),
      ],
    );
  }

  Widget _sendMessgae() {
    if (widget.messgaeModel.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.messgaeModel);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(
              widget.messgaeModel.type == Type.image
                  ? MediaQuery.sizeOf(context).width * 0.02
                  : MediaQuery.sizeOf(context).width * 0.04,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * 0.04,
              vertical: MediaQuery.sizeOf(context).width * 0.01,
            ),
            decoration: BoxDecoration(
              color: widget.messgaeModel.type == Type.image
                  ? Colors.white
                  : const Color.fromARGB(
                      255,
                      152,
                      108,
                      228,
                    ),
              border: Border.all(
                color: widget.messgaeModel.type == Type.text
                    ? const Color.fromARGB(255, 137, 82, 146)
                    : Colors.grey,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: widget.messgaeModel.type == Type.text
                ? Text(
                    widget.messgaeModel.msg,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: kTextColor,
                          fontSize: 18,
                        ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: CachedNetworkImage(
                      imageUrl: widget.messgaeModel.msg,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const CircleAvatar(
                        child: Icon(
                          FontAwesomeIcons.circleInfo,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
        Row(
          children: [
            Text(
              FormatDate.getFormatDate(
                context: context,
                time: widget.messgaeModel.sent,
              ),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: kTextColor,
                    fontSize: 13,
                  ),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.04,
            ),
            if (widget.messgaeModel.read.isNotEmpty)
              const Icon(
                FontAwesomeIcons.checkDouble,
                color: Colors.blue,
              ),
          ],
        ),
      ],
    );
  }
}
