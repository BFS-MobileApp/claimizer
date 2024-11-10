import 'dart:io';

import 'package:Cliamizer/base/presenter/base_presenter.dart';
import 'package:Cliamizer/network/models/NewLinkListRequestResponse.dart';
import 'package:Cliamizer/network/models/NewLinkRequestResponse.dart';
import 'package:Cliamizer/network/models/UnitRequestResponse.dart';
import 'package:Cliamizer/network/models/units_response.dart';
import 'package:Cliamizer/ui/home_screen/HomeScreen.dart';
import 'package:Cliamizer/ui/intro/IntroScreen.dart';
import 'package:Cliamizer/ui/main_screens/MainScreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../CommonUtils/image_utils.dart';
import '../../CommonUtils/preference/Prefs.dart';
import '../../generated/l10n.dart';
import '../../network/api/network_api.dart';
import '../../network/models/general_response.dart';
import '../../network/network_util.dart';
import '../../res/colors.dart';
import '../../res/gaps.dart';
import '../../res/styles.dart';
import '../home_screen/HomeProvider.dart';
import 'units_screen.dart';

class UnitPresenter extends BasePresenter<UnitsScreenState> {

  Future getExistingUnitsApiCall(Map<String, dynamic> params) async {
    Map<String, dynamic> header = Map();
    await Prefs.getUserToken.then((token) {
      header['Authorization'] = "Bearer $token";
    });
    view.showProgress(isDismiss: false);
    await requestFutureData<UnitsResponse>(Method.get, queryParams:params,options: Options(headers: header), endPoint: Api.unitsApiCall,
        onSuccess: (data) {
      view.closeProgress();
      if (data != null) {
        view.provider.unitsList = data.data;
      }
    }, onError: (code, msg) {
      view.closeProgress();
    });
  }

  Future getFilteredExistingUnitsApiCall(Map<String, dynamic> params) async {
    Map<String, dynamic> header = Map();
    await Prefs.getUserToken.then((token) {
      header['Authorization'] = "Bearer $token";
    });
    view.showProgress(isDismiss: false);
    await requestFutureData<UnitsResponse>(Method.get, options: Options(headers: header),queryParams: params, endPoint: Api.unitsApiCall,
        onSuccess: (data) {
      view.closeProgress();
      if (data != null) {
        view.provider.unitsList = data.data;
      }
    }, onError: (code, msg) {
      view.closeProgress();
    });
  }

  Future getUnitRequestsApiCall(Map<String, dynamic> params) async {
    Map<String, dynamic> header = Map();
    await Prefs.getUserToken.then((token) {
      header['Authorization'] = "Bearer $token";
    });
    view.showProgress(isDismiss: false);

    await requestFutureData<UnitRequestsResponse>(
      Method.get,
      options: Options(headers: header),
      queryParams: params,
      endPoint: Api.unitRequestApiCall,
      onSuccess: (data) {
        view.closeProgress();
        if (data != null && data.data != null) {
          data.data!.sort((a, b) {
            final dateA = DateTime.tryParse(a.createdAt ?? '') ?? DateTime(0);
            final dateB = DateTime.tryParse(b.createdAt ?? '') ?? DateTime(0);
            return dateB.compareTo(dateA); // Descending order
          });

          view.provider.unitsRequestList = data.data!;
        }
      },
      onError: (code, msg) {
        view.closeProgress();
      },
    );
  }


  Future getFilteredUnitRequestsApiCall(Map<String, dynamic> params) async {
    Map<String, dynamic> header = Map();
    await Prefs.getUserToken.then((token) {
      header['Authorization'] = "Bearer $token";
    });
    view.showProgress(isDismiss: false);
    await requestFutureData<UnitRequestsResponse>(Method.get, options: Options(headers: header),queryParams: params, endPoint: Api.unitRequestApiCall,
        onSuccess: (data) {
          view.closeProgress();
          if (data != null) {
            view.provider.unitsRequestList = data.data!;
          }
        }, onError: (code, msg) {
          view.closeProgress();
        });
  }
  checkLinkHasParams(String link) {
    Uri myUri = Uri.parse(link);
    print(myUri.queryParameters.toString());
    print(myUri.queryParameters.containsKey('contract_start'));
    bool hasContractNumber = myUri.queryParameters.containsKey('contract_no');
    bool hasStartDate = myUri.queryParameters.containsKey('contract_start');
    bool hasEndDate = myUri.queryParameters.containsKey('contract_end');
    String qrCode = myUri.queryParameters['qr_code']!;
    String contractNumber = myUri.queryParameters['contract_no']??'';
    String startDate = myUri.queryParameters['contract_start']?? '';
    String endDate = myUri.queryParameters['contract_end']??'';
    String mLink = myUri.queryParameters['m']??'';
    RegExp uPattern = RegExp('^U\\d{2}-\\d{5}-\\d');
    RegExp bPattern = RegExp('^B\\d{2}-\\d{5}-\\d');
    if (hasContractNumber && hasStartDate && hasEndDate) {
      String formattedStartDate = startDate.replaceAll('-', '');
      String formattedEndDate = endDate.replaceAll('-', '');
      view.provider.isBuilding = false;
      String mCalculated;
      mCalculated =
          ((int.parse(formattedStartDate) + int.parse(formattedEndDate)) * int.parse(contractNumber!)).toString();
      if (mCalculated == mLink) {
        doCheckUnitQrCodeApiCall({"qr_code": qrCode, "validated": true}, qrCode, contractNumber, startDate, endDate);
        view.provider.validated = true;
        view.provider.showUnitNumber = true;
      } else {
        view.showToasts(S.current!.theQrCodeIsIncorrect, "error");
        view.provider.isQrCodeValid = false;
      }
    } else if (bPattern.hasMatch(qrCode)) {
      view.provider.isBuilding = true;
      view.provider.showUnitNumber = false;
      doCheckBuildingQrCodeApiCall({"qr_code": qrCode, "validated": false}, qrCode);
    } else {
      view.provider.isBuilding = false;
      view.provider.showUnitNumber = true;
      doCheckSmallUnitQrCodeApiCall({"qr_code": qrCode, "validated": false}, qrCode, contractNumber, startDate, endDate);
      view.provider.validated = false;
    }
  }

