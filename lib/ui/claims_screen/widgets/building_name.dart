import 'package:Cliamizer/res/styles.dart';
import 'package:Cliamizer/ui/units_screen/units_provider.dart';
import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../../res/colors.dart';

class BuildingName extends StatelessWidget {
  const BuildingName({Key? key,required this.name}) : super(key: key);
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .06,
      child: TextFormField(
        initialValue: name,
        readOnly: true,
        style: MTextStyles.textDark14,
        decoration: InputDecoration(
          hintText: S.of(context)!.buildingName,
          hintStyle: MTextStyles.textMain14.copyWith(color: MColors.light_text_color, fontWeight: FontWeight.w500),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: MColors.textFieldBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: MColors.textFieldBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: MColors.textFieldBorder),
          ),
        ),
      ),
    );
  }
}
