import 'dart:io';
import 'package:devsocy/core/failure.dart';
import 'package:devsocy/core/providers/firebase_providers.dart';
import 'package:devsocy/core/type_defs.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

// < ------------------------- Providers ---------------------------------->
final storageRepositoryProvider = Provider((ref) {
  return StorageRepository(firebaseStorage: ref.watch(storageProvider));
});

// < ----------------------- Repository & Methods-------------------------->

class StorageRepository {
  final FirebaseStorage _firebaseStorage;
  StorageRepository({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage;

  FutureEither<String> storeFile({
    required String path,
    required String id,
    required File? file,
  }) async {
    try {
      final storageRef = _firebaseStorage.ref().child(path).child(id);
      UploadTask uploadTask = storageRef.putFile(file!);
      TaskSnapshot taskSnapshot = await uploadTask;

      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return right(downloadUrl);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
