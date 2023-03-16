import 'dart:io';
import 'package:devsocy/core/providers/storage_repository_provider.dart';
import 'package:devsocy/core/utils.dart';
import 'package:devsocy/features/auth/controller/auth_controller.dart';
import 'package:devsocy/features/post/repository/post_repository.dart';
import 'package:devsocy/models/community_model.dart';
import 'package:devsocy/models/post_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

// <---------------------------- Providers ------------------------------------>

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  return PostController(
    postRepository: ref.watch(postRepositoryProvider),
    storageRepository: ref.watch(storageRepositoryProvider),
    ref: ref,
  );
});

final userPostsProvider =
    StreamProvider.family((ref, List<CommunityModel> userCommunities) {
  return ref
      .watch(postControllerProvider.notifier)
      .fetchUserPost(userCommunities);
});

// <-------------------------- Repository & Methods --------------------------->

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;

  PostController({
    required PostRepository postRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _postRepository = postRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  // <---------------------------- Add Text ----------------------------->

  void postText({
    required BuildContext context,
    required String title,
    required CommunityModel community,
    required String description,
  }) async {
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final PostModel post = PostModel(
      id: postId,
      title: title,
      communityName: community.name,
      communityProfilePic: community.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'text',
      createdAt: DateTime.now(),
      awards: [],
      description: description,
    );

    final res = await _postRepository.addPost(post);
    res.fold((l) => showSnackbar(context, l.message), (r) {
      showSnackbar(context, "Posted Successfully");
      Routemaster.of(context).pop();
    });
  }

  // <---------------------------- Add Link ----------------------------->

  void postLink({
    required BuildContext context,
    required String title,
    required CommunityModel community,
    required String link,
  }) async {
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final PostModel post = PostModel(
      id: postId,
      title: title,
      communityName: community.name,
      communityProfilePic: community.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'link',
      createdAt: DateTime.now(),
      awards: [],
      link: link,
    );

    final res = await _postRepository.addPost(post);
    res.fold((l) => showSnackbar(context, l.message), (r) {
      showSnackbar(context, "Posted Successfully");
      Routemaster.of(context).pop();
    });
  }

  // <---------------------------- Add Image ----------------------------->

  void postImage({
    required BuildContext context,
    required String title,
    required CommunityModel community,
    required File? file,
  }) async {
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final imageUrl = await _storageRepository.storeFile(
      path: 'posts/${community.name}',
      id: postId,
      file: file,
    );

    imageUrl.fold(
      (l) => showSnackbar(context, l.message),
      (r) async {
        final PostModel post = PostModel(
          id: postId,
          title: title,
          communityName: community.name,
          communityProfilePic: community.avatar,
          upvotes: [],
          downvotes: [],
          commentCount: 0,
          username: user.name,
          uid: user.uid,
          type: 'image',
          createdAt: DateTime.now(),
          awards: [],
          link: r, // Image
        );

        final res = await _postRepository.addPost(post);
        res.fold((l) => showSnackbar(context, l.message), (r) {
          showSnackbar(context, "Posted Successfully");
          Routemaster.of(context).pop();
        });
      },
    );
  }

  Stream<List<PostModel>> fetchUserPost(List<CommunityModel> userCommunities) {
    if (userCommunities.isEmpty) {
      return Stream.value([]);
    } else {
      return _postRepository.fetchUserPost(userCommunities);
    }
  }
}
