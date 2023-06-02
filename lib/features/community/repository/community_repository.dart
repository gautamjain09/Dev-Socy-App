import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devsocy/core/failure.dart';
import 'package:devsocy/core/providers/firebase_providers.dart';
import 'package:devsocy/core/type_defs.dart';
import 'package:devsocy/models/community_model.dart';
import 'package:devsocy/models/post_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/constants.dart';

// <---------------------------- Providers ------------------------------------>

final communityRepositoryProvider = Provider((ref) {
  return CommunityRepository(firestore: ref.watch(firestoreProvider));
});

// <-------------------------- Repository & Methods --------------------------->

class CommunityRepository {
  final FirebaseFirestore _firestore;

  CommunityRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  FutureVoid createCommunity(CommunityModel communityModel) async {
    try {
      var communityDoc = await _communities.doc(communityModel.name).get();
      if (communityDoc.exists) {
        throw "Community with the same name already exists";
      }

      return right(
          _communities.doc(communityModel.name).set(communityModel.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

// <-------------------------- Getters ----- --------------------------->

  CollectionReference get _communities =>
      _firestore.collection(FirebaseConstants.communitiesCollection);

  CollectionReference get _post =>
      _firestore.collection(FirebaseConstants.postsCollection);

// <-------------------------- Functions ---------------------------------->

  Stream<List<CommunityModel>> getUserCommunities(String uid) {
    return _communities
        .where('members', arrayContains: uid)
        .snapshots()
        .map((event) {
      List<CommunityModel> myCommunities = [];
      for (var doc in event.docs) {
        myCommunities
            .add(CommunityModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return myCommunities;
    });
  }

  Stream<CommunityModel> getCommunityByName(String name) {
    return _communities.doc(name).snapshots().map((event) =>
        CommunityModel.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureVoid editCommunity(CommunityModel community) async {
    try {
      // replace community by new community in Firestore by using community.name
      return right(_communities.doc(community.name).update(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<CommunityModel>> searchCommunity(String query) {
    return _communities
        .where('name',
            isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
            isLessThan: query.isEmpty
                ? 0
                : query.substring(0, query.length - 1) +
                    String.fromCharCode(query.codeUnitAt(query.length - 1) + 1))
        .snapshots()
        .map((event) {
      List<CommunityModel> myCommunities = [];
      for (var community in event.docs) {
        myCommunities.add(
            CommunityModel.fromMap(community.data() as Map<String, dynamic>));
      }
      return myCommunities;
    });
  }

  FutureVoid joinCommunity(String communityName, String userId) async {
    try {
      return right(
        await _communities.doc(communityName).update({
          'members': FieldValue.arrayUnion([userId]),
        }),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid leaveCommunity(String communityName, String userId) async {
    try {
      return right(
        await _communities.doc(communityName).update({
          'members': FieldValue.arrayRemove([userId]),
        }),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid addModsInACommunity(
      String communityName, List<String> modsUids) async {
    try {
      // replace community by new community in Firestore by using community.name
      return right(_communities.doc(communityName).update({
        'mods': modsUids,
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<PostModel>> getCommunityPosts(String communityName) {
    return _post
        .where(
          'communityName',
          isEqualTo: communityName,
        )
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots()
        .map((event) => event.docs
            .map((e) => PostModel.fromMap(
                  e.data() as Map<String, dynamic>,
                ))
            .toList());
  }
}
