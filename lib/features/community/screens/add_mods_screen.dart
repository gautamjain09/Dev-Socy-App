import 'package:devsocy/Responsive/responsive.dart';
import 'package:devsocy/core/common_widgets/error_text.dart';
import 'package:devsocy/core/common_widgets/loader.dart';
import 'package:devsocy/features/auth/controller/auth_controller.dart';
import 'package:devsocy/features/community/controller/community_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddModsScreen extends ConsumerStatefulWidget {
  final String name;
  const AddModsScreen({
    super.key,
    required this.name,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {
  // Counter is used when we set the initial state of add mods screen
  int counter = 0;

  Set<String> modsUids = {};
  void addUid(String uid) {
    setState(() {
      modsUids.add(uid);
    });
  }

  void removeUid(String uid) {
    setState(() {
      modsUids.remove(uid);
    });
  }

  void saveMods() {
    ref
        .read(communityControllerProvider.notifier)
        .addModsInACommunity(widget.name, modsUids.toList(), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              saveMods();
            },
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: Responsive(
        child: ref.watch(getCommunityByNameProvider(widget.name)).when(
              data: (community) => ListView.builder(
                itemCount: community.members.length,
                itemBuilder: (BuildContext context, int index) {
                  final member = community.members[index];
                  return ref.watch(getUserDataProvider(member)).when(
                        data: ((userData) {
                          if (community.mods.contains(member) && counter == 0) {
                            modsUids.add(member);
                          }
                          counter++;
                          return CheckboxListTile(
                            value: modsUids.contains(userData.uid),
                            onChanged: (val) {
                              if (val!) {
                                addUid(member);
                              } else {
                                removeUid(member);
                              }
                            },
                            title: Text(userData.name),
                          );
                        }),
                        error: (error, stackTrace) =>
                            ErrorText(text: error.toString()),
                        loading: () => const Loader(),
                      );
                },
              ),
              error: (error, stackTrace) => ErrorText(text: error.toString()),
              loading: () => const Loader(),
            ),
      ),
    );
  }
}
