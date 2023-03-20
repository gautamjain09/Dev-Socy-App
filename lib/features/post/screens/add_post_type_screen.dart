import 'dart:io';
import 'package:devsocy/Responsive/responsive.dart';
import 'package:devsocy/core/common_widgets/error_text.dart';
import 'package:devsocy/core/common_widgets/loader.dart';
import 'package:devsocy/core/utils.dart';
import 'package:devsocy/features/community/controller/community_controller.dart';
import 'package:devsocy/features/post/controller/post_controller.dart';
import 'package:devsocy/models/community_model.dart';
import 'package:devsocy/core/theme/pallete.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypeScreen({
    required this.type,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController linkController = TextEditingController();

  File? bannerFile;
  Uint8List? bannerWebImage;
  List<CommunityModel> communities = [];
  CommunityModel? selectedCommunity;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      if (kIsWeb) {
        setState(() {
          bannerWebImage = res.files.first.bytes;
        });
      } else {
        setState(() {
          bannerFile = File(res.files.first.path!);
        });
      }
    }
  }

  void sharePost() async {
    if (widget.type == 'image' &&
        ((bannerFile != null || bannerWebImage != null)) &&
        titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).postImage(
            context: context,
            title: titleController.text.trim(),
            community: selectedCommunity ?? communities[0],
            file: bannerFile,
            webFile: bannerWebImage,
          );
    } else if (widget.type == 'text' &&
        titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).postText(
            context: context,
            title: titleController.text.trim(),
            community: selectedCommunity ?? communities[0],
            description: descriptionController.text.trim(),
          );
    } else if (widget.type == 'link' &&
        titleController.text.isNotEmpty &&
        linkController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).postLink(
            context: context,
            title: titleController.text.trim(),
            community: selectedCommunity ?? communities[0],
            link: linkController.text.trim(),
          );
    } else {
      showSnackbar(context, "Please enter all required the fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isTypeImage = (widget.type == 'image');
    final bool isTypeText = (widget.type == 'text');
    final bool isTypeLink = (widget.type == 'link');
    final ThemeData currentTheme = ref.watch(themeNotifierProvider);
    final isLoading = ref.watch(postControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Post ${widget.type}'),
        actions: [
          TextButton(
            onPressed: () {
              sharePost();
            },
            child: const Text('Share'),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : Responsive(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Enter Title here',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(18),
                      ),
                      maxLength: 25,
                    ),
                    const SizedBox(height: 10),
                    if (isTypeImage)
                      GestureDetector(
                        onTap: selectBannerImage,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [10, 4],
                          strokeCap: StrokeCap.round,
                          color: currentTheme.textTheme.bodyText2!.color!,
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: bannerWebImage != null
                                ? Image.memory(bannerWebImage!)
                                : bannerFile != null
                                    ? Image.file(bannerFile!)
                                    : const Center(
                                        child: Icon(
                                          Icons.camera_alt_outlined,
                                          size: 40,
                                        ),
                                      ),
                          ),
                        ),
                      ),
                    if (isTypeText)
                      TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Enter Description here',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18),
                        ),
                        maxLines: 5,
                      ),
                    if (isTypeLink)
                      TextField(
                        controller: linkController,
                        decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Enter link here',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18),
                        ),
                      ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Select Community',
                      ),
                    ),
                    ref.watch(userCommunitiesProvider).when(
                          data: (data) {
                            communities = data;
                            if (communities.isEmpty) {
                              return const SizedBox();
                            }
                            return DropdownButton(
                              value: selectedCommunity ?? data[0],
                              items: data
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e.name),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedCommunity = value;
                                });
                              },
                            );
                          },
                          error: (error, stackTrace) =>
                              ErrorText(text: error.toString()),
                          loading: () => const Loader(),
                        ),
                  ],
                ),
              ),
            ),
    );
  }
}
