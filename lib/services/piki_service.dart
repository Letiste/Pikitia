import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart' as firebase_firestore;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:geolocator/geolocator.dart';
import 'package:pikitia/locator.dart';
import 'package:pikitia/services/position_service.dart';
import 'package:uuid/uuid.dart';

class PikiService {
  PikiService() {
    _storage = firebase_storage.FirebaseStorage.instance;
  }
  late firebase_storage.FirebaseStorage _storage;

  Future<void> createPiki(String filePath) async {
    String htmlUrl = await _uploadFile(filePath);
    Position position = await locator<PositionService>().getCurrentPosition();
    firebase_firestore.FirebaseFirestore.instance.collection('pikis').add(<String, dynamic>{
      'htmlUrl': htmlUrl,
      'position': firebase_firestore.GeoPoint(position.latitude, position.longitude),
    });
  }

  Future<String> _uploadFile(String filePath) async {
    File file = File(filePath);
    String fileName = const Uuid().v4();
    try {
      firebase_storage.TaskSnapshot uploadedFile = await _storage.ref('pikis/$fileName.jpeg').putFile(file);
      String htmlUrl = await _storage.ref(uploadedFile.ref.fullPath.toString()).getDownloadURL();
      return htmlUrl;
    } catch (e) {
      throw Error();
    }
  }
}
