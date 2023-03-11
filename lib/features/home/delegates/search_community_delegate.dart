import 'package:devsocy/core/common_widgets/error_text.dart';
import 'package:devsocy/core/common_widgets/loader.dart';
import 'package:devsocy/features/community/controller/community_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class SearchCommunityDelegate extends SearchDelegate {
  final WidgetRef ref;
  SearchCommunityDelegate(this.ref);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchCommunityProvider(query)).when(
        data: ((communities) {
          return ListView.builder(
            itemCount: communities.length,
            itemBuilder: ((context, index) {
              final community = communities[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(community.banner),
                ),
                title: Text("r/${community.name}"),
                onTap: () {
                  Routemaster.of(context).push(
                    "/r/${community.name}",
                  );
                },
              );
            }),
          );
        }),
        error: (error, stackTrace) => ErrorText(text: error.toString()),
        loading: () => const Loader());
  }
}
