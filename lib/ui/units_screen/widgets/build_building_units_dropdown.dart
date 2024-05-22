import 'package:Cliamizer/res/colors.dart';
import 'package:Cliamizer/ui/units_screen/units_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../generated/l10n.dart';
import '../../../network/models/NewLinkListRequestResponse.dart';
import '../../../res/styles.dart';

class BuildBuildingUnitDropDown extends StatefulWidget {

  BuildBuildingUnitDropDown({Key? key}) : super(key: key);

  @override
  State<BuildBuildingUnitDropDown> createState() => _BuildBuildingUnitDropDownState();
}

class _BuildBuildingUnitDropDownState extends State<BuildBuildingUnitDropDown> {
  @override
  void initState() {
    super.initState();
    final pr = Provider.of<UnitProvider>(context, listen: false);
    if (pr.selectedUnit == null || pr.selectedUnit == '') {
      setState(() {
        pr.selectedUnit = pr.buildingUnitsList[0].code;
      });
  }}
  @override
  Widget build(BuildContext context) {
    return Consumer<UnitProvider>(
      builder: (context, pr, child){
        print(pr.selectedUnit);
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: MColors.textFieldBorder),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: Text(
                S.of(context)!.selectUnit,
                style: MTextStyles.textMain14.copyWith(color: MColors.light_text_color),
              ),
              value: pr.selectedUnit,
              onChanged: (String? newValue) {
                setState(() {
                  pr.selectedUnit = newValue!;
                });
              },
              items: pr.buildingUnitsList.map((UnitsList value) {
                return DropdownMenuItem<String>(
                  value: value.code,
                  child: Text(value.propertyName),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
