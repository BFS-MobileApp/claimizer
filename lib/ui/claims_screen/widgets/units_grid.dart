import 'package:Cliamizer/CommonUtils/renew_model.dart';
import 'package:Cliamizer/network/models/units_response.dart';
import 'package:Cliamizer/res/gaps.dart';
import 'package:Cliamizer/res/styles.dart';
import 'package:Cliamizer/ui/claims_screen/ClaimsPresenter.dart';
import 'package:Cliamizer/ui/claims_screen/ClaimsProvider.dart';
import 'package:Cliamizer/ui/claims_screen/widgets/building_name.dart';
import 'package:Cliamizer/ui/claims_screen/widgets/claims_loading.dart';
import 'package:Cliamizer/ui/claims_screen/widgets/company_name.dart';
import 'package:Cliamizer/ui/claims_screen/widgets/contract_number.dart';
import 'package:Cliamizer/ui/claims_screen/widgets/date_item.dart';
import 'package:Cliamizer/ui/claims_screen/widgets/description_name.dart';
import 'package:Cliamizer/ui/claims_screen/widgets/image_picker.dart';
import 'package:Cliamizer/ui/claims_screen/widgets/unit_number.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../app_widgets/NoDataFoundGrid.dart';
import '../../../app_widgets/app_headline.dart';
import '../../../generated/l10n.dart';
import '../../../res/colors.dart';

class UnitsGrid extends StatelessWidget {
  const UnitsGrid(
      {Key? key,
        required this.onSelected,
        required this.presenter,
        required this.id})
      : super(key: key);
  final ClaimsPresenter presenter;
  final Function(int) onSelected;
  final int id;

  void setDate(RenewModel renewModel, UnitsDataBean unit) {
    if (unit.endAt != '') {
      renewModel.startDate = unit.endAt!;
      DateTime endDate = DateTime.parse(renewModel.startDate);
      endDate = DateTime(endDate.year + 1, endDate.month, endDate.day);
      renewModel.endDate = endDate.toString();
    }
  }

