import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devsocy/core/constants/firebase_constants.dart';
import 'package:devsocy/core/failure.dart';
import 'package:devsocy/core/providers/firebase_providers.dart';
import 'package:devsocy/core/type_defs.dart';
import 'package:devsocy/models/community_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

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

  CollectionReference get _communities =>
      _firestore.collection(FirebaseConstants.communitiesCollection);

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
      // Edit Community at the community.name in Firestore
      return right(_communities.doc(community.name).update(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
