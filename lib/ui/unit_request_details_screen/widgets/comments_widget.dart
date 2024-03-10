import 'package:Cliamizer/app_widgets/app_headline.dart';
import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../../network/models/UnitRequestDetailsResponse.dart';
import '../../../res/colors.dart';
import '../../../res/gaps.dart';
import '../UnitDetailsPresenter.dart';
import 'comment_item_widget.dart';

class CommentsWidget extends StatelessWidget {
 final List<Comments> commentsData;
 final String claimId;
 final UnitDetailsPresenter presenter;
 const CommentsWidget({Key? key,required this.presenter,required this.commentsData,required this.claimId,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppHeadline(title: S.of(context)!.topUpdates),
        Gaps.vGap12,
        ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: commentsData.length,
          separatorBuilder: (context, index) => Divider(color: MColors.dividerColor,),
          itemBuilder: (context, index) => CommentItemWidget(
            apiStrings: commentsData[index].files!,
            commentsData: commentsData[index],
          )),
        Gaps.vGap12,
        Gaps.vGap12,
      ],
    );
  }
}
