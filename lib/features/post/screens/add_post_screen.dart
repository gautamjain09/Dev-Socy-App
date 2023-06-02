import 'package:devsocy/Responsive/responsive.dart';
import 'package:devsocy/core/common_widgets/add_post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Responsive(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Routemaster.of(context).push('/add-post/image');
                },
                child: AddPostCard(
                  iconData: Icons.image_outlined,
                  ref: ref,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Routemaster.of(context).push('/add-post/text');
                },
                child: AddPostCard(
                  iconData: Icons.font_download_outlined,
                  ref: ref,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Routemaster.of(context).push('/add-post/link');
                },
                child: AddPostCard(
                  iconData: Icons.link_outlined,
                  ref: ref,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
