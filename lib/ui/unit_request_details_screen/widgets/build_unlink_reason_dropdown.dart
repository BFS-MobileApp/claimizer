import 'package:Cliamizer/res/colors.dart';
import 'package:Cliamizer/ui/unit_request_details_screen/UnitDetailsProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../generated/l10n.dart';
import '../../../res/styles.dart';

class BuildUnlinkStatusDropDown extends StatelessWidget {
  const BuildUnlinkStatusDropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UnitDetailsProvider>(
      builder: (context, provider, child) {
        // Initialize with first value if unlinkStatus is empty
        final initialValue = provider.unlinkStatus.isEmpty
            ? 'finished'
            : provider.unlinkStatus;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: MColors.primary_color.withOpacity(.1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MColors.error_color),
                ),
              ),
              hint: Text(
                S.of(context)!.unitStatus,
                style: MTextStyles.textMain14.copyWith(color: MColors.black),
              ),
              value: initialValue,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  provider.unlinkStatus = newValue;
                } else {
                  provider.unlinkStatus = ''; // Or your default value
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.of(context)!.pleaseSelectStatus;
                }
                return null;
              },
              items: [
                DropdownMenuItem(
                  value: 'finished',
                  child: Text(S.of(context)!.finished),
                ),
                DropdownMenuItem(
                  value: 'terminated',
                  child: Text(S.of(context)!.terminated),
                ),
                DropdownMenuItem(
                  value: 'canceled',
                  child: Text(S.of(context)!.canceled),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}