import 'package:devsocy/core/utils.dart';
import 'package:devsocy/features/auth/repository/auth_repository.dart';
import 'package:devsocy/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ---------------------- Providers ---------------------------------------------->

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

final authStateChangeProvider = StreamProvider((ref) {
  return ref.watch(authControllerProvider.notifier).authStateChange;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  return ref.watch(authControllerProvider.notifier).getUserData(uid);
});

//------------------------ Controller & Methods ------------------------------------>

// StateNotifier is For Showing Loading bar in UI
class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({
    required AuthRepository authRepository,
    required Ref ref,
  })  : _authRepository = authRepository,
        _ref = ref,
        super(false);

  //------------------------ Getters ------------------------------------>

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  //------------------------ Fnctions ------------------------------------>

  void signInWithGoogle(BuildContext context, bool isFromLogin) async {
    state = true;
    final user = await _authRepository.signInWithGoogle(isFromLogin);
    state = false;

    user.fold(
        (error) => showSnackbar(context, error.message),
        (userModel) =>
            _ref.watch(userProvider.notifier).update((state) => userModel));
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  void signInAsGuest(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInAsGuest();
    state = false;
    user.fold(
        (error) => showSnackbar(context, error.message),
        (userModel) =>
            _ref.watch(userProvider.notifier).update((state) => userModel));
  }

  void logOut() async {
    _authRepository.logOut();
  }
}
