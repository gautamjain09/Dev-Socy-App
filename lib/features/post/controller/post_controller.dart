import 'dart:io';
import 'package:devsocy/core/enums.dart';
import 'package:devsocy/core/providers/storage_repository_provider.dart';
import 'package:devsocy/core/utils.dart';
import 'package:devsocy/features/auth/controller/auth_controller.dart';
import 'package:devsocy/features/post/repository/post_repository.dart';
import 'package:devsocy/features/user_profile/controller/user_profile_controller.dart';
import 'package:devsocy/models/comment_model.dart';
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
      .fetchUserPosts(userCommunities);
});

final getPostByIdProvider = StreamProvider.family((ref, String postId) {
  return ref.watch(postControllerProvider.notifier).getPostById(postId);
});

final getPostCommentsProvider = StreamProvider.family((ref, String postId) {
  return ref.watch(postControllerProvider.notifier).getPostComments(postId);
});

final guestPostsProvider = StreamProvider((ref) {
  return ref.watch(postControllerProvider.notifier).fetchGuestPosts();
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

  get postId => null;

  // <---------------------------- Add Text ----------------------------->

  void postText({
    required BuildContext context,
    required String title,
    required CommunityModel community,
    required String description,
  }) async {
    state = true;
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

    // Updating karma -> Post Text
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.postText);

    final res = await _postRepository.addPost(post);
    state = false;
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
    state = true;
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

    // Updating karma -> postLink
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.postLink);

    final res = await _postRepository.addPost(post);
    state = false;
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
    state = true;
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

        // Updating karma -> postImage
        _ref
            .read(userProfileControllerProvider.notifier)
            .updateUserKarma(UserKarma.postImage);

        final res = await _postRepository.addPost(post);
        state = false;
        res.fold((l) => showSnackbar(context, l.message), (r) {
          showSnackbar(context, "Posted Successfully");
          Routemaster.of(context).pop();
        });
      },
    );
  }

  Stream<List<PostModel>> fetchUserPosts(List<CommunityModel> userCommunities) {
    if (userCommunities.isEmpty) {
      return Stream.value([]);
    } else {
      return _postRepository.fetchUserPosts(userCommunities);
    }
  }

  void deletePost(PostModel post, BuildContext context) async {
    // Updating karma - > deletePost
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.postDelete);

    final res = await _postRepository.deletePost(post);
    res.fold(
      (l) => showSnackbar(context, l.message),
      (r) => showSnackbar(context, "Post Deleted Successfully!"),
    );
  }

  void upVotePost(PostModel post) async {
    final user = _ref.read(userProvider)!;
    _postRepository.upVotePost(post, user.uid);
  }

  void downVotePost(PostModel post) async {
    final user = _ref.read(userProvider)!;
    _postRepository.downVotePost(post, user.uid);
  }

  Stream<PostModel> getPostById(String postId) {
    return _postRepository.getPostById(postId);
  }

  void addComment(
      {required BuildContext context,
      required String text,
      required PostModel post}) async {
    String commentId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    CommentModel comment = CommentModel(
      id: commentId,
      text: text,
      createdAt: DateTime.now(),
      postId: post.id,
      username: user.name,
      uid: user.uid,
      profilePic: user.profilePic,
    );

    // Updating karma -> Comment
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.comment);

    final res = await _postRepository.addComment(comment);
    res.fold(
      (l) => showSnackbar(context, l.message),
      (r) => showSnackbar(context, 'Comment Added Successfully!'),
    );
  }

  Stream<List<CommentModel>> getPostComments(String postId) {
    return _postRepository.getPostComments(postId);
  }

  Stream<List<PostModel>> fetchGuestPosts() {
    return _postRepository.fetchGuestPosts();
  }
}
