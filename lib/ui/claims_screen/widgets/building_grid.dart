import 'package:Cliamizer/ui/main_screens/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../CommonUtils/image_utils.dart';
import '../../../app_widgets/NoDataFoundGrid.dart';
import '../../../generated/l10n.dart';
import '../../../res/colors.dart';
import '../../../res/gaps.dart';
import '../../../res/styles.dart';
import '../ClaimsPresenter.dart';
import '../ClaimsProvider.dart';

class BuildingGrid extends StatefulWidget {
  BuildingGrid({Key? key, required this.onSelected, required this.presenter , required this.claimContext}) : super(key: key);
  final Function(int) onSelected;
  final ClaimsPresenter presenter;
  final BuildContext claimContext;

  @override
  _BuildingGridState createState() => _BuildingGridState();
}

class _BuildingGridState extends State<BuildingGrid> {
  bool _dialogShown = false;

  void showConfirmDialog(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 800), () {
      // Use the root context to show the dialog
      if (mounted && _dialogShown) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              insetPadding: EdgeInsets.all(20),
              contentPadding: EdgeInsets.all(24),
              title: Text(
                S.current!.areNotConnectedToBuilding,
                style: MTextStyles.textBoldDark14,
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Future.delayed(const Duration(milliseconds: 5), () {
                      setState(() {
                        _dialogShown = false;
                      });
                    });
                    Navigator.pushReplacement(
                        widget.claimContext, MaterialPageRoute(builder: (context) => MainScreen(index: 2)));
                  },
                  child: Text(
                    S.of(context)!.ok,
                    style: MTextStyles.textWhite14.copyWith(fontWeight: FontWeight.w600),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(MColors.primary_color),
                    elevation: MaterialStateProperty.all(0),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClaimsProvider>(
      builder: (ctx, pr, w) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (pr.buildingsList.isEmpty && !_dialogShown) {
            _dialogShown = true;
            showConfirmDialog(context);
          }
        });
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 1.w,
                  height: 5.w,
                  margin: EdgeInsetsDirectional.only(end: 3.w),
                  decoration: BoxDecoration(
                    color: MColors.primary_verticalHeader,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SvgPicture.asset(
                  ImageUtils.getSVGPath("buildings"),
                  color: MColors.primary_color,
                ),
                Gaps.hGap8,
                Text(S.of(context)!.selectBuilding, style: MTextStyles.textMain16),
              ],
            ),
            pr.buildingsList.isNotEmpty
                ? GridView.builder(
              itemCount: pr.buildingsList.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    pr.selectedBuildingIndex = index;
                    widget.onSelected(pr.buildingsList[index].id!);
                    pr.selectedBuilding = pr.buildingsList[index].name!;
                    Future.delayed(Duration(seconds: 0));
                    pr.currentStep < 2 ? pr.currentStep += 1 : null;
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: pr.selectedBuildingIndex == index ? MColors.primary_color : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: MColors.dividerColor.withOpacity(.6), width: 2),
                    ),
                    child: Text(
                      pr.buildingsList[index].name!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: pr.selectedBuildingIndex == index ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            )
                : NoDataWidgetGrid(
              onRefresh: () async {
                widget.presenter.getBuildingsApiCall();
              },
            ),
          ],
        );
      },
    );
  }
}
