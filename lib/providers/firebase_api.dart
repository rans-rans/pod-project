import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApi {
  static UploadTask? uploadFile(String destination, var imageFile) {
    try {
      final refs = FirebaseStorage.instance.ref(destination);
      return refs.putFile(imageFile);
    } catch (error) {
      rethrow;
    }
  }
}
