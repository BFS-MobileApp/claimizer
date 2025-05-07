import 'package:Cliamizer/CommonUtils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:Cliamizer/generated/l10n.dart';
import 'package:Cliamizer/res/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

class NoDataWidget extends StatelessWidget {
  final Future<void> Function() onRefresh;
  const NoDataWidget({
    Key? key,required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 20),
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8)
      ),
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          children:[
            Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: 50.w,
                  width: 60.w,
                  child: SvgPicture.asset(
                   ImageUtils.getSVGPath("no_search_result"),
                  )),
              SizedBox(height: 20),
              Text(
                S.of(context)!.noResults,
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
              SizedBox(height: 20),
              Text(
                S.of(context)!.sorryThereAreNoResultsForThisSearchPleaseTry,
                textAlign: TextAlign.center,
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
              // SpinKitSpinningLines(
              //     color: MColors.gray_99.withOpacity(.5)),
            ],
          ),
        ]),
      ),
    );
  }
}