  void showConfirmDialog(BuildContext context, UnitsDataBean unit) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(20),
            contentPadding: EdgeInsets.all(24),
            title: Text(
              S.current!.confirmRenewDialog,
              style: MTextStyles.textBoldDark14,
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  showRenewDialog(context, unit);
                },
                child: Text(
                  S.of(context)!.renew,
                  style: MTextStyles.textWhite14
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(MColors.primary_color),
                  elevation: const MaterialStatePropertyAll(0),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      )),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  S.of(context)!.cancel,
                  style: MTextStyles.textWhite14.copyWith(
                      fontWeight: FontWeight.w700,
                      color: MColors.primary_color),
                ),
              ),
            ],
            content: Text(
              S.of(context)!.areYouSureToRenewThisUnit,
              style: MTextStyles.textMainLight14,
            ),
          );
        });
  }

  void showRenewDialog(BuildContext context, UnitsDataBean unit) {
    RenewModel model = RenewModel();
    final DateFormat _dateFormat = DateFormat('yyyy-MM-dd', "en");
    setDate(model, unit);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(20),
          contentPadding: EdgeInsets.all(24),
          title: Text(
            S.current!.confirmRenewDialog,
            style: MTextStyles.textBoldDark14,
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (model.getContractNumber == '' ||
                    model.startDate == ' ' ||
                    model.endDate == '') {
                  presenter.view
                      .showToasts(S.of(context)!.enterAllData, 'error');
                } else if (_dateFormat
                    .parse(model.startDate)
                    .isAfter(_dateFormat.parse(model.endDate))) {
                  presenter.view
                      .showToasts(S.of(context)!.dateErrorMessage, 'error');
                } else if (model.contractNo != '' &&
                    model.startDate != '' &&
                    model.endDate != '') {
                  if (model.contractImage.path != '' ||
                      model.identifyImage.path != '') {
                    FormData formData = FormData.fromMap({
                      "contract_attach": await MultipartFile.fromFile(
                        model.contractImage.path,
                        contentType:
                        MediaType('application', 'octet-stream'),
                      ),
                      "client_gov_id": await MultipartFile.fromFile(
                        model.identifyImage.path,
                        contentType:
                        MediaType('application', 'octet-stream'),
                      ),
                      "id": unit.requestId,
                      "contract_no": model.getContractNumber,
                      "end_at": model.endDate,
                      "note": model.getDescription,
                    });
                    Navigator.pop(context);
                    presenter.completeLinkRequestApiCall(formData, context);
                  } else {
                    FormData formData = FormData.fromMap({
                      "id": unit.requestId,
                      "contract_no": model.getContractNumber,
                      "end_at": model.endDate,
                      "note": model.getDescription,
                    });
                    Navigator.pop(context);
                    presenter.completeLinkRequestApiCall(formData, context);
                  }
                } else {
                  Navigator.pop(context);
                  presenter.view
                      .showToasts(S.of(context)!.enterAllData, 'error');
                }
              },
              child: Text(
                S.of(context)!.renew,
                style: MTextStyles.textWhite14
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all<Color>(MColors.primary_color),
                elevation: const MaterialStatePropertyAll(0),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                S.of(context)!.cancel,
                style: MTextStyles.textWhite14.copyWith(
                  fontWeight: FontWeight.w700,
                  color: MColors.primary_color,
                ),
              ),
            ),
          ],
          content: SizedBox(
            width: double.maxFinite,
            height: 140.0.w,
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(S.current!.newLinkRequest,
                        style: MTextStyles.textMain18),
                  ],
                ),
                Gaps.vGap8,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 1.w,
                      height: 5.w,
                      margin: EdgeInsetsDirectional.only(end: 3.w),
                      decoration: BoxDecoration(
                        color: MColors.primary_color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Text(S.current!.contractQuery,
                        style: MTextStyles.textMain16),
                  ],
                ),
                Gaps.vGap8,
                CompanyName(name: unit.company),
                Gaps.vGap8,
                BuildingName(name: unit.building),
                Gaps.vGap8,
                UnitNumber(name: unit.name),
                Gaps.vGap8,
                DateItem(model: model),
                Gaps.vGap8,
                ContractNumber(
                  readOnly: false,
                  controller: model.contractNo,
                ),
                Gaps.vGap8,
                ImagePickerWidget(
                  model: model,
                  itemName: S.of(context)!.uploadContractImage,
                  isContractImage: true,
                ),
                Gaps.vGap8,
                ImagePickerWidget(
                  model: model,
                  itemName: S.of(context)!.uploadIdentityImage,
                  isContractImage: false,
                ),
                Gaps.vGap8,
                DescriptionField(controller: model.descriptionController),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClaimsProvider>(
      builder: (ctx, pr, w) {
        // ✅ Filter available units only
        final availableUnits =
        pr.unitsList.where((u) => u.available == true).toList();

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppHeadline(title: S.of(context)!.selectUnit),
            availableUnits.isNotEmpty
                ? GridView.builder(
              itemCount: availableUnits.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    pr.selectedUnitIndex = index;
                    pr.companyId = availableUnits[index].companyId;
                    onSelected(availableUnits[index].id);
                    pr.selectedUnit = availableUnits[index].name;
                    pr.currentStep < 3 ? pr.currentStep += 1 : null;
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: pr.selectedUnitIndex == index
                          ? MColors.primary_color
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: MColors.dividerColor.withOpacity(.6),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 2.h),
                        Text(
                          availableUnits[index].name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: pr.selectedUnitIndex == index
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
                : pr.dataLoaded
                ? NoDataWidgetGrid(
              onRefresh: () async {
                presenter.getUnitsApiCall(id);
              },
            )
                : const ClaimsLoading(),
          ],
        );
      },
    );
  }
}
