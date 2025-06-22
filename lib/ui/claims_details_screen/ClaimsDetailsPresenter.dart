import 'dart:io';
import 'package:Cliamizer/base/presenter/base_presenter.dart';
import 'package:Cliamizer/network/models/ClaimDetailsResponse.dart';
import 'package:Cliamizer/network/models/general_response.dart';
import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import '../../CommonUtils/log_utils.dart';
import '../../CommonUtils/model_eventbus/EventBusUtils.dart';
import '../../CommonUtils/model_eventbus/ReloadClaimsEevet.dart';
import '../../CommonUtils/model_eventbus/ReloadHomeEevet.dart';
import '../../CommonUtils/preference/Prefs.dart';
import '../../app_widgets/LoginRequiredDialog.dart';
import '../../generated/l10n.dart';
import '../../network/api/network_api.dart';
import '../../network/exception/error_status.dart';
import '../../network/network_util.dart';
import 'ClaimsDetailsScreen.dart';


class ClaimsDetailsPresenter extends BasePresenter<ClaimsDetailsScreenState> {
  getClaimDetailsDataApiCall(String id) async {
    print('yes here');
    Map<String, dynamic> header = Map();
    await Prefs.getUserToken.then((token)  {
      view.showProgress(isDismiss: false);
      header['Authorization'] = "Bearer $token";
      requestFutureData<ClaimDetailsResponse>(
        Method.get,
        endPoint: Api.getClaimDetailsApiCall(id),
        options: Options(headers: header),
        onSuccess: (data) {
          view.closeProgress();
          Log.d("${data.data!.id}");
          if (data != null) {
            view.provider.setData(data.data);
            view.provider.isDateLoaded = true;
          }
        },
        onError: (code, msg) {
          view.closeProgress();
          if (code == ErrorStatus.NOT_FOUND || code == ErrorStatus.PARSE_ERROR) {
            view.showToasts(S.of(view.context)!.noClaimFound, "error");
            Navigator.pop(view.context);
          }
          if (code == ErrorStatus.UNKNOWN_ERROR) view.provider.internetStatus = false;
          if (code == ErrorStatus.UNAUTHORIZED)
            showDialog(
                context: view.context,
                builder: (_) => LoginRequiredDialog(message: S.of(view.context)!.sessionTimeoutPleaseLogin),
                barrierDismissible: false);
          Log.d(msg);
        },
      );
    });
  }

  Future doPostCommentApiCall(dynamic bodyParams,String claimId , BuildContext ctx) async {
    view.showProgress();
    Map<String, dynamic> header = Map();
    await Prefs.getUserToken.then((token) {
      header['Authorization'] = "Bearer $token";
    });
    await requestFutureData<GeneralResponse>(Method.post,
        endPoint: Api.doAddCommentToClaimApiCall, params: bodyParams, options: Options(headers: header), onSuccess: (data) {
          view.closeProgress();
          if (data != null) {
            Log.d("onSuccess " + data.toString());
            Navigator.pop(view.context);
            view.showToasts(S.of(view.context)!.commentAdded, 'success');
            getClaimDetailsDataApiCall(claimId);
            view.provider.imageFiles = [];
            view.provider.file = File('');
            view.provider.comment.clear();
            view.closeProgress();
          } else {
            view.showToasts("Error", 'error');
          }
        }, onError: (code, msg) {
          Log.d(msg);
          view.closeProgress();
          if (code == ErrorStatus.UNAUTHORIZED) {
            showDialog(
                context: view.context,
                builder: (_) => LoginRequiredDialog(message: S.of(view.context)!.sessionTimeoutPleaseLogin),
                barrierDismissible: false);
          } else {
            view.showToasts("Error", 'error');
          }
        }
      );
  }


  Future addRateApiCall({
    required int rate,
    required String feedback,
    required String claimId,
    required BuildContext ctx,
    required String referenceId,
  }) async {
    view.showProgress();

    Map<String, dynamic> header = {};
    await Prefs.getUserToken.then((token) {
      header['Authorization'] = "Bearer $token";
    });

    Map<String, dynamic> bodyParams = {
      "rate": rate.toString(),
      "feedback": feedback,
      "claim_id": claimId,
    };

    await requestFutureData<GeneralResponse>(
      Method.post,
      endPoint: Api.doAddRatingApiCall(claimId),
      params: bodyParams,
      options: Options(headers: header),
      onSuccess: (data) {
        view.closeProgress();

        if (data != null) {
          getClaimDetailsDataApiCall(referenceId);
          Log.d("Rating Success: ${data.toString()}");
          Navigator.pop(view.context);
          view.showToasts(S.of(view.context)!.rateAdded, 'success');
        } else {
          view.showToasts("Something went wrong", 'error');
        }
      },
      onError: (code, msg) {
        Log.d("Rating Error: $msg");
        view.closeProgress();

        if (code == ErrorStatus.UNAUTHORIZED) {
          showDialog(
            context: view.context,
            builder: (_) => LoginRequiredDialog(
              message: S.of(view.context)!.sessionTimeoutPleaseLogin,
            ),
            barrierDismissible: false,
          );
        } else {
          view.showToasts("Error submitting rating", 'error');
        }
      },
    );
  }



  closeClaimApiCall(String code) async {
    Map<String, dynamic> header = Map();
    await Prefs.getUserToken.then((token)  {
      view.showProgress(isDismiss: false);
      header['Authorization'] = "Bearer $token";
      requestFutureData<GeneralResponse>(
        Method.post,
        endPoint: Api.closeClaimDetailsApiCall(code),
        options: Options(headers: header),
        onSuccess: (data)  {
          if (data != null) {
            view.closeProgress();
            Navigator.pop(view.context);
            passReloadByEventPath();
            view.showToasts(S.of(view.context)!.claimClosed, "success");
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

  void passReloadByEventPath({bool? isRefresh,}) {
    EventBus eventBus = EventBusUtils.getInstance();
    eventBus.fire(ReloadEvent(isRefresh: true));
    eventBus.fire(ReloadClaimsEvent(isRefresh:true));
  }
}
