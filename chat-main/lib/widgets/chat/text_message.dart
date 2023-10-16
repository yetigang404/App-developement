import 'package:chat/models/message.dart';
import 'package:flutter/material.dart';

class TextMessage extends StatelessWidget {
  final Message message;
  const TextMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(
                  message.sender.profilePhoto ?? "",
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                child: Text(
                  message.contents,
                  softWrap: true,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            "${message.sender.firstName} ${message.sender.lastName}",
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}
