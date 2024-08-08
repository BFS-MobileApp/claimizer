import 'dart:convert';

import 'package:Cliamizer/base/presenter/base_presenter.dart';
import 'package:Cliamizer/network/models/emergency_model.dart';
import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import '../../CommonUtils/log_utils.dart';
import '../../CommonUtils/model_eventbus/EventBusUtils.dart';
import '../../CommonUtils/model_eventbus/ReloadHomeEevet.dart';
import '../../CommonUtils/preference/Prefs.dart';
import '../../app_widgets/LoginRequiredDialog.dart';
import '../../generated/l10n.dart';
import '../../network/api/network_api.dart';
import '../../network/exception/error_status.dart';
import '../../network/models/ProfileResponse.dart';
import '../../network/network_util.dart';
import 'MoreScreen.dart';
import 'package:http/http.dart' as http;

class MorePresenter extends BasePresenter<MoreScreenState> {

  getProfileData() async {
    Map<String, dynamic> header = Map();
    await Prefs.getUserToken.then((token)  {
      view.showProgress(isDismiss: false);
      header['Authorization'] = "Bearer $token";
      requestFutureData<ProfileResponse>(
        Method.get,
        endPoint: Api.profileApiCall,
        options: Options(headers: header),
        onSuccess: (data)  {
          if (data != null) {
            view.provider.setData(data.profileDataBean);
            view.provider.isDateLoaded = true;
            test();
            view.closeProgress();
          }else{
            view.closeProgress();
          }
        },
        onError: (code, msg) {
          Log.d(msg);
          if(code == ErrorStatus.UNKNOWN_ERROR)
            view.provider.internetStatus = false;
          view.closeProgress();
          if(code == ErrorStatus.UNAUTHORIZED)
            showDialog( context: view.context,builder: (_)=>
                LoginRequiredDialog( message: S.of(view.context)!.sessionTimeoutPleaseLogin),barrierDismissible: false);
        },
      );
    });
  }

  Future<void> test() async {
    var url = Uri.parse('https://claimizer.com/api/v2/emergency-contact');
    Map<String, String> header = {};
    try {
      await Prefs.getUserToken.then((token) {
        header['Authorization'] = "Bearer $token";
        print('hereeeeeeeeeeeeeee1'+header.toString());
      });
      print('hereeeeeeeeeeeeeee2');
      var response = await http.get(url , headers: header);
      print('hereeeeeeeeeeeeeee3');
      if (response.statusCode == 200) {
        print('hereeeeeeeeeeeeeee4');
        Map<String, dynamic> jsonResponse = await jsonDecode(response.body);
        EmergencyModel emergencyModel = await EmergencyModel.fromJson(jsonResponse);
        view.provider.companiesList = await emergencyModel.data.companies;
        view.provider.availableFromDate = await emergencyModel.data.companies[0].availableFrom;
        view.provider.availableToDate = await emergencyModel.data.companies[0].availableTo;
        if (emergencyModel.data.companies.isNotEmpty) {
          print('hiiiiiiiiiiii ' + emergencyModel.data.companies[0].company);
          print('hiiiiiiiiiiii ' + emergencyModel.data.companies[0].availableFrom);
        } else {
          print('emptyyyyyy');
        }
      } else {
        print('hereeeeeeeeeeeeeee5');
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future getFilteredUnitRequestsApiCall() async {
    Map<String, dynamic> header = Map();
    await Prefs.getUserToken.then((token) {
      header['Authorization'] = "Bearer $token";
    });
    view.showProgress(isDismiss: false);
    await requestFutureData<EmergencyModel>(Method.get, options: Options(headers: header), endPoint: Api.emergency,
        onSuccess: (data) {
          print('errrrrrrrrrrror');
          view.closeProgress();
          if (data != null) {
            view.provider.companiesList = data.data.companies;
            if(data.data.companies.isNotEmpty){
              print('hiiiiiiiiiiii'+data.data.companies[0].company);
            } else {
              print('emptyyyyyy');
            }
          }
        }, onError: (code, msg) {
          print('errrrrrrrrrrror1');
          view.closeProgress();
        });
  }


  getEmergencyNumber() async {
    Map<String, dynamic> header = Map();
    await Prefs.getUserToken.then((token)  async {
      //view.showProgress(isDismiss: false);
      header['Authorization'] = "Bearer $token";
      if(token != null){
        print('sdasdasdasd'+token);
      }
       await requestFutureData<EmergencyModel>(
        Method.get,
        endPoint: Api.emergency,
        options: Options(headers: header),
        onSuccess: (data)  {
          if (data != null) {
            view.provider.companiesList = data.data.companies;
            if(data.data.companies.isNotEmpty){
              print('hiiiiiiiiiiii'+data.data.companies[0].company);
            } else {
              print('emptyyyyyy');
            }
            view.closeProgress();
          }else{
            view.closeProgress();
          }
        },
        onError: (code, msg) {
          Log.d(msg);
          if(code == ErrorStatus.UNKNOWN_ERROR)
            view.provider.internetStatus = false;
          //view.closeProgress();
          if(code == ErrorStatus.UNAUTHORIZED)
            showDialog( context: view.context,builder: (_)=>
                LoginRequiredDialog( message: S.of(view.context)!.sessionTimeoutPleaseLogin),barrierDismissible: false);
        },
      );
    });
  }

  showProgress(){
    WillPopScope(
      onWillPop: () async => false,
      child: Container(
        height: 30.h,
        alignment: Alignment.center,
        child: Lottie.asset('assets/images/png/loading.json', width: 10.w),
      ),
    );
  }

  void passReloadByEventPath({bool? isLangChanged}) {
    EventBus eventBus = EventBusUtils.getInstance();
    eventBus.fire(ReloadEvent(isLangChanged: true));
  }

}
