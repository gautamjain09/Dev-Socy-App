import 'package:devsocy/features/auth/controller/auth_controller.dart';
import 'package:devsocy/features/feed/screens/feed_screen.dart';
import 'package:devsocy/features/home/delegates/search_community_delegate.dart';
import 'package:devsocy/features/home/drawers/community_list_drawer.dart';
import 'package:devsocy/features/home/drawers/profile_drawer.dart';
import 'package:devsocy/features/post/screens/add_post_screen.dart';
import 'package:devsocy/theme/pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _index = 0;
  void onPageChanged(int page) {
    setState(() {
      _index = page;
    });
  }

  List<Widget> tabList = [
    const FeedScreen(),
    const AddPostScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: false,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              //  delegates Inbuilt Method
              showSearch(
                context: context,
                delegate: SearchCommunityDelegate(ref),
              );
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
          Builder(
            builder: (context) {
              return IconButton(
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(user.profilePic),
                ),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
      body: tabList[_index],
      drawer: const CommunityListDrawer(),
      endDrawer: const ProfileDrawer(),
      bottomNavigationBar: CupertinoTabBar(
        activeColor: currentTheme.iconTheme.color,
        backgroundColor: currentTheme.backgroundColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '',
          ),
        ],
        onTap: onPageChanged,
        currentIndex: _index,
      ),
    );
  }
}
