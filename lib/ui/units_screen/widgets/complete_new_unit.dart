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
  const CompleteNewUnit({Key? key, required this.provider, required this.presenter}) : super(key: key);
  final UnitProvider provider;
  final UnitPresenter presenter;

  @override
  Widget build(BuildContext context) {
    return Consumer<UnitProvider>(
      builder: (context, pr, child) => Container(
        color: Color(0xFFF5F5F5),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.w),
          children: [
            // Page Title
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
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
                  Text(
                    S.current!.newLinkRequest,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            Gaps.vGap8,

            // Form Card
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel(S.current!.companyName),
                  Gaps.vGap8,
                  CompanyNameField(provider: provider),

                  Gaps.vGap16,
                  _buildFieldLabel(S.current!.buildingName),
                  Gaps.vGap8,
                  BuildingNameField(provider: provider),

                  Gaps.vGap16,
                  Visibility(
                    visible: pr.isBuilding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel(S.current!.unitName ?? "Unit Name"),
                        Gaps.vGap8,
                        BuildBuildingUnitDropDown(),
                        Gaps.vGap16,
                      ],
                    ),
                  ),

                  if (provider.showUnitNumber) ...[
                    _buildFieldLabel("Unit Number"),
                    Gaps.vGap8,
                    UnitNumberItem(provider: provider),
                    Gaps.vGap16,
                  ],

                  _buildFieldLabel(S.current!.contractNo),
                  Gaps.vGap8,
                  ContractField(provider: provider),

                  Gaps.vGap16,
                  StartEndDatePickerField(provider: provider),

                  Gaps.vGap16,
                  BuildContractFilePicker(provider: provider),

                  Gaps.vGap16,
                  BuildIdentityFilePicker(provider: provider),

                  Gaps.vGap16,
                  Text(
                    S.current!.requestNotes,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Gaps.vGap8,
                  BuildDescriptionField(provider: provider),
                ],
              ),
            ),

            Gaps.vGap16,

            // Buttons Row
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 6.h,
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
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: MColors.primary_color,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        elevation: MaterialStatePropertyAll(0),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: MColors.primary_color, width: 1.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: SizedBox(
                    height: 6.h,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (pr.contractNo.text.isEmpty && !pr.isHasStartDate && !pr.isHasEndDate) {
                          presenter.view.showToasts(S.of(context)!.enterAllData, 'error');
                        } else if (pr.endDate.isBefore(pr.startDate)) {
                          presenter.view.showToasts(S.of(context)!.dateErrorMessage, 'error');
                        } else if (pr.contractNo.text.isNotEmpty && pr.isHasStartDate && pr.isHasEndDate) {
                          if (pr.contractImg.path != '' || pr.identityImg.path != '') {
                            FormData formData = new FormData.fromMap({
                              "contract_attach": await MultipartFile.fromFile(
                                pr.contractImg.path,
                                contentType: new MediaType('application', 'octet-stream'),
                              ),
                              "client_gov_id": await MultipartFile.fromFile(
                                pr.identityImg.path,
                                contentType: new MediaType('application', 'octet-stream'),
                              ),
                              "unit_code": pr.isBuilding ? pr.selectedUnit : pr.qrCode.text == '' ? pr.buildingUnitCode : pr.qrCode.text,
                              "contract_number": pr.contractNo.text,
                              "start_at": pr.startDate.toString(),
                              "end_at": pr.endDate.toString(),
                              "request_remarks": pr.description.text,
                            });
                            presenter.completeLinkRequestApiCall(formData, context);
                          } else {
                            FormData formData = new FormData.fromMap({
                              "unit_code": pr.isBuilding ? pr.selectedUnit : pr.qrCode.text == '' ? pr.buildingUnitCode : pr.qrCode.text,
                              "contract_number": pr.contractNo.text,
                              "start_at": pr.startDate.toString(),
                              "end_at": pr.endDate.toString(),
                              "request_remarks": pr.description.text,
                            });
                            presenter.completeLinkRequestApiCall(formData, context);
                          }
                        } else {
                          presenter.view.showToasts(S.of(context)!.enterAllData, 'error');
                        }
                      },
                      child: Text(
                        S.of(context)!.confirm,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(MColors.primary_color),
                        elevation: MaterialStatePropertyAll(0),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Gaps.vGap16,
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '* ',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: MColors.primary_color,
            ),
          ),
          TextSpan(
            text: label,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}