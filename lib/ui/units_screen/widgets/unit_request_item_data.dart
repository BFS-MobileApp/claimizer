import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../CommonUtils/utils.dart';
import '../../../res/colors.dart';

class UnitRequestDataItem extends StatelessWidget {
  const UnitRequestDataItem({Key? key,required this.title,required this.data, this.isLast = false}) : super(key: key);

  final String title;
  final String data;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 8.0),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: Utils.sWidth(35, context),
            child: AutoSizeText(
              title,
              maxFontSize: 12,
              maxLines: 2,
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
          ),
          // Spacer(),
          SizedBox(
            width: Utils.sWidth(47, context),
            child: AutoSizeText(
              data ?? "",
              textAlign: TextAlign.end,
              maxLines: 2,
              maxFontSize: 12,
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
          )
        ],
      ),
    );
  }
}
