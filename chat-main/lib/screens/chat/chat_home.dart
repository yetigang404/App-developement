import 'dart:async';

import 'package:chat/models/user.dart';
import 'package:chat/screens/chat/create_chat.dart';
import 'package:chat/screens/settings.dart';
import 'package:chat/services/user_service.dart';
import 'package:chat/widgets/chat/chat_list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:chat/screens/chat/chat_search.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  List<String>? chats;
  late StreamSubscription _userSubscription;
  int _page = 0;

  _ChatHomeScreenState() {
    var user = UserService.getInstance().getCurrentUser();
    _subscribeToUserStream();
    _loadData();
    if (user != null) {
      chats = user.chats;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _userSubscription.cancel();
  }

  void _loadData() async {
    User? user =
        await User.fromReference(auth.FirebaseAuth.instance.currentUser!.uid);
    if (user != null) {
      setState(() {
        chats = user.chats;
      });
    }
  }

  void _subscribeToUserStream() {
    _userSubscription = UserService.userStream.listen((event) {
      setState(() {
        if (event != null) {
          chats = event.chats;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateChatScreen(),
              ))
        },
        label: const Text("New Chat"),
        icon: const Icon(Icons.chat_bubble_outline),
        // ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        onTap: (value) {
          setState(() {
            _page = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alternate_email),
            label: "Mentions",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
        ],
      ),
      body: _page == 0 || _page == 1
          ? chats == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : chats!.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text(
                          "Create or join a chat to get started!",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ListView.builder(
                        itemCount: chats!.length,
                        itemBuilder: (context, i) => ChatListTile(
                          index: i,
                          id: chats![i],
                        ),
                      ),
                    )
          : SearchPage(),
    );
  }
}
