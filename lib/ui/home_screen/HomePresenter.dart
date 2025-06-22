import 'dart:convert';

import 'package:Cliamizer/CommonUtils/preference/Prefs.dart';
import 'package:Cliamizer/base/presenter/base_presenter.dart';
import 'package:Cliamizer/network/models/emergency_model.dart';
import 'package:Cliamizer/ui/home_screen/HomeScreen.dart';
import 'package:Cliamizer/ui/more_screen/MorePresenter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../CommonUtils/log_utils.dart';
import '../../app_widgets/LoginRequiredDialog.dart';
import '../../generated/l10n.dart';
import '../../network/api/network_api.dart';
import '../../network/exception/error_status.dart';
import '../../network/models/ProfileResponse.dart';
import '../../network/models/StatisticsResponse.dart';
import '../../network/network_util.dart';
import 'package:http/http.dart' as http;

class HomePresenter extends BasePresenter<HomeScreenState> {

  final MorePresenter morePresenter = MorePresenter();
  void getUserName() async {
    await Prefs.getUserName.then((value) {
      view.provider.name = value;
    });
  }

  void getUserImage() async {
    await Prefs.getUserImage.then((value) {
      view.provider.avatar = value;
      print("Event received: ${value}");
    });
  }

  Future<void> test() async {
    var url = Uri.parse('https://api.claimizer.com/tenant/emergency-contact');
    String token = '';
    String lang = '';
    Map<String, String> header = {};
    try {
      await Prefs.getUserToken.then((value) {
        token = value;
        //header['Authorization'] = "Bearer $token";
      });
      await Prefs.getAppLocal.then((value) {
        lang = value;
        print(value);
      });
      header = {
        'Authorization':'Bearer $token',
        'lang':lang,
      };
      var response = await http.get(url , headers: header);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = await jsonDecode(response.body);
        EmergencyModel emergencyModel = await EmergencyModel.fromJson(jsonResponse);
        view.provider.companiesList = await emergencyModel.data.companies;
        view.provider.availableFromDate = await emergencyModel.data.companies[0].availableFrom;
        view.provider.availableToDate = await emergencyModel.data.companies[0].availableTo;
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future getStatisticsApiCall({bool isUpdateData = false}) async {
    Map<String, dynamic> header = Map();
    await Prefs.getUserToken.then((token) {
      header['Authorization'] = "Bearer $token";
    });
    if (!isUpdateData) view.showProgress(isDismiss: false);
    await requestFutureData<StatisticsResponse>(Method.get,
        options: Options(headers: header), endPoint: Api.statisticsApiCall, onSuccess: (data) {
      if (!isUpdateData) view.closeProgress();
      if (data != null) {
        print('~~~~~~~~~~~~~updated');
        view.provider.claimsStatistics.clear();
        view.provider.rememberThatList = data.data!.aboutToExpireUnits!;
        view.provider.claimStatusColors = data.data!.claimColor!;
        view.provider.claimsStatistics.add(data.data!.claims!.all.toString());
        view.provider.claimsStatistics.add(data.data!.claims!.newClaims.toString());
        view.provider.claimsStatistics.add(data.data!.claims!.assigned.toString());
        view.provider.claimsStatistics.add(data.data!.claims!.inProgress.toString());
        view.provider.claimsStatistics.add(data.data!.claims!.completed.toString());
        view.provider.claimsStatistics.add(data.data!.claims!.cancelled.toString());
        view.provider.claimsStatistics.add(data.data!.claims!.closed.toString());
        getProfileData();
      }
    }, onError: (code, msg) {
      view.closeProgress();
      if (code == 401) {
        //return "error";
      }
    });
  }
  getProfileData() async {
    Map<String, dynamic> header = Map();
    await Prefs.getUserToken.then((token)  {
      view.showProgress(isDismiss: false);
      header['Authorization'] = "Bearer $token";
      requestFutureData<ProfileResponse>(
        Method.get,
        endPoint: Api.profileApiCall,
        options: Options(headers: header),
        onSuccess: (data)  async {
          if (data != null) {
            view.provider.setData(data.profileDataBean);
            view.provider.isDateLoaded = true;
            view.closeProgress();
            // print("#####################" + data.profileDataBean!.avatar);
            Prefs.setUserImage(data.profileDataBean!.avatar);
            getUserImage();
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


  List<String> statusList = [
    'all',
    'new',
    'assigned',
    'started',
    'completed',
    'cancelled',
    'closed',
  ];
}
