import 'package:devsocy/core/common_widgets/error_text.dart';
import 'package:devsocy/core/common_widgets/loader.dart';
import 'package:devsocy/core/common_widgets/post_card.dart';
import 'package:devsocy/features/community/controller/community_controller.dart';
import 'package:devsocy/features/post/controller/post_controller.dart';
import 'package:devsocy/models/post_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userCommunitiesProvider).when(
          data: (userCommunities) {
            return ref.watch(userPostsProvider(userCommunities)).when(
                  data: (userPosts) {
                    return ListView.builder(
                      itemCount: userPosts.length,
                      itemBuilder: (context, index) {
                        PostModel post = userPosts[index];
                        return PostCard(post: post);
                      },
                    );
                  },
                  error: ((error, stackTrace) {
                    if (kDebugMode) {
                      print(error.toString());
                    }
                    return ErrorText(text: error.toString());
                  }),
                  loading: () => const Loader(),
                );
          },
          error: ((error, stackTrace) => ErrorText(text: error.toString())),
          loading: () => const Loader(),
        );
  }
}