  Future doCheckUnitQrCodeApiCall(
      Map<String, dynamic> bodyParams, String qrCode, String contractNum, String startData, String endDate) async {
    Map<String, dynamic> header = Map();
    await Prefs.getUserToken.then((token) {
      header['Authorization'] = "Bearer $token";
    });
    view.showProgress(isDismiss: false);
    await requestFutureData<NewLinkRequestResponse>(Method.post,
        endPoint: Api.newLinkRequestApiCall, params: bodyParams, options: Options(headers: header), onSuccess: (data) {
      view.closeProgress();
      if (data != null) {
        if (data.status == "success") {
          print('here');
          view.provider.newLinkRequestDataBean = data.data;
          view.provider.isQrCodeValid = !view.provider.isQrCodeValid;
          view.provider.qrCode.text = qrCode ?? '';
          view.provider.contractNo.text = contractNum ?? '';
          view.provider.startDate = DateTime.parse(startData);
          view.provider.endDate = DateTime.parse(endDate);
          view.provider.unitNumber = data.data.units!.propertyName;
          print(data.data.units!.propertyName);
          view.provider.hasStartDate = true;
          view.provider.hasEndDate = true;
          view.provider.contract = true;
        } else if (data.status == "fail") {
          view.provider.message = data.data.message;
        }
      }
    }, onError: (code, msg) {
      view.closeProgress();
      if (code == 404) {
        view.provider.message = S.current!.theQrCodeIsIncorrect;
      }
      if (code == 422) {
        view.showToasts(S.current!.anErrorOccurredTryAgainLater, 'error');
      }
    });
  }

  Future doCheckSmallUnitQrCodeApiCall(
      Map<String, dynamic> bodyParams, String qrCode, String contractNum, String startData, String endDate) async {
    Map<String, dynamic> header = Map();
    await Prefs.getUserToken.then((token) {
      header['Authorization'] = "Bearer $token";
    });
    view.showProgress(isDismiss: false);
    await requestFutureData<NewLinkRequestResponse>(Method.post,
        endPoint: Api.newLinkRequestApiCall, params: bodyParams, options: Options(headers: header), onSuccess: (data) {
          view.closeProgress();
          if (data != null) {
            if (data.status == "success") {
              print('here');
              view.provider.newLinkRequestDataBean = data.data;
              view.provider.isQrCodeValid = !view.provider.isQrCodeValid;
              view.provider.qrCode.text = qrCode ?? '';
              view.provider.contractNo.text = contractNum ?? '';
              view.provider.hasStartDate = false;
              view.provider.hasEndDate = false;
              view.provider.unitNumber = data.data.units!.propertyName;
              print(data.data.units!.propertyName);
              view.provider.contract = false;
            } else if (data.status == "fail") {
              view.provider.message = data.data.message;
            }
          }
        }, onError: (code, msg) {
          view.closeProgress();
          if (code == 404) {
            view.provider.message = S.current!.theQrCodeIsIncorrect;
          }

          if (code == 422) {
            view.showToasts(S.current!.anErrorOccurredTryAgainLater, 'error');
          }
        });
  }

