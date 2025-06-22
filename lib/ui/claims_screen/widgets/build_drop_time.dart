import 'package:Cliamizer/res/colors.dart';
import 'package:Cliamizer/ui/claims_screen/ClaimsProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../network/models/claim_available_time_response.dart';
import '../../../res/styles.dart';

class BuildTimeDropDown extends StatelessWidget {
  const BuildTimeDropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ClaimsProvider>(
      builder: (context, pr, child) => Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: MColors.textFieldBorder),
          color: Theme.of(context).highlightColor,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            style: Theme.of(context).textTheme.bodyLarge,
            dropdownColor: Theme.of(context).indicatorColor,
            isExpanded: true,
            hint: Text(
              S.of(context)!.availableTime,
              style: MTextStyles.textMain14.copyWith(color: Theme.of(context).scaffoldBackgroundColor),
            ),
            value: pr.selectedTimeValue,
            onChanged: (String? newValue) {
              pr.selectedTimeValue = newValue!;
            },
            items: pr.claimAvailableTimeList.map((ClaimAvailableTimeDataBean value) {
              return DropdownMenuItem<String>(
                value: value.name,
                child: Text(value.name),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
