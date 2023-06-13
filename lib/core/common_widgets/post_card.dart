import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:devsocy/Responsive/responsive.dart';
import 'package:devsocy/core/common_widgets/error_text.dart';
import 'package:devsocy/core/constants.dart';
import 'package:devsocy/core/theme/theme.dart';
import 'package:devsocy/features/auth/controller/auth_controller.dart';
import 'package:devsocy/features/community/controller/community_controller.dart';
import 'package:devsocy/features/post/controller/post_controller.dart';
import 'package:devsocy/models/post_model.dart';
import 'package:devsocy/core/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'loader.dart';

class PostCard extends ConsumerWidget {
  final PostModel post;
  const PostCard({
    required this.post,
    super.key,
  });

  void upVotePost(WidgetRef ref) async {
    ref.watch(postControllerProvider.notifier).upVotePost(post);
  }

  void downVotePost(WidgetRef ref) async {
    ref.watch(postControllerProvider.notifier).downVotePost(post);
  }

  void deletePost(WidgetRef ref, BuildContext context) async {
    ref.watch(postControllerProvider.notifier).deletePost(post, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = (post.type == 'image');
    final isTypeText = (post.type == 'text');
    final isTypeLink = (post.type == 'link');
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);
    final isGuest = !user.isAuthenticated;

    return Responsive(
      child: Column(
        children: [
          Container(
            color: currentTheme.drawerTheme.backgroundColor,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 16,
                        ).copyWith(right: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Routemaster.of(context)
                                            .push('/r/${post.communityName}');
                                      },
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          post.communityProfilePic,
                                        ),
                                        radius: 16,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'r/${post.communityName}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Routemaster.of(context)
                                                  .push('/u/${post.uid}');
                                            },
                                            child: Text(
                                              'u/${post.username}',
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (post.uid == user.uid)
                                  IconButton(
                                    onPressed: () {
                                      deletePost(ref, context);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Pallete.redColor,
                                    ),
                                  ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                post.title,
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            if (isTypeImage)
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.35,
                                width: MediaQuery.of(context).size.width,
                                child: CachedNetworkImage(
                                  imageUrl: post.link!,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) {
                                    return CircularProgressIndicator(
                                        value: downloadProgress.progress);
                                  },
                                  errorWidget: (context, url, error) {
                                    return Icon(Icons.error);
                                  },
                                  fit: BoxFit.fill,
                                ),
                              ),
                            if (isTypeText)
                              Container(
                                alignment: Alignment.bottomLeft,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Text(
                                  post.description!,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            if (isTypeLink)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: AnyLinkPreview(
                                  displayDirection:
                                      UIDirection.uiDirectionHorizontal,
                                  link: post.link!,
                                ),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: isGuest
                                          ? () {}
                                          : () => upVotePost(ref),
                                      icon: Icon(
                                        Constants.up,
                                        size: 24,
                                        color: post.upvotes.contains(user.uid)
                                            ? Pallete.redColor
                                            : null,
                                      ),
                                    ),
                                    Text(
                                      '${post.upvotes.length - post.downvotes.length == 0 ? 'Vote' : post.upvotes.length - post.downvotes.length}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: isGuest
                                          ? () {}
                                          : () => downVotePost(ref),
                                      icon: Icon(
                                        Constants.down,
                                        size: 24,
                                        color: post.downvotes.contains(user.uid)
                                            ? Pallete.blueColor
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Routemaster.of(context)
                                            .push('/post/${post.id}/comments');
                                      },
                                      icon: const Icon(
                                        Icons.comment,
                                        size: 22,
                                      ),
                                    ),
                                    Text(
                                      '${post.commentCount == 0 ? 'Comment' : post.commentCount}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                ref
                                    .watch(getCommunityByNameProvider(
                                        post.communityName))
                                    .when(
                                      data: (data) {
                                        if (data.mods.contains(user.uid)) {
                                          return IconButton(
                                            onPressed: () {
                                              deletePost(ref, context);
                                            },
                                            icon: const Icon(
                                              Icons.admin_panel_settings,
                                            ),
                                          );
                                        }
                                        return const SizedBox();
                                      },
                                      error: (error, stackTrace) =>
                                          ErrorText(text: error.toString()),
                                      loading: () => const Loader(),
                                    ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
