import 'package:Cliamizer/CommonUtils/image_utils.dart';
import 'package:Cliamizer/app_widgets/claimizer_app_bar.dart';
import 'package:Cliamizer/generated/l10n.dart';
import 'package:Cliamizer/network/models/emergency_model.dart';
import 'package:Cliamizer/res/gaps.dart';
import 'package:Cliamizer/res/setting.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../res/colors.dart';

class EmergencyScreen extends StatefulWidget {

  List<Company> companies = [];

  EmergencyScreen({super.key , required this.companies});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {

  void makePhoneCall(String phone) async{
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    await launchUrl(launchUri);
  }

  Widget appBar(){
    return Row(
      children: [
        InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Setting.mobileLanguage.value != Locale("en")
                ? RotatedBox(
              quarterTurns: 2,
              child: SvgPicture.asset(
                ImageUtils.getSVGPath("back_icon"),
              ),
            )
                : SvgPicture.asset(
              ImageUtils.getSVGPath("back_icon"),
            )),
        Expanded(
          child: Center(
            child: AutoSizeText(
              S.of(context)!.emergencyContacts,
              style: GoogleFonts.montserrat(fontWeight: FontWeight.w500 , fontSize: 16.sp , color: MColors.black),
            ),
          ),
        )
      ],
    );
  }
  Widget screenWidget() {
    return ListView(
      children: [
        Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.w),
            child: appBar()
        ),
        Gaps.vGap12,
        ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(), // Ensure it scrolls properly
          itemCount: widget.companies[0].emergencyContacts.length,
          itemBuilder: (context, index) {
            final contact = widget.companies[0].emergencyContacts[index];
            return InkWell(
              onTap: () {
                makePhoneCall(contact.number);
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 1.h , horizontal: 2.w),
                padding: EdgeInsets.all(2.h),
                decoration: BoxDecoration(
                  border: Border.all(
                     color: MColors.primary_color,
                      width: 1.0
                  ),
                  borderRadius: BorderRadius.all(
                      Radius.circular(10.0) //                 <--- border radius here
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(contact.title , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 12.sp , color: Colors.black),),
                    SizedBox(height: 1.h,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            ImageUtils.getSVGPath("emergencyCall"),
                            width: 4.w,
                            height: 4.h,
                          ),
                          SizedBox(width: 2.w,),
                          Text(contact.number , style: TextStyle(fontWeight: FontWeight.w600 , fontSize: 15.sp , color: Colors.black),),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screenWidget(),
    );
  }
}
