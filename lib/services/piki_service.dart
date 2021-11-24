import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart' as firebase_firestore;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:geolocator/geolocator.dart';
import 'package:pikitia/locator.dart';
import 'package:pikitia/models/piki.dart';
import 'package:pikitia/services/position_service.dart';
import 'package:uuid/uuid.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class PikiService {
  PikiService() {
    _storage = firebase_storage.FirebaseStorage.instance;
    _firestore = firebase_firestore.FirebaseFirestore.instance;
    _geo = Geoflutterfire();
  }

  late firebase_storage.FirebaseStorage _storage;
  late firebase_firestore.FirebaseFirestore _firestore;
  late Geoflutterfire _geo;

  Future<void> createPiki(String filePath) async {
    String htmlUrl = await _uploadFile(filePath);
    Position currentPosition = await locator<PositionService>().getCurrentPosition();
    GeoFirePoint position = _geo.point(latitude: currentPosition.latitude, longitude: currentPosition.longitude);
    firebase_firestore.FirebaseFirestore.instance.collection('pikis').add(<String, dynamic>{
      'htmlUrl': htmlUrl,
      'position': position.data,
    });
  }

  Stream<List<Piki>> watchPikis(Position position) {
    firebase_firestore.CollectionReference collectionReference = _firestore.collection('pikis');
    GeoFirePoint center = _geo.point(latitude: position.latitude, longitude: position.longitude);
    return _geo
        .collection(collectionRef: collectionReference)
        .within(center: center, radius: 5, field: 'position')
        .distinct()
        .map((docs) {
      return docs.map((doc) {
        var htmlUrl = doc.data()!["htmlUrl"];
        var position = doc.data()!["position"]["geopoint"];
        return Piki(
          htmlUrl: htmlUrl,
          position: _geo.point(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
        );
      }).toList();
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
