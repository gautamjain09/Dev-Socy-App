import 'package:devsocy/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double cardSize = 120;
    double iconSize = 54;
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Routemaster.of(context).push('/add-post/image');
              },
              child: SizedBox(
                height: cardSize,
                width: cardSize,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: currentTheme.backgroundColor,
                  elevation: 16,
                  child: Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: iconSize,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Routemaster.of(context).push('/add-post/text');
              },
              child: SizedBox(
                height: cardSize,
                width: cardSize,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: currentTheme.backgroundColor,
                  elevation: 16,
                  child: Center(
                    child: Icon(
                      Icons.font_download_outlined,
                      size: iconSize,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Routemaster.of(context).push('/add-post/link');
              },
              child: SizedBox(
                height: cardSize,
                width: cardSize,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: currentTheme.backgroundColor,
                  elevation: 16,
                  child: Center(
                    child: Icon(
                      Icons.link_outlined,
                      size: iconSize,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
