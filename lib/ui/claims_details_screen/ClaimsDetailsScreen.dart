import 'dart:io';

import 'package:Cliamizer/CommonUtils/image_utils.dart';
import 'package:Cliamizer/CommonUtils/utils.dart';
import 'package:Cliamizer/base/view/base_state.dart';
import 'package:Cliamizer/ui/claims_details_screen/widgets/build_comment_field.dart';
import 'package:Cliamizer/ui/claims_details_screen/widgets/build_upload_file_field.dart';
import 'package:Cliamizer/ui/claims_details_screen/widgets/comments_widget.dart';
import 'package:Cliamizer/ui/claims_details_screen/widgets/description_widget.dart';
import 'package:Cliamizer/ui/claims_details_screen/widgets/files_showing_widget.dart';
import 'package:Cliamizer/ui/claims_details_screen/widgets/files_widgets.dart';
import 'package:Cliamizer/ui/claims_details_screen/widgets/item_widget.dart';
import 'package:Cliamizer/ui/claims_details_screen/widgets/svg_image_widget.dart';
import 'package:Cliamizer/ui/claims_details_screen/widgets/technician_history.dart';
import 'package:Cliamizer/ui/home_screen/HomeScreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../app_widgets/app_headline.dart';
import '../../app_widgets/claimizer_app_bar.dart';
import '../../generated/l10n.dart';
import '../../network/models/claims_response.dart';
import '../../res/assets_manager.dart';
import '../../res/colors.dart';
import '../../res/dimens.dart';
import '../../res/gaps.dart';
import '../../res/styles.dart';
import 'ClaimsDetailsPresenter.dart';
import 'ClaimsDetailsProvider.dart';

class ClaimsDetailsScreen extends StatefulWidget {
  static const String TAG = "/ClaimsDetailsScreen";
  final int? id;
  final ClaimsDataBean? claimsDataBean;

  ClaimsDetailsScreen({
    Key? key,
    this.id,
    this.claimsDataBean,
  }) : super(key: key);

  @override
  State<ClaimsDetailsScreen> createState() => ClaimsDetailsScreenState();
}

