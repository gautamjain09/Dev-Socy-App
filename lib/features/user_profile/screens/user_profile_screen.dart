import 'package:devsocy/Responsive/responsive.dart';
import 'package:devsocy/core/common_widgets/error_text.dart';
import 'package:devsocy/core/common_widgets/loader.dart';
import 'package:devsocy/core/common_widgets/post_card.dart';
import 'package:devsocy/features/user_profile/controller/user_profile_controller.dart';
import 'package:devsocy/models/post_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:devsocy/features/auth/controller/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

class UserProfileScreen extends ConsumerWidget {
  final String uid;
  const UserProfileScreen({
    super.key,
    required this.uid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(getUserDataProvider(uid)).when(
            data: (userData) {
              return NestedScrollView(
                headerSliverBuilder: ((context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 200,
                      floating: true,
                      snap: true,
                      flexibleSpace: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              userData.banner,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding:
                                const EdgeInsets.all(10).copyWith(bottom: 40),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage:
                                  NetworkImage(userData.profilePic),
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: OutlinedButton(
                              onPressed: () {
                                Routemaster.of(context)
                                    .push('/edit-profile/${userData.uid}');
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Edit Profile'),
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'r/${userData.name}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    '${userData.karma} karma',
                                  ),
                                ),
                              ],
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
                  child: ref.watch(getUserPostsProvider(uid)).when(
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
