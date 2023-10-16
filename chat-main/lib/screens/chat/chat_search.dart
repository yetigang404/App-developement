import 'package:chat/models/chat.dart';
import 'package:chat/models/user.dart';
import 'package:chat/screens/chat/chat_home.dart';
import 'package:chat/screens/chat/chat_view.dart';
import 'package:chat/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String uid = "";

  @override
  void initState() {
    super.initState();
    uid = auth.FirebaseAuth.instance.currentUser!.uid;
  }

  final List<Chat> chats = [
    Chat(
      messages: [],
      name: "Physics 009A",
      photo:
          "https://img.freepik.com/free-vector/atom-illustration-model-with-electrons-neutron-isolated_1284-53084.jpg",
    ),
    Chat(
      messages: [],
      name: "ECS 036A",
      photo:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRP-ciAYVH8UlH3ZaZC3NkN3ow9CrG36O5crg&usqp=CAU",
    ),
    Chat(
      messages: [],
      name: "Movie Club",
      photo:
          "https://images.food52.com/u5ZfTfjWVklAcLGIJNEgqEfr4ng=/1200x900/396860e0-412d-4dbd-840c-3e128f876c87--2013-0816_pop-popcorn-003.jpg",
    ),
    Chat(
      messages: [],
      name: "Chem 002",
      photo: "https://wallpaperaccess.com/full/958169.png",
    ),
    Chat(
      messages: [],
      name: "MAT 108",
      photo:
          "https://news.harvard.edu/wp-content/uploads/2022/11/iStock-mathproblems-1200x800.jpg",
    ),
    Chat(
      messages: [],
      name: "Machine Learning Club",
      photo:
          "https://c8.alamy.com/comp/2D6FW00/machine-learning-logo-design-vector-illustrations-brain-ai-technology-human-template-2D6FW00.jpg",
    ),
    Chat(
      messages: [],
      name: "ECS 020",
      photo:
          "https://img.freepik.com/free-vector/atom-illustration-model-with-electrons-neutron-isolated_1284-53084.jpg",
    ),
    Chat(
      messages: [],
      name: "Biology Study Group",
      photo:
          "https://img.freepik.com/free-vector/atom-illustration-model-with-electrons-neutron-isolated_1284-53084.jpg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListView(
        children: chats
            .map(
              (e) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(e.photo),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            e.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      FilledButton(
                        child: const Text("Join Chat"),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .doc("/users/$uid")
                              .update(
                            {
                              "messages": ["txNWDWsg2mLoa4ZZAPuJ"],
                            },
                          );
                          await UserService.getInstance().updateUser(
                            User(
                              chats: ["txNWDWsg2mLoa4ZZAPuJ"],
                            ),
                          );
                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatViewPage(
                                  id: 0,
                                  intialChat: chats[2],
                                  chatId: "txNWDWsg2mLoa4ZZAPuJ",
                                ),
                              ),
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
