import 'package:Cliamizer/app_widgets/app_headline.dart';
import 'package:Cliamizer/network/models/ClaimDetailsResponse.dart';
import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../../res/colors.dart';
import '../../../res/gaps.dart';
import '../ClaimsDetailsPresenter.dart';
import 'comment_item_widget.dart';

class CommentsWidget extends StatelessWidget {
 final Comments commentsData;
 final String claimId;
 final ClaimsDetailsPresenter presenter;
 const CommentsWidget({Key? key,required this.presenter,required this.commentsData,required this.claimId,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print('tessssssssst'+commentsData.data.length.toString());
     return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppHeadline(title: S.of(context)!.topUpdates),
        Gaps.vGap12,
        ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: commentsData.data.length,
          separatorBuilder: (context, index) => Divider(color: MColors.dividerColor,),
          itemBuilder: (context, index) => ClaimCommentItemWidget(
            apiStrings: [],
            commentsData: commentsData.data[index],
          )),
        Gaps.vGap12,
        Gaps.vGap12,
      ],
    );
  }
}
