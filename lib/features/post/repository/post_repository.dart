import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devsocy/core/constants/firebase_constants.dart';
import 'package:devsocy/core/failure.dart';
import 'package:devsocy/core/providers/firebase_providers.dart';
import 'package:devsocy/core/type_defs.dart';
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

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);

  FutureVoid addPost(PostModel post) async {
    try {
      return right(await _posts.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<PostModel>> fetchUserPost(List<CommunityModel> userCommunities) {
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
}
