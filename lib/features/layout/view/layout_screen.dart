import 'dart:developer';

import 'package:chat/features/layout/model/user_model.dart';
import 'package:chat/features/layout/widgets/user_card_message.dart';
import 'package:chat/features/profile/view/profile_view.dart';
import 'package:chat/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LayOutScreen extends StatefulWidget {
  const LayOutScreen({super.key});

  @override
  State<LayOutScreen> createState() => _LayOutScreenState();
}

class _LayOutScreenState extends State<LayOutScreen> {
  // for storing users
  List<UserModel> list = [];

  // for storing search items
  final List<UserModel> search = [];

  //for storing search status

  bool isSearch = false;
  @override
  void initState() {
    super.initState();
    APIs.getSellInfo();
    APIs.getLastActivityStatus(true);
    SystemChannels.lifecycle.setMessageHandler((message) {
      log("Message : $message");
      if (message.toString().contains('resume')) {
        APIs.getLastActivityStatus(true);
      }
      if (message.toString().contains('pause')) {
        APIs.getLastActivityStatus(false);
      }
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // hide keyboard when the user clicks on the screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          // if search is on & back button is pressed then closed search
          if (isSearch) {
            setState(() {
              isSearch = !isSearch;
            });
            return Future.value(false);
          }
          // else simply close current screen on back button click
          else {
            return Future.value(false);
          }
        },
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.purple,
            onPressed: () {},
            child: const Icon(
              FontAwesomeIcons.commentDots,
            ),
          ),
          appBar: AppBar(
            leading: const Icon(
              FontAwesomeIcons.house,
            ),
            title: isSearch
                ? TextField(
                    autofocus: true,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 20,
                        ),
                    onChanged: (val) {
                      search.clear();
                      for (var i in list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                            i.name.toUpperCase().contains(val.toUpperCase())) {
                          search.add(i);
                        }
                        setState(() {
                          search;
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: 'Name , Email ,......',
                    ),
                  )
                : const Text('Chat'),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    isSearch = !isSearch;
                  });
                },
                icon: Icon(
                  isSearch
                      ? FontAwesomeIcons.xmark
                      : FontAwesomeIcons.magnifyingGlass,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileView(
                        userModel: APIs.me,
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  FontAwesomeIcons.bars,
                ),
              ),
            ],
          ),
          body: StreamBuilder(
              stream: APIs.getAllUser(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());

                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    list = data
                            ?.map((e) => UserModel.fromJson(e.data()))
                            .toList() ??
                        [];
                }
                if (list.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ListView.builder(
                      itemCount: isSearch ? search.length : list.length,
                      itemBuilder: (context, index) {
                        return UserCardMessageWidget(
                          userModel: isSearch ? search[index] : list[index],
                        );
                      },
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      isSearch ? 'Find you want' : 'Create new chat',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }
}
