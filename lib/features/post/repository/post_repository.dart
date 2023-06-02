import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devsocy/core/constants.dart';
import 'package:devsocy/core/failure.dart';
import 'package:devsocy/core/providers/firebase_providers.dart';
import 'package:devsocy/core/type_defs.dart';
import 'package:devsocy/models/comment_model.dart';
import 'package:devsocy/models/community_model.dart';
import 'package:devsocy/models/post_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

// <---------------------------- Providers ------------------------------------>

final postRepositoryProvider = Provider((ref) {
  return PostRepository(firestore: ref.watch(firestoreProvider));
});

// <-------------------------- Repository & Methods --------------------------->

class PostRepository {
  final FirebaseFirestore _firestore;
  PostRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  // --------------------------- Getters -------------------------------------->

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);
  CollectionReference get _comments =>
      _firestore.collection(FirebaseConstants.commentsCollection);

  // --------------------------- Methods -------------------------------------->

  FutureVoid addPost(PostModel post) async {
    try {
      return right(await _posts.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<PostModel>> fetchUserPosts(List<CommunityModel> userCommunities) {
    return _posts
        .where(
          'communityName',
          whereIn: userCommunities.map((e) => e.name).toList(),
        )
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots()
        .map((event) => event.docs
            .map((e) => PostModel.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  FutureVoid deletePost(PostModel post) async {
    try {
      return right(_posts.doc(post.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  void upVotePost(PostModel post, String userId) async {
    // if already downVoted -> downVotes me se remove
    if (post.downvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayRemove([userId])
      });
    }
    // If already upvoted -> Upvotes me se remove
    if (post.upvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayRemove([userId])
      });
    } else {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayUnion([userId])
      });
    }
  }

  void downVotePost(PostModel post, String userId) async {
    // If already upvoted -> Upvotes me se remove
    if (post.upvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayRemove([userId])
      });
    }
    // if already downVoted -> downVotes me se remove
    if (post.downvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayRemove([userId])
      });
    } else {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayUnion([userId])
      });
    }
  }

  // Comment Screen will acess the PostModel from postId
  Stream<PostModel> getPostById(String postId) {
    return _posts.doc(postId).snapshots().map(
          (event) => PostModel.fromMap(
            event.data() as Map<String, dynamic>,
          ),
        );
  }

  FutureVoid addComment(CommentModel comment) async {
    try {
      await _comments.doc(comment.id).set(comment.toMap());

      return right(
        _posts
            .doc(comment.postId)
            .update({'commentCount': FieldValue.increment(1)}),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<CommentModel>> getPostComments(String postId) {
    return _comments
        .where(
          'postId',
          isEqualTo: postId,
        )
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots()
        .map((event) => event.docs
            .map((e) => CommentModel.fromMap(
                  e.data() as Map<String, dynamic>,
                ))
            .toList());
  }

  Stream<List<PostModel>> fetchGuestPosts() {
    return _posts
        .orderBy(
          'createdAt',
          descending: true,
        )
        .limit(9)
        .snapshots()
        .map((event) => event.docs
            .map((e) => PostModel.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }
}