class ClaimsDetailsScreenState
    extends BaseState<ClaimsDetailsScreen, ClaimsDetailsPresenter>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  ClaimsDetailsProvider provider = ClaimsDetailsProvider();

  @override
  void initState() {
    super.initState();
    provider = context.read<ClaimsDetailsProvider>();
    mPresenter.getClaimDetailsDataApiCall(widget.claimsDataBean!.referenceId);
  }

  void showRatingDialog(BuildContext context, String referenceId) {
    double rating = 0;
    final TextEditingController feedbackController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Builder(
          builder: (dialogContext) {
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400),
                child: Material(
                  color: Colors.transparent,
                  child: AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                    content: StatefulBuilder(
                      builder: (context, setState) {
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Rate Our Service",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 12),
                              Text("How Would You Rate Our Service?"),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (index) {
                                  bool isSelected = index < rating;
                                  return GestureDetector(
                                    onTap: () =>
                                        setState(() => rating = index + 1.0),
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 250),
                                      padding: EdgeInsets.all(4),
                                      child: Icon(
                                        isSelected
                                            ? Icons.star
                                            : Icons.star_border,
                                        size: 32,
                                        color: isSelected
                                            ? Colors.amber
                                            : Colors.grey.shade400,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsetsDirectional.only(start: 6),
                                    width: 3.5,
                                    height: 16,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: Colors.red),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    "Feedback",
                                    style: Theme.of(context)
                                        .appBarTheme
                                        .titleTextStyle,
                                  )
                                ],
                              ),
                              TextField(
                                controller: feedbackController,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              SizedBox(height: 24),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () =>
                                          Navigator.pop(dialogContext),
                                      child: const Text("Cancel",style: TextStyle(fontSize: 15),),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: Colors.red),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        print("Rating: $rating");
                                        print(
                                            "Feedback: ${feedbackController.text}");
                                        mPresenter.addRateApiCall(
                                          rate: rating.toInt(),
                                          feedback:
                                              feedbackController.text.trim(),
                                          claimId: widget.id.toString(),
                                          // or any source of the claim ID
                                          ctx: context,
                                          referenceId: referenceId,
                                        );
                                      },
                                      child: const Text("Submit",
                                          style:
                                              TextStyle(color: Colors.white,fontSize: 15)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {},
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text(
          "Would you like to continue learning how to use Flutter alerts?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget test(ClaimsDetailsProvider pr) {
    if (pr.instance.comments == null || pr.instance.comments!.data.isEmpty) {
      print('test11111');
      print(pr.instance.comments);
      return SizedBox();
    }
    return CommentsWidget(
      commentsData: pr.instance.comments,
      presenter: mPresenter,
      claimId: widget.claimsDataBean!.referenceId,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ClaimsDetailsProvider>(builder: (context, pr, child) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: pr.instance != null
            ? SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.w),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: ClaimizerAppBar(title: S.of(context)!.claimDetails)),
                          GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>TechnicianHistory(
                                employeeList: pr.instance.employees,
                                logList: pr.instance.logs,
                                timeList: pr.instance.times))),
                            child: SVGImageWidget(
                              image: AssetsManager.timeHistory,
                              width: 5.w,
                              height: 5.h,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView(children: [
                          Gaps.vGap12,
                          Container(
                            padding:
                                EdgeInsets.symmetric(vertical: 8.w, horizontal: 6.w),
                            margin: EdgeInsets.symmetric(vertical: 2.w),
                            decoration: BoxDecoration(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    AppHeadline(
                                        title:
                                            pr.instance?.unit?.code ?? S.current!.na),

                                  ],
                                ),
                                Gaps.vGap30,
                                ItemWidget(
                                  title: S.current!.yourBuilding,
                                  value: pr.instance?.unit?.building ?? S.current!.na,
                                ),
                                ItemWidget(
                                  title: S.current!.yourUnit,
                                  value: pr.instance.unit.name ?? S.current!.na,
                                ),
                                ItemWidget(
                                  title: S.of(context)!.claimStatus,
                                  value: pr.instance.status ?? S.current!.na,
                                ),
                                ItemWidget(
                                  title: S.current!.claimCategory,
                                  value: pr.instance.category.name ?? S.current!.na,
                                ),
                                ItemWidget(
                                  title: S.current!.claimSubCategory,
                                  value:
                                      pr.instance.subCategory.name ?? S.current!.na,
                                ),
                                ItemWidget(
                                  title: S.current!.claimType,
                                  value: pr.instance.type.name ?? S.current!.na,
                                ),
                                ItemWidget(
                                  title: S.current!.availableTime,
                                  value:
                                      "${pr.instance.availableDate.toString() ?? S.current!.na} - ${widget.claimsDataBean?.availableTime ?? S.current!.na}",
                                ),
                                ItemWidget(
                                  title: S.current!.createdAt,
                                  value: Utils.formatDate(pr.instance.createdAt),
                                  valueColor: MColors.primary_light_color,
                                ),
                                DescriptionWidget(value: pr.instance.description),
                                pr.instance.files == null || pr.instance.files.isEmpty
                                    ? SizedBox()
                                    : FilesShowingWidget(
                                        apiStrings: pr.instance.files,
                                        count: pr.instance.files.length,
                                      ),
                                /*pr.instance.comments == null ? SizedBox(): CommentsWidget(
                                  commentsData: pr.instance.comments,
                                  presenter: mPresenter,
                                  claimId: widget.claimsDataBean!.referenceId,
                                ),*/
                                test(pr),
                                Visibility(
                                  visible:
                                      pr.instance.status.toLowerCase() != "closed" &&
                                          pr.instance.status != "مغلق" &&
                                          pr.instance.status.toLowerCase() !=
                                              "cancelled" &&
                                          pr.instance.status != "ملغي",
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: MColors.primary_color
                                    ),
                                     child:  InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) => Form(
                                              key: pr.formKey,
                                              child: Container(
                                                padding: EdgeInsets.all(20),
                                                width: double.maxFinite,
                                                child: SingleChildScrollView(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          S.of(context)!.addComment,
                                                          style:
                                                              MTextStyles.textMain14,
                                                        ),
                                                        Gaps.vGap16,
                                                        Gaps.vGap8,
                                                        BuildCommentField(),
                                                        Gaps.vGap8,
                                                        Gaps.vGap8,
                                                        BuildUploadFileField(
                                                          provider: provider,
                                                        ),
                                                        Gaps.vGap16,
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            if (provider
                                                                .formKey.currentState!
                                                                .validate()) {
                                                              if (pr.comment.text
                                                                  .isEmpty) {
                                                                showToasts(
                                                                    S
                                                                        .of(context)!
                                                                        .enterYourNotesInCommentField,
                                                                    'warning');
                                                              } else {
                                                                final formData =
                                                                    FormData();
                                                                if (pr.imageFiles
                                                                    .isNotEmpty) {
                                                                  for (var i = 0;
                                                                      i <
                                                                          pr.imageFiles
                                                                              .length;
                                                                      i++) {
                                                                    final file = await pr
                                                                        .imageFiles[i]
                                                                        .readAsBytes();
                                                                    formData.files
                                                                        .add(MapEntry(
                                                                      'file[$i]',
                                                                      MultipartFile
                                                                          .fromBytes(
                                                                              file,
                                                                              filename:
                                                                                  'image$i.jpg'),
                                                                    ));
                                                                    formData.fields
                                                                        .add(MapEntry(
                                                                            "comment",
                                                                            pr.comment
                                                                                .text));
                                                                    formData.fields
                                                                        .add(MapEntry(
                                                                            "claim_id",
                                                                            widget
                                                                                .claimsDataBean!
                                                                                .id
                                                                                .toString()));
                                                                  }
                                                                  mPresenter.doPostCommentApiCall(
                                                                      formData,
                                                                      widget
                                                                          .claimsDataBean!
                                                                          .referenceId,
                                                                      context);
                                                                } else if (pr
                                                                        .file.path !=
                                                                    '') {
                                                                  FormData formData =
                                                                      new FormData
                                                                          .fromMap({
                                                                    "file[0]":
                                                                        await MultipartFile
                                                                            .fromFile(
                                                                      pr.file.path,
                                                                      contentType:
                                                                          new MediaType(
                                                                              'application',
                                                                              'octet-stream'),
                                                                    ),
                                                                    "comment": pr
                                                                        .comment.text,
                                                                    "claim_id": widget
                                                                        .claimsDataBean!
                                                                        .id,
                                                                  });
                                                                  mPresenter.doPostCommentApiCall(
                                                                      formData,
                                                                      widget
                                                                          .claimsDataBean!
                                                                          .referenceId,
                                                                      context);
                                                                } else {
                                                                  FormData formData =
                                                                      FormData();
                                                                  formData =
                                                                      new FormData
                                                                          .fromMap({
                                                                    "comment": pr
                                                                        .comment.text,
                                                                    "claim_id": widget
                                                                        .claimsDataBean!
                                                                        .id,
                                                                  });
                                                                  mPresenter.doPostCommentApiCall(
                                                                      formData,
                                                                      widget
                                                                          .claimsDataBean!
                                                                          .referenceId,
                                                                      context);
                                                                }
                                                                setState(() {});
                                                              }
                                                            }
                                                          },
                                                          child: Text(
                                                            S.of(context)!.confirm,
                                                            style: MTextStyles
                                                                .textWhite14
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                          ),
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty.all<Color>(
                                                                      MColors
                                                                          .primary_color),
                                                              minimumSize: MaterialStateProperty.all<Size>(Size(
                                                                  double.maxFinite,
                                                                  25)),
                                                              elevation:
                                                                  MaterialStatePropertyAll(
                                                                      0),
                                                              shape: MaterialStateProperty.all<
                                                                      RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(8),
                                                              )),
                                                              padding: MaterialStateProperty.all<EdgeInsets>(
                                                                  EdgeInsets.symmetric(
                                                                      horizontal: 4.w,
                                                                      vertical: 3.w))),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ).whenComplete(() {
                                            pr.comment.clear();
                                            pr.file = File('');
                                            pr.imageFiles = [];
                                            pr.isDateLoaded = true;
                                            Future.delayed(
                                                Duration(milliseconds: 1000), () {
                                              Navigator.pop(context);
                                            });
                                            //Navigator.pop(context);
                                          });
                                          // showDialog(
                                          //   context: context,
                                          //   builder: (context) {
                                          //     return AlertDialog(
                                          //       insetPadding: EdgeInsets.all(14),
                                          //       contentPadding: EdgeInsets.all(16),
                                          //       actions: [
                                          //         ElevatedButton(
                                          //           onPressed: () async {
                                          //             if (provider.formKey.currentState.validate()) {
                                          //               if (pr.comment.text.isEmpty) {
                                          //                 showToasts(
                                          //                     S.of(context).enterYourNotesInCommentField, 'warning');
                                          //               } else {
                                          //                 final formData = FormData();
                                          //                 if (pr.imageFiles != null) {
                                          //                   for (var i = 0; i < pr.imageFiles.length; i++) {
                                          //                     final file = await pr.imageFiles[i].readAsBytes();
                                          //                     formData.files.add(MapEntry(
                                          //                       'file[$i]',
                                          //                       MultipartFile.fromBytes(file, filename: 'image$i.jpg'),
                                          //                     ));
                                          //                     formData.fields.add(MapEntry("comment", pr.comment.text));
                                          //                     formData.fields.add(MapEntry(
                                          //                         "claim_id", widget.claimsDataBean.id.toString()));
                                          //                   }
                                          //                   mPresenter.doPostCommentApiCall(
                                          //                       formData, widget.claimsDataBean.referenceId);
                                          //                 } else if (pr.file != null) {
                                          //                   FormData formData = new FormData.fromMap({
                                          //                     "file[0]": await MultipartFile.fromFile(
                                          //                       pr.file.path,
                                          //                       contentType: new MediaType('application', 'octet-stream'),
                                          //                     ),
                                          //                     "comment": pr.comment.text,
                                          //                     "claim_id": widget.claimsDataBean.id,
                                          //                   });
                                          //                   mPresenter.doPostCommentApiCall(
                                          //                       formData, widget.claimsDataBean.referenceId);
                                          //                 } else {
                                          //                   FormData formData = FormData();
                                          //                   formData = new FormData.fromMap({
                                          //                     "comment": pr.comment.text,
                                          //                     "claim_id": widget.claimsDataBean.id,
                                          //                   });
                                          //                   mPresenter.doPostCommentApiCall(
                                          //                       formData, widget.claimsDataBean.referenceId);
                                          //                 }
                                          //                 setState(() {});
                                          //               }
                                          //             }
                                          //           },
                                          //           child: Text(
                                          //             S.of(context).confirm,
                                          //             style:
                                          //             MTextStyles.textWhite14.copyWith(fontWeight: FontWeight.w700),
                                          //           ),
                                          //           style: ButtonStyle(
                                          //               backgroundColor:
                                          //               MaterialStateProperty.all<Color>(MColors.primary_color),
                                          //               elevation: MaterialStatePropertyAll(0),
                                          //               shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          //                   RoundedRectangleBorder(
                                          //                     borderRadius: BorderRadius.circular(8),
                                          //                   )),
                                          //               padding: MaterialStateProperty.all<EdgeInsets>(
                                          //                   EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.w))),
                                          //         ),
                                          //         TextButton(
                                          //           onPressed: () {
                                          //             pr.comment.clear();
                                          //             pr.file = null;
                                          //             pr.imageFiles = null;
                                          //             Navigator.pop(context);
                                          //           },
                                          //           child: Text(
                                          //             S.of(context).cancel,
                                          //             style:
                                          //             MTextStyles.textWhite14.copyWith(fontWeight: FontWeight.w700,color: MColors.primary_color),
                                          //           ),
                                          //         )
                                          //       ],
                                          //       content: Form(
                                          //         key: pr.formKey,
                                          //         child: Container(
                                          //           width: double.maxFinite,
                                          //           child: SingleChildScrollView(
                                          //             child: Column(
                                          //               mainAxisSize: MainAxisSize.min,
                                          //               children: [
                                          //                 Text(
                                          //                   S.of(context).addComment,
                                          //                   style: MTextStyles.textMain14,
                                          //                 ),
                                          //                 Gaps.vGap16,
                                          //                 Gaps.vGap8,
                                          //                 BuildCommentField(
                                          //                   provider: provider,
                                          //                 ),
                                          //                 Gaps.vGap8,Gaps.vGap8,
                                          //                 BuildUploadFileField(
                                          //                   provider: provider,
                                          //                 ),
                                          //                 Gaps.vGap16,
                                          //               ],
                                          //             ),
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     );
                                          //   },
                                          // );
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              ImageUtils.getSVGPath("refresh"),
                                              color: Colors.white,
                                            ),
                                            Gaps.hGap8,
                                            Text(
                                              S.of(context)!.update,
                                              style: TextStyle(fontSize: Dimens.font_sp14,color: Colors.white),
                                            )
                                          ],
                                        ),
                                      ),
                                    onPressed: () {  },
                                      /*InkWell(
                                        onTap: () {
                                          mPresenter.deleteClaimApiCall(pr.instance.id);
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: MColors.primary_color.withOpacity(0.08), shape: BoxShape.circle),
                                              padding: EdgeInsets.all(4),
                                              child: SvgPicture.asset(
                                                ImageUtils.getSVGPath("trash"),
                                                color: MColors.primary_color,
                                              ),
                                            ),
                                            Gaps.hGap8,
                                            Text(
                                              S.of(context).deleteClaim,
                                              style: MTextStyles.textMain14,
                                            )
                                          ],
                                        ),
                                      ),*/
                                  ),
                                ),
                                Gaps.vGap12,
                                Gaps.vGap12,
                                Visibility(
                                  visible:
                                      pr.instance.status.toLowerCase() == "new" ||
                                          pr.instance.status == "جديد",
                                  child: ElevatedButton(
                                    onPressed: (){
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: MColors.primary_color
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              insetPadding: EdgeInsets.all(20),
                                              contentPadding: EdgeInsets.all(24),
                                              title: Text(
                                                S.current!.cancelClaim,
                                                style: Theme.of(context)
                                                    .appBarTheme
                                                    .titleTextStyle,
                                              ),
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    mPresenter.closeClaimApiCall(
                                                        pr.instance.referenceId);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    S.of(context)!.confirm,
                                                    style: Theme.of(context)
                                                        .appBarTheme
                                                        .titleTextStyle,
                                                  ),
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all<
                                                                  Color>(
                                                              MColors.primary_color),
                                                      elevation:
                                                          MaterialStatePropertyAll(0),
                                                      shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(8),
                                                      )),
                                                      padding: MaterialStateProperty
                                                          .all<EdgeInsets>(
                                                              EdgeInsets.symmetric(
                                                                  horizontal: 2.w,
                                                                  vertical: 3.w))),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    S.of(context)!.cancel,
                                                    style: Theme.of(context)
                                                        .appBarTheme
                                                        .titleTextStyle,
                                                  ),
                                                ),
                                              ],
                                              content: Text(
                                                S
                                                    .of(context)!
                                                    .areYouSureToCancelThisClaim,
                                                style: Theme.of(context)
                                                    .appBarTheme
                                                    .titleTextStyle,
                                              ),
                                            );
                                          },
                                        );
                                        // mPresenter.closeClaimApiCall(pr.instance.referenceId);
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: MColors.primary_color
                                                    .withOpacity(0.08),
                                                shape: BoxShape.circle),
                                            padding: EdgeInsets.all(4),
                                            child: SvgPicture.asset(
                                              ImageUtils.getSVGPath("trash"),
                                              color: Colors.white,
                                            ),
                                          ),
                                          Gaps.hGap8,
                                          Text(
                                            S.of(context)!.cancelClaim,
                                            style: TextStyle(fontSize: Dimens.font_sp14,color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible:
                                  pr.instance.status.toLowerCase() == "completed" ||
                                      pr.instance.status == "مكتمل",
                                  child: ElevatedButton(
                                    onPressed: (){
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: MColors.primary_color
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              insetPadding: EdgeInsets.all(20),
                                              contentPadding: EdgeInsets.all(24),
                                              title: Text(
                                                S.current!.closeClaim,
                                                style: Theme.of(context)
                                                    .appBarTheme
                                                    .titleTextStyle,
                                              ),
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    mPresenter.closeClaimApiCall(
                                                        pr.instance.referenceId);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    S.of(context)!.confirm,
                                                    style: Theme.of(context)
                                                        .appBarTheme
                                                        .titleTextStyle,
                                                  ),
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(
                                                          MColors.primary_color),
                                                      elevation:
                                                      MaterialStatePropertyAll(0),
                                                      shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius.circular(8),
                                                          )),
                                                      padding: MaterialStateProperty
                                                          .all<EdgeInsets>(
                                                          EdgeInsets.symmetric(
                                                              horizontal: 2.w,
                                                              vertical: 3.w))),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    S.of(context)!.cancel,
                                                    style: Theme.of(context)
                                                        .appBarTheme
                                                        .titleTextStyle,
                                                  ),
                                                ),
                                              ],
                                              content: Text(
                                                S
                                                    .of(context)!
                                                    .areYouSureToCloseThisClaim,
                                                style: Theme.of(context)
                                                    .appBarTheme
                                                    .titleTextStyle,
                                              ),
                                            );
                                          },
                                        );
                                        // mPresenter.closeClaimApiCall(pr.instance.referenceId);
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: MColors.primary_color
                                                    .withOpacity(0.08),
                                                shape: BoxShape.circle),
                                            padding: EdgeInsets.all(4),
                                            child: SvgPicture.asset(
                                              ImageUtils.getSVGPath("trash"),
                                              color: Colors.white,
                                            ),
                                          ),
                                          Gaps.hGap8,
                                          Text(
                                            S.of(context)!.closeClaim,
                                            style: TextStyle(fontSize: Dimens.font_sp14,color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Gaps.vGap12,
                               pr.instance.rate != null ? AppHeadline(title: "Rating") : const SizedBox(),
                                Gaps.vGap12,
                                pr.instance.rate != null ?  Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("My Rating",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: List.generate(5, (index) {
                                          if (index < double.parse(pr.instance.rate)) {
                                            return Icon(Icons.star,
                                                color: Colors.amber, size: 24);
                                          } else if (index < double.parse(pr.instance.rate) &&
                                              double.parse(pr.instance.rate) - index >= 0.5) {
                                            return Icon(Icons.star_half,
                                                color: Colors.amber, size: 24);
                                          } else {
                                            return Icon(Icons.star_border,
                                                color: Colors.grey.shade400,
                                                size: 24);
                                          }
                                        }),
                                      ),
                                      if (pr.instance.feedback != null &&
                                          pr.instance.feedback!.trim().isNotEmpty) ...[
                                        const SizedBox(height: 12),
                                        Text("My Feedback",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall),
                                        const SizedBox(height: 4),
                                        Text(
                                          pr.instance.feedback!,
                                          style:
                                              TextStyle(color: Colors.grey.shade800),
                                        ),
                                      ]
                                    ],
                                  ),
                                ) : const SizedBox(),
                                Gaps.vGap12,
                               pr.instance.rate == null ?  Visibility(
                                  visible:
                                      pr.instance.status.toLowerCase() == "closed" ||
                                          pr.instance.status == "مغلق" ||
                                          pr.instance.status.toLowerCase() ==
                                              "cancelled" ||
                                          pr.instance.status == "ملغي",
                                  child: ElevatedButton(
                                    onPressed: (){
                                    },
                                    style: ElevatedButton.styleFrom(backgroundColor: MColors.primary_color),
                                    child: InkWell(
                                      onTap: () {
                                        showRatingDialog(context,pr.instance.referenceId);
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: MColors.primary_color
                                                    .withOpacity(0.08),
                                                shape: BoxShape.circle),
                                            padding: EdgeInsets.all(4),
                                            child: SvgPicture.asset(
                                              width: 20,
                                              height: 20,
                                              ImageUtils.getSVGPath("star"),
                                              color: Colors.white,
                                            ),
                                          ),
                                          Gaps.hGap8,
                                          Text(
                                            S.of(context)!.rate,
                                            style: TextStyle(fontSize: Dimens.font_sp14,color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ) : const SizedBox(),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              )
            : Center(child: SizedBox.shrink()),
      );
    });
  }

  @override
  ClaimsDetailsPresenter createPresenter() {
    return ClaimsDetailsPresenter();
  }

  @override
  bool get wantKeepAlive => true;
}
