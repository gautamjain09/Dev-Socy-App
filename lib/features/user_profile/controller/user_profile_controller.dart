import 'dart:io';
import 'package:devsocy/core/enums.dart';
import 'package:devsocy/core/providers/storage_repository_provider.dart';
import 'package:devsocy/core/utils.dart';
import 'package:devsocy/features/auth/controller/auth_controller.dart';
import 'package:devsocy/features/user_profile/repository/user_profile_repository.dart';
import 'package:devsocy/models/post_model.dart';
import 'package:devsocy/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

// <-------------------------- Providers ---------------------------------->

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(
    userProfileRepository: ref.watch(userProfileRepositoryProvider),
    storageRepository: ref.watch(storageRepositoryProvider),
    ref: ref,
  );
});

final getUserPostsProvider = StreamProvider.family((ref, String uid) {
  return ref.watch(userProfileControllerProvider.notifier).getuserPosts(uid);
});

// <----------------------- Controllers & Methods ------------------------>

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  UserProfileController({
    required UserProfileRepository userProfileRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _userProfileRepository = userProfileRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void editProfile(File? bannerFile, File? profileFile, String name,
      BuildContext context) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;
    if (bannerFile != null) {
      final bannerUrl = await _storageRepository.storeFile(
        path: "users/banner",
        id: user.uid,
        file: bannerFile,
      );

      bannerUrl.fold(
        (l) => showSnackbar(context, l.message),
        (r) => user = user.copyWith(banner: r),
      );
    }
    if (profileFile != null) {
      final profileUrl = await _storageRepository.storeFile(
        path: "users/profile",
        id: user.uid,
        file: profileFile,
      );

      profileUrl.fold(
        (l) => showSnackbar(context, l.message),
        (r) => user = user.copyWith(profilePic: r),
      );
    }

    user = user.copyWith(name: name);
    final res = await _userProfileRepository.editProfile(user);
    state = false;

    res.fold((l) => showSnackbar(context, l.message), (r) {
      showSnackbar(context, "Changes Saved Successfully!");

      // Updating the userProvider
      _ref.read(userProvider.notifier).update((state) => user);
      Routemaster.of(context).pop();
    });
  }

  Stream<List<PostModel>> getuserPosts(String uid) {
    return _userProfileRepository.getUserPost(uid);
  }

  void updateUserKarma(UserKarma karma) async {
    UserModel user = _ref.read(userProvider)!;
    user = user.copyWith(karma: user.karma + karma.karma);

    final res = await _userProfileRepository.updateUserKarma(user);
    res.fold(
      (l) => null,
      (r) => _ref.read(userProvider.notifier).update((state) => user),
    );
  }
}
