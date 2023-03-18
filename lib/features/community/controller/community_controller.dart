import 'dart:io';

import 'package:devsocy/core/constants/constants.dart';
import 'package:devsocy/core/failure.dart';
import 'package:devsocy/core/providers/storage_repository_provider.dart';
import 'package:devsocy/core/utils.dart';
import 'package:devsocy/features/auth/controller/auth_controller.dart';
import 'package:devsocy/features/community/repository/community_repository.dart';
import 'package:devsocy/models/community_model.dart';
import 'package:devsocy/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'package:routemaster/routemaster.dart';

// <-------------------------- Providers ---------------------------------->

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>(
  (ref) => CommunityController(
    communityRepository: ref.watch(communityRepositoryProvider),
    storageRepository: ref.watch(storageRepositoryProvider),
    ref: ref,
  ),
);

final userCommunitiesProvider = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunities();
});

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getCommunityByName(name);
});

final searchCommunityProvider = StreamProvider.family((ref, String query) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.searchCommunity(query);
});

final getCommunityPostsProvider =
    StreamProvider.family((ref, String communityName) {
  return ref
      .watch(communityControllerProvider.notifier)
      .getCommunityPosts(communityName);
});

// <----------------------- Controllers & Methods ------------------------>

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;

  CommunityController({
    required CommunityRepository communityRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _communityRepository = communityRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;

    final uid = _ref.read(userProvider)?.uid ?? '';
    CommunityModel communityModel = CommunityModel(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      members: [uid],
      mods: [uid],
    );

    final res = await _communityRepository.createCommunity(communityModel);
    state = false;

    res.fold((l) {
      showSnackbar(context, l.message);
    }, (r) {
      showSnackbar(context, "Community created Successfully!");
      Routemaster.of(context).pop();
    });
  }

  Stream<List<CommunityModel>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunities(uid);
  }

  Stream<CommunityModel> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  void editCommunity(File? bannerFile, File? profileFile, BuildContext context,
      CommunityModel community) async {
    state = true;

    if (bannerFile != null) {
      // Stores file at communities/banner/${community.name}
      final bannerUrl = await _storageRepository.storeFile(
        path: "communities/banner",
        id: community.name,
        file: bannerFile,
      );

      bannerUrl.fold(
        (l) => showSnackbar(context, l.message),
        (r) => community = community.copyWith(banner: r),
      );
    }
    if (profileFile != null) {
      // Stores file at communities/profile/${community.name}
      final profileUrl = await _storageRepository.storeFile(
        path: "communities/profile",
        id: community.name,
        file: profileFile,
      );

      profileUrl.fold(
        (l) => showSnackbar(context, l.message),
        (r) => community = community.copyWith(avatar: r),
      );
    }

    final res = await _communityRepository.editCommunity(community);
    state = false;

    res.fold((l) => showSnackbar(context, l.message), (r) {
      showSnackbar(context, "Changes Saved Successfully!");
      Routemaster.of(context).pop();
    });
  }

  Stream<List<CommunityModel>> searchCommunity(String query) {
    return _communityRepository.searchCommunity(query);
  }

  // Joint Function for Join & Leaving the Community
  void joinCommunity(CommunityModel community, BuildContext context) async {
    final user = _ref.read(userProvider)!;

    Either<Failure, void> res;
    if (community.members.contains(user.uid)) {
      res = await _communityRepository.leaveCommunity(community.name, user.uid);
    } else {
      res = await _communityRepository.joinCommunity(community.name, user.uid);
    }

    res.fold(
      (l) => showSnackbar(context, l.message),
      (r) {
        if (community.members.contains(user.uid)) {
          showSnackbar(context, "Community Left Successfully!");
        } else {
          showSnackbar(context, "Community Joined Successfully!");
        }
      },
    );
  }

  void addModsInACommunity(
      String communityName, List<String> modsUids, BuildContext context) async {
    final res =
        await _communityRepository.addModsInACommunity(communityName, modsUids);

    res.fold((l) => showSnackbar(context, l.message), (r) {
      showSnackbar(context, "Mods Updated Successfully!");
      Routemaster.of(context).pop();
    });
  }

  Stream<List<PostModel>> getCommunityPosts(String communityName) {
    return _communityRepository.getCommunityPost(communityName);
  }
}
