import 'package:flutter/material.dart';

import '../../../res/colors.dart';
import '../../../res/gaps.dart';
import '../../../res/styles.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget({Key? key, required this.title, required this.value,this.valueColor}) : super(key: key);
 final String title;
 final String value;
 final Color? valueColor;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: Theme.of(context).appBarTheme.titleTextStyle),
        Gaps.vGap8,
        Text(value,
            style: Theme.of(context).appBarTheme.titleTextStyle),
        Gaps.vGap12,
        Gaps.vGap12,
      ],
    );
  }
}
