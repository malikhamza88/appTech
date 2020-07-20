import 'dart:collection';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_example/models/interventions_model.dart';
import 'dart:convert';

import 'package:login_example/models/users.dart';

class AuthProvider extends ChangeNotifier {
  String _token = '';
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  List<InterData> _interventions = [];
  List<InterData> get interventions => _interventions;

  Future<String> loginUser(String username, String password) async {
    final String url = "http://demo-apptech.com/Apis/Login/";
    var map = new Map<String, dynamic>();
    map['user_name'] = username;
    map['password'] = password;
    var response = await http.post(url, body: map);
    if (response.statusCode != 200) {
      return "User not exists";
    } else {
      var userData = UserData.fromJson(json.decode(response.body));
      _token = userData.data.token;
      print("Token:$_token");
      return null;
    }
  }

  Future<List<InterData>> fetchAllInterventions() async {
    final String url =
        "http://demo-apptech.com/Apis/Interventions/?token=$_token";
    var response = await http.get(url);
    var interData = Interventions.fromJson(json.decode(response.body));
    _interventions = interData.data;
    _isLoading = false;
    notifyListeners();

    return interData.data;
  }

  Future<String> UploadFile(Map<String, dynamic> data) async {
    String _apiUpload =
        "http://demo-apptech.com/Apis/Interventions/create?token=$_token";
    var head = {"Authorization": " $_token "};

    try {
      Dio dio = new Dio();
      FormData formData = new FormData.from(data);

      var response = await dio.post(_apiUpload,
          data: formData, options: Options(headers: head));
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.data);
        return response.data.toString();
      }
    } catch (e) {
      print(e);
      return '';
    }
  }

  Future<InterData> fetchInterventionById(String id) async {
    final String url =
        "http://demo-apptech.com/Apis/Interventions/?token=$_token&task_id=$id";
    var response = await http.get(url);
    var interData = InterData.fromJson(json.decode(response.body)['data']);
    return interData;
  }

  Future<void> postInterventions(Map<String, dynamic> map) async {
    final String url =
        "http://demo-apptech.com/Apis/Interventions/create?token=$_token";
    Map<String, dynamic> data = InterData(
      pce: "",
      nom: "",
      emplacement: "",
      num: "",
      rue: "",
      commune: "",
      codePostal: "",
      matriculeCompteur: "",
      anneeCompteur: "",
      situationCompteur: "",
      rRob: "",
      lRob: "",
      typeBranchement: "",
      colonneMontanteGaz: "",
      deposeCompteur: "",
      telClient: "",
      note: "",
      dateIntervention: "",
      status: "",
      horraire: "",
      typeIntervention: "",
      indexDepose: "",
      typeObturation: "",
      typeCondamnation: "",
      comment: "Test from app",
      nIntervention: "",
      signature: "",
    ).toJson();
    map['nom'] = '';
    map['date_intervention'] = '';
    map['signature'] = '';
    var response = await http.post(url, body: map);
    print(response.body);
  }
}