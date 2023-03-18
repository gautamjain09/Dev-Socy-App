import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devsocy/core/constants/firebase_constants.dart';
import 'package:devsocy/core/failure.dart';
import 'package:devsocy/core/providers/firebase_providers.dart';
import 'package:devsocy/core/type_defs.dart';
import 'package:devsocy/models/post_model.dart';
import 'package:devsocy/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

// < ------------------------ Providers ------------------------------------->

final userProfileRepositoryProvider = Provider((ref) {
  return UserProfileRepository(firestore: ref.watch(firestoreProvider));
});

// < ---------------------- Repository & Methods ----------------------------->

class UserProfileRepository {
  final FirebaseFirestore _firestore;
  UserProfileRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  CollectionReference get _post =>
      _firestore.collection(FirebaseConstants.postsCollection);

  FutureVoid editProfile(UserModel user) async {
    try {
      return right(_users.doc(user.uid).update(user.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<PostModel>> getUserPost(String uid) {
    return _post
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) => PostModel.fromMap(
                  e.data() as Map<String, dynamic>,
                ))
            .toList());
  }

  FutureVoid updateUserKarma(UserModel user) async {
    try {
      return right(_users.doc(user.uid).update(user.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
