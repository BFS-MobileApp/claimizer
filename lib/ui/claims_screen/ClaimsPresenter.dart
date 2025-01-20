import 'dart:io';
import 'dart:typed_data';
import 'package:Cliamizer/CommonUtils/image_utils.dart';
import 'package:Cliamizer/base/presenter/base_presenter.dart';
import 'package:Cliamizer/generated/l10n.dart';
import 'package:Cliamizer/network/models/UnitRequestResponse.dart';
import 'package:Cliamizer/network/models/buildings_response.dart';
import 'package:Cliamizer/network/models/categories_response.dart';
import 'package:Cliamizer/network/models/claim_available_time_response.dart';
import 'package:Cliamizer/network/models/claim_request_response.dart';
import 'package:Cliamizer/network/models/claims_response.dart';
import 'package:Cliamizer/network/models/general_response.dart';
import 'package:Cliamizer/res/colors.dart';
import 'package:Cliamizer/res/gaps.dart';
import 'package:Cliamizer/res/styles.dart';
import 'package:Cliamizer/ui/claims_screen/widgets/success_dialog.dart';
import 'package:Cliamizer/ui/home_screen/HomeProvider.dart';
import 'package:Cliamizer/ui/home_screen/HomeScreen.dart';
import 'package:Cliamizer/ui/main_screens/MainScreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../CommonUtils/model_eventbus/EventBusUtils.dart';
import '../../CommonUtils/model_eventbus/ReloadHomeEevet.dart';
import '../../CommonUtils/preference/Prefs.dart';
import '../../app_widgets/NoDataFound.dart';
import '../../network/api/network_api.dart';
import '../../network/models/claim_type_response.dart';
import '../../network/models/units_response.dart';
import '../../network/network_util.dart';
import 'claims_screen.dart';

class ClaimsPresenter extends BasePresenter<ClaimsScreenState> {

  getClaims(){
    Map<String, dynamic> params = Map();
    print('ahmeeeeeeeeeeed'+view.provider.homeFilter);
    params['search'] = view.provider.searchController.text.toString();
    if(view.provider.homeFilter!=null&&view.provider.homeFilter!='all'){
      params['status'] = view.provider.homeFilter;
    }
    print('ahmeeeeeeeeeeed'+view.provider.homeFilter);
    getAllClaimsApiCall(params);
  }


  Future getAllClaimsApiCall(Map<String, dynamic> params) async {
    print('~~~~~~~~~ called');
    Map<String, dynamic> header = Map();
    await Prefs.getUserToken.then((token) {
      header['Authorization'] = "Bearer $token";
    });
    view.showProgress(isDismiss: false);
    await requestFutureData<ClaimsResponse>(Method.get,
        queryParams: params, options: Options(headers: header), endPoint: Api.claimsApiCall, onSuccess: (data) {
          view.closeProgress();
      if (data != null) {
        print('here2');
        view.closeProgress();
        view.provider.claimsList.clear();
        view.provider.claimsList = data.data;
        print("LENGTH : ${view.provider.claimsList.length}");
      }
     getBuildingsApiCall();

    }, onError: (code, msg) {
      print('here3');
      view.closeProgress();
     getBuildingsApiCall();
    });
  }


  formatDate(String date) {
    if (date != null || date.isNotEmpty) return DateFormat('yyyy-MM-dd').format(DateTime.parse(date));
    return null;
  }

