import 'package:devsocy/core/common_widgets/error_text.dart';
import 'package:devsocy/core/common_widgets/loader.dart';
import 'package:devsocy/core/common_widgets/google_signin_button.dart';
import 'package:devsocy/features/auth/controller/auth_controller.dart';
import 'package:devsocy/features/community/controller/community_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated; // NotAuthenticatd -> Guest

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            isGuest
                ? const SignInButton()
                : ListTile(
                    title: const Text('Create a Community'),
                    leading: const Icon(Icons.add),
                    onTap: () {
                      Routemaster.of(context).push('/create-community');
                    },
                  ),
            if (!isGuest)
              ref.watch(userCommunitiesProvider).when(
                    data: (communities) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: communities.length,
                          itemBuilder: ((context, index) {
                            final community = communities[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(community.avatar),
                              ),
                              title: Text('r/${community.name}'),
                              onTap: () {
                                Routemaster.of(context)
                                    .push('/r/${community.name}');
                              },
                            );
                          }),
                        ),
                      );
                    },
                    error: (error, stackTrace) =>
                        ErrorText(text: error.toString()),
                    loading: () => const Loader(),
                  )
          ],
        ),
      ),
    );
  }
}
