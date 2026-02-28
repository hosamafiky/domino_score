import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreRefs {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get players => _firestore.collection('players');
  CollectionReference<Map<String, dynamic>> get teams => _firestore.collection('teams');
  CollectionReference<Map<String, dynamic>> get settings => _firestore.collection('settings');
  CollectionReference<Map<String, dynamic>> get sessions => _firestore.collection('sessions');
  CollectionReference<Map<String, dynamic>> get matches => _firestore.collection('matches');
  CollectionReference<Map<String, dynamic>> get rounds => _firestore.collection('rounds');
  CollectionReference<Map<String, dynamic>> get devices => _firestore.collection('devices');

  DocumentReference<Map<String, dynamic>> get globalSettings => _firestore.collection('settings').doc('global');

  DocumentReference<Map<String, dynamic>> player(String id) => players.doc(id);
  DocumentReference<Map<String, dynamic>> team(String id) => teams.doc(id);
  DocumentReference<Map<String, dynamic>> session(String id) => sessions.doc(id);
  DocumentReference<Map<String, dynamic>> match(String id) => matches.doc(id);
  DocumentReference<Map<String, dynamic>> round(String id) => rounds.doc(id);
  DocumentReference<Map<String, dynamic>> device(String id) => devices.doc(id);
}
