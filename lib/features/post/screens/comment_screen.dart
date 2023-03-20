import 'package:devsocy/Responsive/responsive.dart';
import 'package:devsocy/core/common_widgets/comment_card.dart';
import 'package:devsocy/core/common_widgets/error_text.dart';
import 'package:devsocy/core/common_widgets/loader.dart';
import 'package:devsocy/core/common_widgets/post_card.dart';
import 'package:devsocy/features/auth/controller/auth_controller.dart';
import 'package:devsocy/features/post/controller/post_controller.dart';
import 'package:devsocy/models/post_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentScreen({
    required this.postId,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  void addComment(PostModel post) {
    ref.watch(postControllerProvider.notifier).addComment(
          context: context,
          text: commentController.text.trim(),
          post: post,
        );
    setState(() {
      commentController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
            data: (data) {
              return Column(
                children: [
                  PostCard(post: data),
                  if (!isGuest)
                    Responsive(
                      child: TextField(
                        onSubmitted: (val) {
                          addComment(data);
                        },
                        controller: commentController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'What are your thoughts?',
                          filled: true,
                        ),
                      ),
                    ),
                  ref.watch(getPostCommentsProvider(widget.postId)).when(
                        data: (data) {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (BuildContext context, int index) {
                                final comment = data[index];
                                return CommentCard(comment: comment);
                              },
                            ),
                          );
                        },
                        error: (error, stackTrace) {
                          if (kDebugMode) {
                            print(error.toString());
                          }
                          return ErrorText(text: error.toString());
                        },
                        loading: () => const Loader(),
                      ),
                ],
              );
            },
            error: (error, stackTrace) => ErrorText(text: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
