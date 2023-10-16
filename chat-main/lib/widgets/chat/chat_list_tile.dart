import 'package:chat/models/chat.dart';
import 'package:chat/screens/chat/chat_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatListTile extends StatefulWidget {
  final int index;
  final String id;
  const ChatListTile({
    super.key,
    required this.index,
    required this.id,
  });

  @override
  State<ChatListTile> createState() => _ChatListTileState();
}

class _ChatListTileState extends State<ChatListTile> {
  Chat? chat;
  void _loadData() async {
    var doc = await FirebaseFirestore.instance.doc("/chats/${widget.id}").get();
    setState(() {
      chat = Chat.fromMap(doc.data()!);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return chat == null
        ? Container()
        : InkWell(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatViewPage(
                    id: widget.index,
                    intialChat: chat!,
                    chatId: widget.id,
                  ),
                ),
              ).then(
                (value) {
                  _loadData();
                },
              ),
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Hero(
                    tag: "__chat_icon${widget.index}",
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).highlightColor,
                      foregroundImage: NetworkImage(
                        chat!.photo,
                      ),
                      radius: 32.5,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Hero(
                            transitionOnUserGestures: true,
                            tag: "__chat_name${widget.index}",
                            child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                chat!.name,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          // const SizedBox(width: 5),
                          // Badge(
                          //   label: const Text("10"),
                          //   backgroundColor:
                          //       Theme.of(context).colorScheme.secondary,
                          //   textColor: Theme.of(context).colorScheme.onPrimary,
                          // )
                        ],
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        "${chat!.messages.last.sender.firstName}: ${chat!.messages.last.contents.replaceRange(15 < chat!.messages.last.contents.length ? 15 : chat!.messages.last.contents.length, chat!.messages.last.contents.length, "...")}",
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
