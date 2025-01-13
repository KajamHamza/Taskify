import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _uuid = Uuid();

  Future<String> uploadImage(File file, String folder) async {
    try {
      String fileName = '${_uuid.v4()}.jpg';
      Reference ref = _storage.ref().child('$folder/$fileName');

      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);

      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<List<String>> uploadMultipleImages(
    List<File> files,
    String folder,
  ) async {
    List<String> urls = [];
    for (File file in files) {
      String url = await uploadImage(file, folder);
      urls.add(url);
    }
    return urls;
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }
}