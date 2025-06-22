import 'dart:convert';

import 'package:Cliamizer/base/presenter/base_presenter.dart';
import 'package:Cliamizer/network/models/LoginResponse.dart';
import 'package:Cliamizer/network/models/general_response.dart';
import 'package:Cliamizer/network/models/social_media_login_response.dart';
import 'package:Cliamizer/network/models/units_response.dart';
import 'package:Cliamizer/ui/main_screens/MainScreen.dart';
import 'package:Cliamizer/ui/units_screen/units_screen.dart';
import 'package:Cliamizer/ui/user/login_screen/LoginScreen.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../../CommonUtils/preference/Prefs.dart';
import '../../../generated/l10n.dart';
import '../../../network/api/network_api.dart';
import '../../../network/network_util.dart';

class LoginPresenter extends BasePresenter<LoginScreenState> {

  Future doLoginApiCall(Map<String, dynamic> bodyParams) async {
    List<String> myList = [];
    myList = await Prefs.getDeleteAccount();
    if(myList.contains(bodyParams['email'])){
      view.closeProgress();
      view.provider.setError('Account Doesn''t Exist');
    } else {
      view.showProgress(isDismiss: false);
      await requestFutureData<LoginResponse>(Method.post, endPoint: Api.loginApiCall, params: bodyParams,
          onSuccess: (data) {
            if (data != null) {
              if(data.data!.role!.contains("employee")){
                view.closeProgress();
                view.provider.setError('You Don''t Have Permission to LogIn');
              }else{
                Map<String, dynamic> exitingParams = Map();
                saveUser(data);
                sendFcmToken();
                getExistingUnitsApiCall(exitingParams);
              }

            }
          }, onError: (code, msg) {
            view.closeProgress();
            view.provider.setError(msg);
          },);
    }
  }

  Future getExistingUnitsApiCall(Map<String, dynamic> params) async {
    Map<String, dynamic> header = Map();
    await Prefs.getUserToken.then((token) {
      header['Authorization'] = "Bearer $token";
    });
    await requestFutureData<UnitsResponse>(Method.get, queryParams:params,options: Options(headers: header), endPoint: Api.unitsApiCall,
        onSuccess: (data) {
          view.closeProgress();
          if (data != null) {
            view.provider.unitsList = data.data;
            view.showToasts(S.of(view.context)!.loggedInSuccessfully,'success');
            if(data.data.isEmpty){
              Navigator.pushAndRemoveUntil(
                  view.context, CupertinoPageRoute(builder: (context) => MainScreen(index: 2,)), (route) => false);
          } else {
              Navigator.pushAndRemoveUntil(
                  view.context, CupertinoPageRoute(builder: (context) => MainScreen(index: 0,)), (route) => false);
            }
         }
        }, onError: (code, msg) {
          view.closeProgress();
        });
  }

  Future doLoginApiCallWithSocial(Map<String, dynamic> bodyParams , String socialMedial) async {
    view.showProgress(isDismiss: false);
    var url = Uri.https('claimizer.com', '/api/v2/token');
    print(bodyParams['email']);
    print(bodyParams['name']);
    var response = await http.post(url, body: {'email': bodyParams['email'], 'name':bodyParams['name']});
    if(response.statusCode == 200){
      SocialMedialLogin login = SocialMedialLogin.fromJson(jsonDecode(response.body));
      Map<String, dynamic> exitingParams = Map();
      saveSocialMediaUser(login , socialMedial);
      sendFcmToken();
      getExistingUnitsApiCall(exitingParams);
    } else {
      view.closeProgress();
      view.provider.setError('Error');
    }
  }

  Future sendFcmToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print('@@@@@!!!!!!###%%$token');
    Map<String, dynamic> header = Map();
    await Prefs.getUserToken.then((token) {
      header['Authorization'] = "Bearer $token";
    });
    await requestFutureData<GeneralResponse>(Method.post,params: {'token':token},
        options: Options(headers: header), endPoint: Api.fcmToken, onSuccess: (data) {
         print(data.message);
        }, onError: (code, msg) {
          view.closeProgress();
        });
  }

  void saveSocialMediaUser(SocialMedialLogin response , String social){
    Prefs.setCurrentUser(jsonEncode(response.toJson()));
    Prefs.setUserToken(response.token);
    Prefs.setUserName(response.user.name!);
    Prefs.setUserImage(response.user.imageUrl!);
    Prefs.setIfSocialLogin(social);
    Prefs.setIsLogin(true).then((value) => print("login status $value"));
  }

  void saveUser(LoginResponse response) async {
    Prefs.setCurrentUser(jsonEncode(response.toJson()));
    Prefs.setUserToken(response.data!.token!);
    Prefs.setUserName(response.data!.name!);
    Prefs.setIsLogin(true).then((value) => print("login status $value"));
  }
}