  Future completeLinkRequestApiCall(FormData bodyParams , BuildContext context) async {
    print('dodddddddddddo');
    Map<String, dynamic> header = Map();
    await Prefs.getUserToken.then((token) {
      print('token = '+token);
      header['Authorization'] = "Bearer $token";
    });
    view.showProgress(isDismiss: false);
    await requestFutureData<GeneralResponse>(Method.post,
        endPoint: Api.renewUnitLinkRequestApiCall,
        params: bodyParams,
        options: Options(headers: header), onSuccess: (data) {
          view.closeProgress();
          if (data != null) {
            if (data.status == "success") {
              view.closeProgress();
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
                      Text(S.current!.unitRenewSuccessfully,
                          style: MTextStyles.textMain18.copyWith(
                            color: MColors.black,
                          )),
                      Gaps.vGap8,
                      /*Text(
                        S.current!.OneOfOurCustomerServices,
                        style: MTextStyles.textSubtitle,
                        textAlign: TextAlign.center,
                      ),*/
                      Gaps.vGap30,
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          view.provider.selectedIndex = 0;
                          Map<String, dynamic> params = Map();
                          params['search'] = view.provider.searchController.text.toString();
                          //getUnitRequestsApiCall(params);
                          view.closeProgress();
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                              MainScreen(index: 0,)), (Route<dynamic> route) => false);
                          view.closeProgress();
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
            }
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

  Future getUnitRequestsApiCall(Map<String, dynamic> params) async {
    Map<String, dynamic> header = Map();
    await Prefs.getUserToken.then((token) {
      header['Authorization'] = "Bearer $token";
    });
    view.showProgress(isDismiss: false);
    await requestFutureData<UnitRequestsResponse>(Method.get,
        options: Options(headers: header),queryParams: params, endPoint: Api.unitRequestApiCall, onSuccess: (data) {
          view.closeProgress();
          if (data != null) {
            view.provider.unitsRequestList = data.data!;
          }
        }, onError: (code, msg) {
          view.closeProgress();
        });
  }
  Future getBuildingsApiCall() async {
    view.provider.dataLoaded = false;
    Map<String, dynamic> header = Map();
    await Prefs.getUserToken.then((token) {
      header['Authorization'] = "Bearer $token";
    });
    view.showProgress();
    await requestFutureData<BuildingsResponse>(Method.get,
        options: Options(headers: header), endPoint: Api.buildingsApiCall, onSuccess: (data) {
      view.closeProgress();
      view.provider.dataLoaded = true;
      if (data != null) {
        view.closeProgress();
        view.provider.buildingsList.clear();
        view.provider.buildingsList = data.data!;
      }
    }, onError: (code, msg) {

      view.provider.dataLoaded = true;
      view.closeProgress();
    });
    view.closeProgress();
  }

  Future getUnitsApiCall(int buildingId) async {
    view.provider.dataLoaded = false;
    Map<String, dynamic> header = Map();
    await Prefs.getUserToken.then((token) {
      header['Authorization'] = "Bearer $token";
    });
    view.provider.clearUnitsList();
    await requestFutureData<UnitsResponse>(Method.get,
        queryParams: {'building': buildingId},
        options: Options(headers: header),
        endPoint: Api.unitsApiCall, onSuccess: (data) {
      view.provider.dataLoaded = true;
      if (data != null) {
        view.provider.unitsList = data.data;
      }
    }, onError: (code, msg) {
      view.provider.dataLoaded = true;
    });
  }

  Future getCategoryApiCall(int unitId) async {
    view.provider.dataLoaded = false;
    Map<String, dynamic> header = Map();
    await Prefs.getUserToken.then((token) {
      header['Authorization'] = "Bearer $token";
    });
    view.provider.clearCategoryList();
    await requestFutureData<CategoriesResponse>(Method.get,
        queryParams: {'property_unit_id': unitId, 'per_page': 1000},
        options: Options(headers: header),
        endPoint: Api.categoriesApiCall, onSuccess: (data) {
      view.provider.dataLoaded = true;
      if (data != null) {
        view.provider.categoriesList = data.data!;
      }
    }, onError: (code, msg) {
      view.provider.dataLoaded = true;
    });
  }

  Future getClaimTypeApiCall(int subCategoryId) async {
    view.provider.dataLoaded = false;
    Map<String, dynamic> header = Map();
    await Prefs.getUserToken.then((token) {
      header['Authorization'] = "Bearer $token";
    });
    view.provider.clearTypeList();
    await requestFutureData<ClaimTypeResponse>(Method.get,
        queryParams: {'subcategory_id': subCategoryId, 'per_page': 1000},
        options: Options(headers: header),
        endPoint: Api.claimTypeApiCall, onSuccess: (data) {
      view.provider.dataLoaded = true;

      if (data != null) {
        view.provider.claimTypeList = data.data!;
      }
    }, onError: (code, msg) {
      view.provider.dataLoaded = true;
    });
  }

  Future getClaimAvailableTimeApiCall() async {
    Map<String, dynamic> header = Map();
    await Prefs.getUserToken.then((token) {
      header['Authorization'] = "Bearer $token";
    });
    view.showProgress(isDismiss: false);
    await requestFutureData<ClaimAvailableTimeResponse>(Method.get,
        queryParams: {'company_id': view.provider.companyId},
        options: Options(headers: header),
        endPoint: Api.claimAvailableTimeApiCall, onSuccess: (data) {
      view.closeProgress();
      if (data != null) {
        view.provider.claimAvailableTimeList = data.data!;
        view.provider.selectedTimeValue = (data.data!.isNotEmpty ? data.data![0].name : null)!;
      }
    }, onError: (code, msg) {
      view.closeProgress();
    });
  }

  Future postClaimRequestApiCall(dynamic formData) async {
    print('hereeeeeeeeeeee');
    Map<String, dynamic> header = Map();
    await Prefs.getUserToken.then((token) {
      header['Authorization'] = "Bearer $token";
    });
    view.showProgress(isDismiss: false);
    await requestFutureData<ClaimsRequestResponse>(Method.post,
        params: formData, options: Options(headers: header), endPoint: Api.claimsApiCall, onSuccess: (data) {
      view.closeProgress();
      if (data != null) {
        print('~~~~~~~~~~~~~~${data.id}');
        showDialog(
          context: view.context,
          barrierDismissible: false,
          builder: (context) => ClaimCreatedDialog(
            presenter: view.mPresenter,
            claimsRequestResponse: data,
          ),
        );
        view.provider.file = File('');
        view.provider.imageFiles = [];
        view.provider.description.clear();
        EventBusUtils.getInstance().fire(ReloadEvent(isRefresh: true));
      }
    }, onError: (code, msg) {
      print(msg+'doddd'+' '+code.toString());
      view.closeProgress();
      view.showToasts(msg, "error");
    });
  }
  showProgress() {
    showDialog(
      context: view.context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Container(
            height: 30.h,
            alignment: Alignment.center,
            child: Lottie.asset('assets/images/png/loading.json', width: 10.w),
          ),
        );
      },
    );
  }

