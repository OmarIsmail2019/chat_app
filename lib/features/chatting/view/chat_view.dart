import 'package:chat/features/chatting/model/message.dart';
import 'package:chat/features/chatting/widgets/app_bar_of_chat.dart';
import 'package:chat/features/chatting/widgets/buttons_and_text_form_chat.dart';
import 'package:chat/features/chatting/widgets/messages_card.dart';
import 'package:chat/features/layout/model/user_model.dart';
import 'package:chat/utils/api.dart';
import 'package:flutter/material.dart';

class ChatView extends StatefulWidget {
  const ChatView({
    super.key,
    required this.userModel,
  });
  final UserModel userModel;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    List<MessageModel> messageList = [];
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: AppBarItems(
              userModel: widget.userModel,
              context: context,
            ),
            automaticallyImplyLeading: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                      stream: APIs.getAllMessages(widget.userModel),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return const Center(
                                child: CircularProgressIndicator());

                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;
                            messageList = data
                                    ?.map(
                                        (e) => MessageModel.fromJson(e.data()))
                                    .toList() ??
                                [];
                        }

                        if (messageList.isNotEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: ListView.builder(
                              reverse: true,
                              itemCount: messageList.length,
                              itemBuilder: (context, index) {
                                return MessageCard(
                                  messgaeModel: messageList[index],
                                );
                              },
                            ),
                          );
                        } else {
                          return Center(
                            child: Text(
                              'Say Hello 👋​',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          );
                        }
                      }),
                ),
                BottonsAndTextFormOfChat(
                  userModel: widget.userModel,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
