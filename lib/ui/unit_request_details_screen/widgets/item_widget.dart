import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../../../res/colors.dart';
import '../../../res/gaps.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget({Key? key,required this.title,required this.value, this.valueColor}) : super(key: key);
  final String title;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(title, style: TextStyle(color: MColors.black, fontWeight: FontWeight.w700)),
        Gaps.vGap8,
        AutoSizeText(value,
            style: TextStyle(
              color: valueColor ?? MColors.black,
              fontWeight: FontWeight.w400,
            )),
        Gaps.vGap12,
        Gaps.vGap12,
      ],
    );
  }
}
