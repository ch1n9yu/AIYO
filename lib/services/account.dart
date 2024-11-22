import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aiyo11/component/bmi.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:io';

class AccountServices {
  static final firestore = FirebaseFirestore.instance;
  static final store = FirebaseStorage.instance;
  static final auth = FirebaseAuth.instance;

  String? get email => auth.currentUser?.email;
  Map<String, dynamic> _account = {};
  Map<String, dynamic> _bmiDatas = {};
  List<dynamic> heights = [];
  List<dynamic> weights = [];
  List<dynamic> dates = [];
  List<dynamic> ids = [];
  List<BMI> bmis = [];

  Map<String, dynamic> get account => _account;
  Map<String, dynamic> get bmiDatas => _bmiDatas;

  Future<void> fetchAccounts() async {
    if (email == null) return;
    final userDoc = await firestore.collection('users').doc(email).get();
    _account = userDoc.data() ?? {};

    final bmiDoc = await firestore.collection('BMIs').doc(email).get();
    _bmiDatas = bmiDoc.data() ?? {};

    heights = _bmiDatas['heights'] ?? [];
    weights = _bmiDatas['weights'] ?? [];
    dates = _bmiDatas['dates'] ?? [];
    ids = _bmiDatas['ids'] ?? [];
    print(_account);
    print(_bmiDatas);
  }

  List<BMI> takeBMIs() {
    bmis.clear();
    for (int i = 0; i < heights.length; i++) {
      bmis.add(
        BMI(
          date: dates[i].toDate(),
          id: i + 1,
          height: double.parse(heights[i].toString()),
          weight: double.parse(weights[i].toString()),
        ),
      );
    }
    return bmis;
  }

  List<FlSpot> takeSpot() {
    return bmis.map((bmi) {
      final month = bmi.date.month;
      final day = bmi.date.day;
      final x = month + (day / 31) - 1;
      final y = double.parse(bmi.calculateBmi().toStringAsFixed(2));
      return FlSpot(x, y);
    }).toList();
  }

  Future<void> uploadUserPhoto(XFile file) async {
    if (email == null) return;
    print(email);
    await store.ref('image/$email.png').putFile(File(file.path));
  }

  Future<XFile> getUserPhoto(XFile dePhoto) async {
    if (email == null) return dePhoto;
    final data = await store.ref('image/$email.png').getData();
    return data != null ? XFile.fromData(data) : dePhoto;
  }

  void signIn(String email, String password) {
    auth.signInWithEmailAndPassword(email: email, password: password);
  }

  void logOut() {
    auth.signOut();
  }
}
