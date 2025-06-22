import 'package:Cliamizer/CommonUtils/image_utils.dart';
import 'package:Cliamizer/app_widgets/app_headline.dart';
import 'package:Cliamizer/base/view/base_state.dart';
import 'package:Cliamizer/helper.dart';
import 'package:Cliamizer/network/models/UnitRequestResponse.dart';
import 'package:Cliamizer/ui/claims_screen/ClaimsProvider.dart';
import 'package:Cliamizer/ui/edit_profile_screen/EditProfileScreen.dart';
import 'package:Cliamizer/ui/home_screen/HomePresenter.dart';
import 'package:Cliamizer/ui/home_screen/HomeProvider.dart';
import 'package:Cliamizer/ui/home_screen/emergency_screen.dart';
import 'package:Cliamizer/ui/home_screen/widgets/home_card_item.dart';
import 'package:Cliamizer/ui/home_screen/widgets/remember_that_item.dart';
import 'package:Cliamizer/ui/main_screens/MainProvider.dart';
import 'package:Cliamizer/ui/main_screens/MainScreen.dart';
import 'package:Cliamizer/ui/more_screen/MoreProvider.dart';
import 'package:Cliamizer/ui/notification_screen/NotificationScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../CommonUtils/LocalNotification.dart';
import '../../CommonUtils/model_eventbus/EventBusUtils.dart';
import '../../CommonUtils/model_eventbus/ProfileEvent.dart';
import '../../CommonUtils/model_eventbus/ReloadHomeEevet.dart';
import '../../app_widgets/image_loader.dart';
import '../../generated/l10n.dart';
import '../../res/colors.dart';
import '../unit_request_details_screen/UnitDetailsScreen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends BaseState<HomeScreen, HomePresenter>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  HomeProvider provider = HomeProvider();
  MoreProvider moreProvider = MoreProvider();
  MainProvider mainProvider = MainProvider();
  ClaimsProvider claimsProvider = ClaimsProvider();
  bool refresh = true;
  List cardsColor = [
    Color(0xff44A4F2),
    Color(0xffFF9500),
    Color(0xff3716EE),
    Color(0xff10D2C8),
    Color(0xff0A562E),
    Color(0xffFF0000),
    Color(0xff679C0D),
  ];

  List<String> cardImages = [
    'allclaims',
    'newclaims',
    'assigned_claims',
    'started_claims',
    'completed_claims',
    'canceled_claims',
    'closed_claims'
  ];

  @override
  void initState() {
    print('ahmeeeeeeeeeeeeed');
    provider = context.read<HomeProvider>();
    mainProvider = context.read<MainProvider>();
    claimsProvider = context.read<ClaimsProvider>();
    moreProvider = context.read<MoreProvider>();
    EventBusUtils.getInstance().on<ProfileEvent>().listen((event) {
      if (event.username != null) {
        provider.name = event.username!;
      }
      if (event.userImage != null) {
        provider.avatar = event.userImage!;
      }
      setState(() {});
    });

    EventBusUtils.getInstance().on<ReloadEvent>().listen((event) {
      if (event.isRefresh != null || event.isLangChanged != null) {
        mPresenter.getStatisticsApiCall();
      }
      setState(() {});
    });
    mPresenter.getStatisticsApiCall();
    // mPresenter.getProfileData();
    mPresenter.getUserName();
    mPresenter.test();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    mPresenter.getStatisticsApiCall();
    mPresenter.test();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<String> cardTitles = [
      S.current!.allClaims,
      S.current!.newClaims,
      S.current!.assignedClaims,
      S.current!.startedClaims,
      S.current!.completedClaims,
      S.current!.cancelledClaims,
      S.current!.closedClaims
    ];

    //Helper.checkEmergencyNumbersDate(provider.getAvailableFrom, provider.getAvailableTo) &&

    Widget emergencyButton(){
      if(Helper.checkEmergencyNumbersDate(provider.getAvailableFrom, provider.getAvailableTo) && provider.getCompanies.isNotEmpty){
        return FloatingActionButton(
            child: SvgPicture.asset(
              ImageUtils.getSVGPath("emergencyIcon"),
              width: 4.w,
              height: 4.h,
            ),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmergencyScreen(companies: provider.getCompanies,)),
              );
            }
        );
      } else {
        return const SizedBox();
      }
    }

    return Scaffold(
      floatingActionButton: emergencyButton(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    children: [
                      Container(
                          width: 55.w,
                          child: Column(
                            children: [
                              Text("${S.of(context)!.welcome}",
                                  style:  Theme.of(context).appBarTheme.titleTextStyle,),
                              Text("${provider.name}",
                                  maxLines: 2,
                                  style:  Theme.of(context).appBarTheme.titleTextStyle,),
                            ],
                          )
                      ),
                      Spacer(),
                      InkWell(
                          onTap: () {
                            Navigator.push(context, CupertinoPageRoute(builder: (_) => NotificationScreen()));
                          },
                          child: SvgPicture.asset(
                            color:  Theme.of(context).iconTheme.color,
                            ImageUtils.getSVGPath('notification'),
                            width: 8.w,
                            height: 8.w,
                          )),
                      SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfileScreen()));
                        },
                        child: Container(
                          width: 7.w,
                          height: 7.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(200),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(200),
                              child:
                          ImageLoader(
                            imageUrl: provider.avatar,
                            width: 16.w,
                            height: 16.w,
                            fit: BoxFit.cover,
                          ) ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                AppHeadline(
                  title: S.of(context)!.statisticsForYourClaims,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Selector<HomeProvider, List<String>>(
                  selector: (_, provider) => provider.claimsStatistics,
                  builder: (context, list, child) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 15 / 7.5,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: List.generate(
                        7,
                            (index) => HomeCardItem(
                          cardColor: cardsColor[index],
                          title: cardTitles[index],
                          imageIcon: cardImages[index],
                          value: list.isNotEmpty ? list[index] : ' ',
                          onTap: (){
                            mainProvider.tabController.index=1;
                            claimsProvider.homeFilter = mPresenter.statusList[index];
                            print('test'+claimsProvider.homeFilter);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: provider.rememberThatList.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppHeadline(title: S.of(context).rememberThat, padding: const EdgeInsets.symmetric(horizontal: 20)),
                      const SizedBox(height: 18),
                      Container(
                        height: 18.h,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (_, index) =>
                                InkWell(
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) => UnitRequestDetailsScreen(
                                            id: provider.rememberThatList[index].id,
                                            unitRequestDataBean:
                                            UnitRequestDataBean(refCode:
                                            provider.rememberThatList[index].refCode,
                                              id: provider.rememberThatList[index].id,
                                            )
                                          ),
                                        ));
                                  },
                                    child: RememberThatItem(
                                        index: index,
                                        aboutToExpireUnits: provider.rememberThatList[index])
                                ),
                            separatorBuilder: (_, index) => SizedBox(
                              width: 3.w,
                            ),
                            itemCount: provider.rememberThatList.length),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  HomePresenter createPresenter() {
    return HomePresenter();
  }
}