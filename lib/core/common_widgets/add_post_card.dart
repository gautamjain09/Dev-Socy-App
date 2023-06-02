import 'package:devsocy/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPostCard extends StatelessWidget {
  final IconData iconData;
  final WidgetRef ref;
  const AddPostCard({
    super.key,
    required this.iconData,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    double cardSize = 120;
    double iconSize = 54;
    final currentTheme = ref.watch(themeNotifierProvider);

    return SizedBox(
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
            iconData,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
