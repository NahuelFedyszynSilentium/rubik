// ignore_for_file: empty_catches

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../data_access/dummy_data_access.dart';
import '../enums/culture.dart';
import '../interfaces/i_data_access.dart';
import '../models/login_model.dart';
import '../models/profile_model.dart';
import '../support/network/network.dart';

class DataManager {
  static final DataManager _instance = DataManager._constructor();
  SharedPreferences? prefs;
  // ignore: unused_field
  IDataAccess? _dataAccess;

  factory DataManager() {
    return _instance;
  }

  DataManager._constructor();

  init() async {
    //_dataAccess = RemoteDataAccess();
    _dataAccess = DummyDataAccess();
    prefs = await SharedPreferences.getInstance();
    try {
      getSession();
      String? token = getTokenSession();
      Network().setToken(token);
    } catch (ex) {}
  }

  //#region Preferences
  hasSession() {
    ProfileModel? profile = getProfileSession();
    String? token = getTokenSession();
    return profile != null && token != null;
  }

  LoginModel getSession() {
    try {
      String? jsonSession = prefs?.getString('session');
      LoginModel login = LoginModel.fromJson(jsonDecode(jsonSession!));

      return login;
    } catch (ex) {
      rethrow;
    }
  }

  saveProfile(ProfileModel profile) async {
    try {
      await prefs?.setString('profile', jsonEncode(profile));
    } on Exception {}
  }

  ProfileModel? getProfileSession() {
    try {
      String? jsonSession = prefs?.getString('profile');
      ProfileModel profile = ProfileModel.fromJson(jsonDecode(jsonSession!));

      return profile;
    } catch (ex) {
      return null;
    }
  }

  saveSession(LoginModel session) async {
    try {
      await prefs?.setString('session', jsonEncode(session));
    } catch (ex) {
      rethrow;
    }
  }

  saveToken(String? token) async {
    try {
      await prefs?.setString('token', token ?? "");
      Network().setToken(token);
    } on Exception {}
  }

  getTokenSession() {
    try {
      String? jsonSession = prefs?.getString('token');

      return jsonSession;
    } catch (ex) {
      //PageManager().goMaintenancePage();
    }

    return null;
  }

  saveCulture(Culture culture) async {
    try {
      await prefs?.setString('culture', jsonEncode(culture.toString()));
    } on Exception {}
  }

  getCulture() {
    try {
      if (jsonDecode(prefs?.getString('culture') ?? '') == "Culture.es") {
        return Culture.es;
      } else {
        return Culture.en;
      }
    } on Exception {
      return Culture.es;
    }
  }

  void cleanData() {
    try {
      Network().token = null;
      prefs?.remove("session");
      prefs?.remove("profile");
      prefs?.remove("token");
    } catch (e) {}
  }

  ProfileModel getToken() {
    throw UnimplementedError();
  }

  ProfileModel getProfile() {
    throw UnimplementedError();
  }

  ProfileModel getApiVersion() {
    throw UnimplementedError();
  }

  //#endregion

}
