import 'dart:io';

import 'package:Cliamizer/ui/home_screen/HomeScreen.dart';
import 'package:Cliamizer/ui/units_screen/units_presenter.dart';
import 'package:Cliamizer/ui/units_screen/units_provider.dart';
import 'package:Cliamizer/ui/units_screen/widgets/build_description_field.dart';
import 'package:Cliamizer/ui/units_screen/widgets/build_contract_file_picker.dart';
import 'package:Cliamizer/ui/units_screen/widgets/unit_name_field.dart';
import 'package:Cliamizer/ui/units_screen/widgets/unit_number_item.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../generated/l10n.dart';
import '../../../res/colors.dart';
import '../../../res/gaps.dart';
import '../../../res/styles.dart';
import 'build_building_units_dropdown.dart';
import 'build_identity_file_picker.dart';
import 'build_start_end_date_picker_fields.dart';
import 'building_name_field.dart';
import 'company_name_field.dart';
import 'contract_number_field.dart';

class CompleteNewUnit extends StatelessWidget {
  const CompleteNewUnit({Key? key,required this.provider,required this.presenter}) : super(key: key);
  final UnitProvider provider;
  final UnitPresenter presenter;


  @override
  Widget build(BuildContext context) {
    print('Complete');
    return Consumer<UnitProvider>(
      builder: (context, pr, child) => Container(
        padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 4.w),
        margin: EdgeInsets.symmetric(vertical: 2.w),
        decoration: BoxDecoration(color: MColors.white, borderRadius: BorderRadius.circular(8)),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(S.current!.newLinkRequest, style: MTextStyles.textMain18),
              ],
            ),
            Gaps.vGap8,
            Gaps.vGap8,
            Gaps.vGap8,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 1.w,
                  height: 5.w,
                  margin: EdgeInsetsDirectional.only(end: 3.w),
                  decoration: BoxDecoration(color: MColors.primary_color, borderRadius: BorderRadius.circular(4)),
                ),
                Text(pr.isBuilding ? "Building Query" : S.current!.unitQuery, style: MTextStyles.textMain16),
              ],
            ),
            Gaps.vGap8,
            CompanyNameField(
              provider: provider,
            ),
            Gaps.vGap8,
            BuildingNameField(
              provider: provider,
            ),
            /*Gaps.vGap8,
            
            UnitNameField(
              provider: provider,
            ),*/
            Gaps.vGap8,
            Visibility(visible: pr.isBuilding, child: BuildBuildingUnitDropDown()),
            Gaps.vGap8,
            ContractField(
              provider: provider,
            ),
            pr.isContract ? Column(
              children: [
                Gaps.vGap8,
                UnitNumberItem(
                  provider: provider,
                )
              ],
            ) : const SizedBox(),
            Gaps.vGap8,
            StartEndDatePickerField(
              provider: provider,
            ),
            Gaps.vGap8,
            BuildContractFilePicker(provider: provider),
            Gaps.vGap8,
            BuildIdentityFilePicker(provider: provider),
            Gaps.vGap8,
            BuildDescriptionField(
              provider: provider,
            ),
            Gaps.vGap8,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * .4,
                  margin: EdgeInsets.symmetric(vertical: 3.w),
                  child: ElevatedButton(
                    onPressed: () {
                      pr.isQrCodeValid = !pr.isQrCodeValid;
                      pr.contractNo.clear();
                      pr.companyName.clear();
                      pr.buildingName.clear();
                      pr.description.clear();
                      pr.startDate = DateTime.now();
                      pr.endDate = DateTime.now();
                      pr.identityImg = File('');
                      pr.contractImg = File('');
                      pr.contractFiles = [];
                      pr.identityFiles = [];
                    },
                    child: Text(
                      S.of(context)!.back,
                      style: MTextStyles.textMain14.copyWith(fontWeight: FontWeight.w700),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(MColors.white),
                        elevation: MaterialStatePropertyAll(0),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), side: BorderSide(color: MColors.primary_color))),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.w))),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .4,
                  margin: EdgeInsets.symmetric(vertical: 3.w),
                  child: ElevatedButton(
                    onPressed: () async {
                      print('here1');
                      print(pr.selectedUnit);
                      if (pr.contractNo.text.isEmpty && !pr.isHasStartDate && !pr.isHasEndDate) {
                        print('dodo');
                        presenter.view.showToasts(S.of(context)!.enterAllData, 'error');
                      } else if(pr.endDate.isBefore(pr.startDate)){
                        presenter.view.showToasts(S.of(context)!.dateErrorMessage, 'error');
                      } else if(pr.contractNo.text.isNotEmpty && pr.isHasStartDate && pr.isHasEndDate){
                        print('dodo1');
                       if (pr.contractImg.path != '' ||
                          pr.identityImg.path != '') {
                         print('dodo2');
                        FormData formData = new FormData.fromMap({
                          "contract_attach": await MultipartFile.fromFile(
                            pr.contractImg.path,
                            contentType: new  MediaType('application', 'octet-stream'),
                          ),
                          "client_gov_id": await MultipartFile.fromFile(
                            pr.identityImg.path,
                            contentType: new  MediaType('application', 'octet-stream'),
                          ),
                          "unit_code": pr.isBuilding ? pr.selectedUnit : pr.qrCode.text,
                          "contract_number": pr.contractNo.text,
                          "start_at": pr.startDate.toString(),
                          "end_at": pr.endDate.toString(),
                          "request_remarks": pr.description.text,
                        });
                        presenter.completeLinkRequestApiCall(formData , context);
                      } else {
                         print('dodo3');
                         FormData formData = new FormData.fromMap({
                           "unit_code": pr.isBuilding ? pr.selectedUnit : pr.qrCode.text,
                           "contract_number": pr.contractNo.text,
                           "start_at": pr.startDate.toString(),
                           "end_at": pr.endDate.toString(),
                           "request_remarks": pr.description.text,
                         });
                         presenter.completeLinkRequestApiCall(formData , context);
                       }
                      }else{
                        print('dodo4');
                        presenter.view.showToasts(S.of(context)!.enterAllData, 'error');
                      }
                    },
                    child: Text(
                      S.of(context)!.confirm,
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
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