  Color getClaimStatusColorFromString(String status) {
    HomeProvider homeProvider = view.context.read<HomeProvider>();
    switch (status) {
      case 'new':
      case 'جديد':
        return HexColor(homeProvider.claimStatusColors.newClaims ?? '#ff9500');
      case 'assigned':
      case 'تم اختيار فني':
      case 'renewing':
      case 'active':
        return HexColor(homeProvider.claimStatusColors.assigned ?? '#ff9500');
      case 'started':
      case 'بدأت':
        return HexColor(homeProvider.claimStatusColors.started ?? '#ff9500');
      case 'completed':
      case 'مكتمل':
        return HexColor(homeProvider.claimStatusColors.completed ?? '#ff9500');
      case 'closed':
      case 'مغلق':
        return HexColor(homeProvider.claimStatusColors.closed ?? '#ff9500');
      case 'cancelled':
      case 'ملغي':
        return HexColor(homeProvider.claimStatusColors.cancelled ?? '#ff9500');
      default:
        return Color(0xff44A4F2).withOpacity(0.08);
    }
  }

  Widget showMessage(){
    if(view.provider.claimsList.isEmpty)
      return Center(child: NoDataWidget(onRefresh: ()async{}),);
    return showProgress();
  }

  // 1. compress file and get Uint8List
  Future<Uint8List?> compressFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 720,
      minHeight: 720,
      quality: 94,
    );
    print(file.lengthSync());
    return result;
  }
}
