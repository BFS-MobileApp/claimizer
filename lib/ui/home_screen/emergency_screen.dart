import 'package:Cliamizer/CommonUtils/image_utils.dart';
import 'package:Cliamizer/app_widgets/claimizer_app_bar.dart';
import 'package:Cliamizer/generated/l10n.dart';
import 'package:Cliamizer/network/models/emergency_model.dart';
import 'package:Cliamizer/res/gaps.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Widget screenWidget() {
    return ListView(
      children: [
        Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.w),
            child: ClaimizerAppBar(title: S.current!.emergencyContacts)),
        Gaps.vGap40,
        Image.asset(ImageUtils.getImagePath('sos'), height: 20.h, width: 20.w),
        Gaps.vGap15,
        ListView.separated(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(), // Ensure it scrolls properly
          itemCount: widget.companies[0].emergencyContacts.length,
          itemBuilder: (context, index) {
            final contact = widget.companies[0].emergencyContacts[index];
            return InkWell(
              onTap: () {
                makePhoneCall(contact.number);
              },
              child: ListTile(
                contentPadding: EdgeInsets.only(right: 5.w, left: 5.w),
                title: Text(
                  contact.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // Set to bold
                    fontSize: 18.0, // Increased font size
                  ),
                ),
                subtitle: Text(
                  contact.number,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0,
                  ),
                ),
                leading: Icon(Icons.phone, size: 24.0, color: Colors.blue),
              ),
            );
          },
          separatorBuilder: (context, index) => Divider(
            color: Colors.grey, // Customize the divider color
            thickness: 1,       // Customize the thickness
          ),
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
