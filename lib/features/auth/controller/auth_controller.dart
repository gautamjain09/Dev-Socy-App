import 'package:devsocy/core/utils.dart';
import 'package:devsocy/features/auth/repository/auth_repository.dart';
import 'package:devsocy/models/user_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authContollerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

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

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;
    user.fold(
        (error) => showSnackbar(context, error.message),
        (userModel) =>
            _ref.read(userProvider.notifier).update((state) => userModel));
  }
}
