import 'package:devsocy/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostCard extends ConsumerWidget {
  final PostModel post;
  const PostCard({
    required this.post,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isTypeImage = (post.type == 'image');
    final bool isTypeText = (post.type == 'text');
    final bool isTypeLink = (post.type == 'link');
    return Container(child: Text(post.id));
  }
}
