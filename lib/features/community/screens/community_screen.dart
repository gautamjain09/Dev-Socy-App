import 'package:devsocy/Responsive/responsive.dart';
import 'package:devsocy/core/common_widgets/error_text.dart';
import 'package:devsocy/core/common_widgets/loader.dart';
import 'package:devsocy/core/common_widgets/post_card.dart';
import 'package:devsocy/features/auth/controller/auth_controller.dart';
import 'package:devsocy/features/community/controller/community_controller.dart';
import 'package:devsocy/models/community_model.dart';
import 'package:devsocy/models/post_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({
    required this.name,
    super.key,
  });

  void joinCommunity(
      WidgetRef ref, CommunityModel community, BuildContext context) {
    ref
        .read(communityControllerProvider.notifier)
        .joinCommunity(community, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
            data: (community) {
              return NestedScrollView(
                headerSliverBuilder: ((context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 150,
                      floating: true,
                      snap: true,
                      flexibleSpace: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              community.banner,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Align(
                              alignment: Alignment.topLeft,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(community.avatar),
                                radius: 36,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'r/${community.name}',
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (!isGuest)
                                  community.mods.contains(user.uid)
                                      ? OutlinedButton(
                                          onPressed: () {
                                            Routemaster.of(context)
                                                .push('/mod-tools/$name');
                                          },
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 25,
                                            ),
                                          ),
                                          child: const Text('Mod Tools'),
                                        )
                                      : OutlinedButton(
                                          onPressed: () {
                                            joinCommunity(
                                                ref, community, context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 25,
                                            ),
                                          ),
                                          child: Text(
                                            community.members.contains(user.uid)
                                                ? 'Joined'
                                                : 'Join',
                                          ),
                                        )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                '${community.members.length} members',
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Divider(thickness: 2.5),
                          ],
                        ),
                      ),
                    ),
                  ];
                }),
                body: Responsive(
                  child: ref.watch(getCommunityPostsProvider(name)).when(
                        data: (communityPosts) {
                          return ListView.builder(
                            itemCount: communityPosts.length,
                            itemBuilder: (context, index) {
                              PostModel post = communityPosts[index];
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
                      ),
                ),
              );
            },
            error: ((error, stackTrace) {
              if (kDebugMode) {
                print(error.toString());
              }
              return ErrorText(text: error.toString());
            }),
            loading: () => const Loader(),
          ),
    );
  }
}