  Future doCheckBuildingQrCodeApiCall(
    Map<String, dynamic> bodyParams,
    String qrCode,
  ) async {
    Map<String, dynamic> header = Map();
    await Prefs.getUserToken.then((token) {
      header['Authorization'] = "Bearer $token";
    });
    view.showProgress(isDismiss: false);
    await requestFutureData<NewLinkListRequestResponse>(Method.post,
        endPoint: Api.newLinkRequestApiCall, params: bodyParams, options: Options(headers: header), onSuccess: (data) {
      view.closeProgress();
      if (data != null) {
        if (data.status == "success") {
          view.provider.buildingUnitsList = data.data!.units!;
          view.provider.linkListRequestDataBean = data.data!;
          view.provider.isQrCodeValid = !view.provider.isQrCodeValid;
          view.provider.qrCode.text = qrCode ?? '';
          view.provider.hasStartDate = false;
          view.provider.hasEndDate = false;

          print(data.data!.units![0].propertyName);
        } else if (data.status == "fail") {
          view.provider.message = data.status;
        }
      }
    }, onError: (code, msg) {
      view.closeProgress();
      if (code == 404) {
        view.provider.message = S.current!.theQrCodeIsIncorrect;
      }

      if (code == 422) {
        view.showToasts(S.current!.anErrorOccurredTryAgainLater, 'error');
      }
    });
  }

  Future completeLinkRequestApiCall(FormData bodyParams , BuildContext context) async {
    Map<String, dynamic> header = Map();
    await Prefs.getUserToken.then((token) {
      header['Authorization'] = "Bearer $token";
    });
    view.showProgress(isDismiss: false);
    await requestFutureData<GeneralResponse>(Method.post,
        endPoint: Api.completeLinkRequestApiCall,
        params: bodyParams,
        options: Options(headers: header), onSuccess: (data) {
      view.closeProgress();
      if (data != null) {
        if (data.status == "success") {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              MainScreen(index: 0,)), (Route<dynamic> route) => false);
          showDialog(
            context: view.context,
            builder: (context) => AlertDialog(
              insetPadding: EdgeInsets.all(20),
              contentPadding: EdgeInsets.all(16),
              backgroundColor: MColors.whiteE,
              elevation: 0,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(ImageUtils.getSVGPath("done")),
                  Gaps.vGap16,
                  Text(
                    S.current!.linkRequestSubmittedSuccessfully,
                    style: MTextStyles.textMain18,
                    textAlign: TextAlign.center,
                  ),
                  Gaps.vGap30,
                  ElevatedButton(
                    onPressed: () {
                      view.provider.isQrCodeValid = !view.provider.isQrCodeValid;
                      view.provider.qrCode.clear();
                      view.provider.contractNo.clear();
                      view.provider.companyName.clear();
                      view.provider.buildingName.clear();
                      view.provider.description.clear();
                      view.provider.startDate = DateTime.now();
                      view.provider.endDate = DateTime.now();
                      view.provider.identityImg = File('');
                      view.provider.contractImg = File('');
                      view.provider.contractFiles = [];
                      view.provider.identityFiles = [];
                      view.provider.qrCodeValid = false;
                      view.provider.hasStartDate = false;
                      view.provider.hasEndDate = false;
                      Navigator.pop(context);
                      view.provider.selectedIndex = 2;
                      Map<String, dynamic> params = Map();
                      params['search'] = view.provider.searchController.text.toString();
                      getUnitRequestsApiCall(params);
                    },
                    child: Text(
                      S.current!.backToHome,
                      style: MTextStyles.textWhite14.copyWith(fontWeight: FontWeight.w700),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(MColors.primary_color),
                        elevation: MaterialStatePropertyAll(0),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.w))),
                  )
                ],
              ),
            ),
          );
          view.provider.selectedUnit = '';
        } else if (data.status == "fail") {
          view.showToasts(data.message!, 'error');
        } /*else {
          view.showToasts(data.message!, 'error');
        }*/
      }
    }, onError: (code, msg) {
      view.closeProgress();
      if (code == 422) {
        view.showToasts(S.current!.anErrorOccurredTryAgainLater, 'warning');
      } else {
        view.showToasts(S.current!.anErrorOccurredTryAgainLater, 'error');
      }
    });
  }

  Color getUnitStatusColorFromString(String status) {
    HomeProvider homeProvider = view.context.read<HomeProvider>();
    switch (status) {
      case 'new':
      case 'جديد':
        return HexColor(homeProvider.claimStatusColors.newClaims ?? '#ff9500');
      case 'assigned':
      case 'تم اختيار فني':
      case 'renewing':
      case 'renewed':
      case 'مجدد':
        return HexColor(homeProvider.claimStatusColors.assigned ?? '#ff9500');
      case 'منتهي':
      case 'finished':
        return HexColor(homeProvider.claimStatusColors.started ?? '#ff9500');
      case 'completed':
      case 'approved':
      case 'موافق عليه':
      case 'مكتمل':
        return HexColor(homeProvider.claimStatusColors.completed ?? '#ff9500');
      case 'closed':
      case 'مغلق':
        return HexColor(homeProvider.claimStatusColors.closed ?? '#ff9500');
      case 'cancelled':
      case 'canceled':
      case 'rejected':
      case 'ملغي':
      case 'مرفوض':
        return HexColor(homeProvider.claimStatusColors.cancelled ?? '#ff9500');
      default:
        return Color(0xff44A4F2).withOpacity(0.08);
    }
  }
}
