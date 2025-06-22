import 'package:Cliamizer/CommonUtils/image_utils.dart';
import 'package:Cliamizer/app_widgets/image_loader.dart';
import 'package:Cliamizer/base/view/base_state.dart';
import 'package:Cliamizer/helper.dart';
import 'package:Cliamizer/network/api/network_api.dart';
import 'package:Cliamizer/res/styles.dart';
import 'package:Cliamizer/ui/edit_profile_screen/EditProfileScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../CommonUtils/log_utils.dart';
import '../../CommonUtils/model_eventbus/EventBusUtils.dart';
import '../../CommonUtils/model_eventbus/ProfileEvent.dart';
import '../../CommonUtils/preference/Prefs.dart';
import '../../generated/l10n.dart';
import '../../res/colors.dart';
import '../../res/gaps.dart';
import '../../res/setting.dart';
import '../../styles/dark_theme_provider.dart';
import '../user/login_screen/LoginScreen.dart';
import 'MorePresenter.dart';
import 'MoreProvider.dart';

class MoreScreen extends StatefulWidget {
  static const String TAG = "/MoreScreen";

  MoreScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MoreScreen> createState() => MoreScreenState();
}

class MoreScreenState extends BaseState<MoreScreen, MorePresenter>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  MoreProvider provider = MoreProvider();

  @override
  void initState() {
    super.initState();
    provider = context.read<MoreProvider>();
    EventBusUtils.getInstance().on<ProfileEvent>().listen((event) {
      if (event.username != null) {
        provider.instance.name = event.username;
      }
      if (event.userEmail != null) {
        provider.instance.email = event.userEmail;
      }
      if (event.userImage != null) {
        provider.instance.avatar = event.userImage;
      }
      setState(() {});
    });
    mPresenter.getProfileData();
    Prefs.getAppLocal.then((value) => {
          if (value != null)
            {
              setState(() {
                setSelected(value);
                provider.language = value;
                print('languageeeeeeeee ' + value);
              }),
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: provider.instance != null
          ? Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 60, 16, 5),
              child: ListView(
                children: [
                  profileWidget(),
                  Gaps.vGap12,
                  settingsWidget(),
                  Gaps.vGap12,
                  Gaps.vGap8,
                  accountWidget(), /*deleteAccountWidget()*/
                ],
              ),
            )
          : mPresenter.showProgress(),
    );
  }

  Widget profileWidget() => Container(
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.w),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 1.w,
                  height: 5.w,
                  margin: EdgeInsetsDirectional.only(end: 2.w),
                  decoration: BoxDecoration(
                      color: MColors.primary_color,
                      borderRadius: BorderRadius.circular(4)),
                ),
                Text(S.current!.profile,
                    style: Theme.of(context).appBarTheme.titleTextStyle),
                Spacer(),
                editProfileButton()
              ],
            ),
            Gaps.vGap16,
            Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: ImageLoader(
                      imageUrl: provider.instance.avatar,
                      width: 16.w,
                      height: 16.w,
                      fit: BoxFit.cover,
                    )),
                Gaps.hGap12,
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 10, top: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(provider.instance.name,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: MColors.dark_text_color,
                              fontSize: 15.sp)),
                      Text(provider.instance.email,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: MColors.dark_text_color,
                              fontSize: 12.sp)),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      );

  Widget editProfileButton() => InkWell(
        onTap: () {
          Navigator.push(
              context, CupertinoPageRoute(builder: (_) => EditProfileScreen()));
        },
        child: Container(
          width: 8.w,
          height: 8.w,
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
              border: Border.all(color: MColors.primary_color),
              borderRadius: BorderRadius.circular(8)),
          child: SvgPicture.asset(
            ImageUtils.getSVGPath('edit-2'),
            fit: BoxFit.fitWidth,
          ),
        ),
      );

  Widget settingsWidget() {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.w),
      child: Column(
        children: [
          // language
          Row(
            children: [
              SvgPicture.asset(
                ImageUtils.getSVGPath('lang'),
                height: 3.h,
                width: 3.w,
                fit: BoxFit.fitWidth,
              ),
              Gaps.hGap12,
              Text(S.of(context)!.language,
                  style: Theme.of(context).appBarTheme.titleTextStyle),
              Spacer(),
              Transform.scale(
                  scale: 0.2.w,
                  child: Consumer<MoreProvider>(
                    builder: (context, pr, child) => CupertinoSwitch(
                        activeColor: Color(0xff44A4F2),
                        value: Setting.mobileLanguage.value == Locale('en'),
                        onChanged: (value) {
                          if (value) {
                            setSelected("en");
                            mPresenter.passReloadByEventPath();
                          } else {
                            setSelected("ar");
                            mPresenter.passReloadByEventPath();
                          }
                        }),
                  )),
            ],
          ),
          divider(),
          // help
          InkWell(
            onTap: () => _launchUrl(Api.help),
            child: Row(
              children: [
                SvgPicture.asset(
                  ImageUtils.getSVGPath('help'),
                  height: 3.h,
                  width: 3.w,
                  fit: BoxFit.fitWidth,
                ),
                Gaps.hGap12,
                Text(S.of(context)!.help,
                    style: Theme.of(context).appBarTheme.titleTextStyle),
              ],
            ),
          ),
          divider(),
          // support
          InkWell(
            onTap: () => _launchUrl(Api.contact),
            child: Row(
              children: [
                SvgPicture.asset(
                  ImageUtils.getSVGPath('24-support'),
                  height: 3.h,
                  width: 3.w,
                  fit: BoxFit.fitWidth,
                ),
                Gaps.hGap12,
                Text(S.of(context)!.support,
                    style: Theme.of(context).appBarTheme.titleTextStyle),
              ],
            ),
          ),
          divider(),
          // Privacy and Policy
          InkWell(
            onTap: () => _launchUrl(Api.privacyPolicy),
            child: Row(
              children: [
                SvgPicture.asset(
                  ImageUtils.getSVGPath('privacy_policy'),
                  height: 3.h,
                  width: 3.w,
                  fit: BoxFit.fitWidth,
                ),
                Gaps.hGap12,
                Text(S.of(context)!.privacyAndPolicy,
                    style: Theme.of(context).appBarTheme.titleTextStyle),
              ],
            ),
          ),
          divider(),
          Row(
            children: [
              Icon(
                Icons.dark_mode,
                color: Colors.red,
              ),
              Gaps.hGap12,
              Text(S.of(context)!.darkMode,
                  style: Theme.of(context).appBarTheme.titleTextStyle),
              Spacer(),
              Transform.scale(
                  scale: 0.2.w,
                  child: CupertinoSwitch(
                    activeColor: Color(0xff44A4F2),
                    value: themeChange.darkTheme,
                    onChanged: (bool value) {
                      themeChange.darkTheme = value;
                    },
                  )),
            ],
          ),
        ],
      ),
    );
  }

  void setSelected(String s) {
    if (s == 'en' || s == 'null')
      Setting.mobileLanguage.value = new Locale('en');
    else
      Setting.mobileLanguage.value = new Locale('ar');
    Prefs.setAppLocal(s);
    Log.d(s);
  }

  Future<void> _launchUrl(String _url) async {
    Uri uri = Uri.parse(_url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $_url');
    }
  }

  /*Widget emergencyNum(String startTimeStr, String endTimeStr) {
    if (Helper.checkEmergencyNumbersDate(startTimeStr ,endTimeStr )) {
      print('Current time is within the range.');
      return Column(
        children: [
          divider(), // Assuming divider() returns a Divider widget
          InkWell(
            onTap: () {
              showEmergencyContactsBottomSheet(context);
            },
            child: Row(
              children: [
                Image.asset(ImageUtils.getImagePath('emergency'), height: 5.h, width: 5.w),
                SizedBox(width: 12), // Assuming Gaps.hGap12 is a SizedBox
                Text(S.of(context)!.emergencyNumbers, style: MTextStyles.textMainLight16),
              ],
            ),
          ),
        ],
      );
    } else {
      print('Current time is outside the range.');
      return const SizedBox();
    }
  }*/

  /*void showEmergencyContactsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  width: 40.0,
                  height: 5.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                S.of(context)!.emergencyContacts,
                style: MTextStyles.textMainLight16.copyWith(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: provider.getCompanies[0].emergencyContacts.length,
                itemBuilder: (context, index) {
                  final contact = provider.getCompanies[0].emergencyContacts[index];
                  return InkWell(
                    onTap: () {
                      makePhoneCall(contact.number);
                    },
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                      title: Text(
                        contact.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w400, // Reduced fontWeight
                          fontSize: 16.0,
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
                      onTap: () {
                        makePhoneCall(contact.number);
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }*/

  Widget accountWidget() {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
      child: Column(
        children: [
          // notification
          // Row(
          //   children: [
          //     SvgPicture.asset(
          //       ImageUtils.getSVGPath('notification-bing'),
          //       fit: BoxFit.fitWidth,
          //     ),
          //     Gaps.hGap12,
          //     Text(S.of(context).notification, style: MTextStyles.textMainLight16),
          //     Spacer(),
          //     Transform.scale(
          //         scale: 0.2.w,
          //         child: CupertinoSwitch(
          //             activeColor: Color(0xff44A4F2),
          //             value: provider.receiveNotification,
          //             onChanged: (value) {
          //               provider.receiveNotification = value;
          //             }))
          //   ],
          // ),
          // divider(),
          // logout
          InkWell(
            onTap: () async {
              await Prefs.clearExpectLanguage();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(builder: (_) => LoginScreen()),
                (route) => false,
              );
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  ImageUtils.getSVGPath('logout'),
                  height: 3.h,
                  width: 3.w,
                  fit: BoxFit.fitWidth,
                ),
                Gaps.hGap12,
                Text(S.of(context)!.logOut,
                    style: Theme.of(context).appBarTheme.titleTextStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget deleteAccountWidget() {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Container(
      decoration: BoxDecoration(
          color: MColors.whiteE, borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      //margin: EdgeInsets.only(right: 15.w),
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              List<String> myList = [];
              myList = await Prefs.getDeleteAccount();
              if (!myList.contains(provider.instance.email)) {
                myList.add(provider.instance.email);
              }
              Prefs.setDeleteAccount(myList);
              Prefs.clearExpectLanguage();
              final snackBar = SnackBar(
                content: Text('Account Deleted Successfully'),
                duration: Duration(seconds: 3), // Adjust the duration as needed
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(builder: (_) => LoginScreen()),
                  (route) => false);
            },
            child: Row(
              children: [
                Icon(
                  Icons.delete,
                  size: 13.sp,
                  color: MColors.primary_color,
                ),
                Gaps.hGap12,
                Text(S.of(context)!.deleteAccount,
                    style: MTextStyles.textMainLight16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget divider() {
    return Column(
      children: [
        Gaps.vGap16,
        Divider(
          color: MColors.dividerColor,
        ),
        Gaps.vGap16,
      ],
    );
  }

  @override
  MorePresenter createPresenter() {
    return MorePresenter();
  }

  @override
  bool get wantKeepAlive => true;
}

extension DateTimeExtension on DateTime {
  bool isAfterOrEqual(DateTime other) {
    return isAtSameMomentAs(other) || isAfter(other);
  }

  bool isBeforeOrEqual(DateTime other) {
    return isAtSameMomentAs(other) || isBefore(other);
  }

  bool isBetween({required DateTime from, required DateTime to}) {
    return isAfterOrEqual(from) && isBeforeOrEqual(to);
  }

  bool isBetweenExclusive({required DateTime from, required DateTime to}) {
    return isAfter(from) && isBefore(to);
  }
}
