import 'package:devsocy/models/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class CommentCard extends ConsumerWidget {
  final CommentModel comment;
  const CommentCard({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 5,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Routemaster.of(context).push('/u/${comment.uid}');
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                comment.profilePic,
              ),
              radius: 18,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'u/${comment.username}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(comment.text)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
