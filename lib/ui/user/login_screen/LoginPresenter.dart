import 'dart:convert';

import 'package:Cliamizer/base/presenter/base_presenter.dart';
import 'package:Cliamizer/network/models/LoginResponse.dart';
import 'package:Cliamizer/network/models/general_response.dart';
import 'package:Cliamizer/network/models/social_media_login_response.dart';
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
            view.closeProgress();
            if (data != null) {
              view.showToasts(S.of(view.context)!.loggedInSuccessfully,'success');
              Navigator.pushAndRemoveUntil(
                  view.context, CupertinoPageRoute(builder: (context) => MainScreen(index: 0,)), (route) => false);
              saveUser(data);
              sendFcmToken();
            }
          }, onError: (code, msg) {
            view.closeProgress();
            view.provider.setError(msg);
          },);
    }
  }

  Future doLoginApiCallWithSocial(Map<String, dynamic> bodyParams , String socialMedial) async {
    view.showProgress(isDismiss: false);
    var url = Uri.https('claimizer.com', '/api/v2/token');
    var response = await http.post(url, body: {'email': bodyParams['email'], 'name':bodyParams['name']});
    if(response.statusCode == 200){
      view.closeProgress();
      view.showToasts(S.of(view.context)!.loggedInSuccessfully,'success');
      SocialMedialLogin login = SocialMedialLogin.fromJson(jsonDecode(response.body));
      Navigator.pushAndRemoveUntil(
          view.context, CupertinoPageRoute(builder: (context) => UnitsScreen()), (route) => false);
      saveSocialMediaUser(login , socialMedial);
      sendFcmToken();
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
