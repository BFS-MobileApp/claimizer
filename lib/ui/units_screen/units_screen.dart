import 'package:Cliamizer/base/view/base_state.dart';
import 'package:Cliamizer/ui/units_screen/units_provider.dart';
import 'package:Cliamizer/ui/units_screen/widgets/complete_new_unit.dart';
import 'package:Cliamizer/ui/units_screen/widgets/existing_unit_list.dart';
import 'package:Cliamizer/ui/units_screen/widgets/search_qr_code_view.dart';
import 'package:Cliamizer/ui/units_screen/widgets/unit_link_request.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../CommonUtils/image_utils.dart';
import '../../generated/l10n.dart';
import '../../res/colors.dart';
import '../../res/gaps.dart';
import '../../res/styles.dart';
import '../home_screen/HomeProvider.dart';
import 'units_presenter.dart';

class UnitsScreen extends StatefulWidget {
  static const String TAG = "/UnitsScreen";

  const UnitsScreen({Key? key}) : super(key: key);

  @override
  State<UnitsScreen> createState() => UnitsScreenState();
}

class UnitsScreenState extends BaseState<UnitsScreen, UnitPresenter>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  UnitProvider provider = UnitProvider();
  HomeProvider homeProvider = HomeProvider();

  @override
  void initState() {
    provider = context.read<UnitProvider>();
    homeProvider = context.read<HomeProvider>();
    super.initState();
  }
  void showErrorDialog({required String message}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xffDA1414).withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: Color(0xffDA1414),
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                S.current!.requestFailed,   // add this key to your l10n
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: MColors.primary_text_color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: MColors.light_text_color,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffDA1414),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    S.current!.ok,   // reuse existing key
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    List<String> cardTitles = [
      S.current!.newRequest,
      S.current!.existingUnit,
      S.current!.myLinkRequest,
    ];
    List<String> cardImages = [
      'new_unit_link',
      'existing_unit',
      'unit_link_request',
    ];
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Consumer<UnitProvider>(
        builder: (context, pr, child) => Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 60, 16, 0),
          child: Column(
            children: [
              // ── Header: title + tab cards ──────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section title with red left border
                    Row(
                      children: [
                        Container(
                          width: 1.w,
                          height: 5.w,
                          margin: EdgeInsetsDirectional.only(end: 2.w),
                          decoration: BoxDecoration(
                            color: MColors.primary_color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Text(
                          S.of(context)!.unitsProperty,
                          style: Theme.of(context).appBarTheme.titleTextStyle,
                        ),
                      ],
                    ),
                    Gaps.vGap16,
                    // Tab cards
                    SizedBox(
                      height: Device.height * 0.1318,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: cardTitles.length,
                        itemBuilder: (context, pageIndex) {
                          final isSelected = pr.selectedIndex == pageIndex;
                          return GestureDetector(
                            onTap: () {
                              pr.selectedIndex = pageIndex;
                            },
                            child: Card(
                              elevation: isSelected ? 2 : 0.5,
                              color: isSelected
                                  ? MColors.primary_color
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                width: 25.w,
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      ImageUtils.getSVGPath(cardImages[pageIndex]),
                                      color: isSelected
                                          ? Colors.white
                                          : MColors.primary_color,
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: 90.sp,
                                      child: AutoSizeText(
                                        cardTitles[pageIndex],
                                        style: TextStyle(
                                          fontSize: 7.sp,
                                          fontWeight: FontWeight.w500,
                                          color: isSelected
                                              ? Colors.white
                                              : MColors.light_text_color,
                                        ),
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Gaps.vGap12,
              // ── Search bar (hidden on "New Request" tab) ───────────────
              Visibility(
                visible: pr.selectedIndex != 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                  EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 8.w,
                          child: TextFormField(
                            style: MTextStyles.textDark14,
                            controller: pr.selectedIndex == 1
                                ? pr.searchController
                                : pr.unitLinkSearchController,
                            decoration: InputDecoration(
                              hintText: S.current!.search,
                              hintStyle:
                              Theme.of(context).textTheme.titleSmall,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: EdgeInsets.zero,
                              filled: true,
                              fillColor: const Color(0xffF7F7F7),
                              prefixIcon: GestureDetector(
                                onTap: () {
                                  if (pr.selectedIndex == 1) {
                                    mPresenter.getExistingUnitsApiCall({
                                      'search': provider
                                          .searchController.text
                                          .toString(),
                                    });
                                  } else if (pr.selectedIndex == 2) {
                                    mPresenter.getUnitRequestsApiCall({
                                      'search': pr
                                          .unitLinkSearchController.text
                                          .toString(),
                                    });
                                  }
                                },
                                child: Icon(
                                  CupertinoIcons.search,
                                  color: MColors.primary_light_color,
                                ),
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  if (pr.selectedIndex == 1) {
                                    pr.searchController.clear();
                                    mPresenter.getExistingUnitsApiCall({
                                      'search': '',
                                    });
                                  } else if (pr.selectedIndex == 2) {
                                    pr.unitLinkSearchController.clear();
                                    mPresenter.getUnitRequestsApiCall({
                                      'search': '',
                                    });
                                  }
                                },
                                child: Icon(
                                  Icons.cancel_rounded,
                                  color: MColors.primary_light_color,
                                ),
                              ),
                            ),
                            onFieldSubmitted: (value) {
                              if (pr.selectedIndex == 1) {
                                mPresenter.getExistingUnitsApiCall({
                                  'search': provider.searchController.text
                                      .toString(),
                                });
                              } else if (pr.selectedIndex == 2) {
                                mPresenter.getUnitRequestsApiCall({
                                  'search': pr.unitLinkSearchController.text
                                      .toString(),
                                });
                              }
                            },
                            onChanged: (value) {
                              pr.searchValue = value;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // ── Content area ───────────────────────────────────────────
              Expanded(
                child: PageView(
                  children: [
                    pr.selectedIndex == 0
                        ? !pr.isQrCodeValid
                        ? SearchAboutUnitByQR(
                      provider: provider,
                      presenter: mPresenter,
                    )
                        : CompleteNewUnit(
                      provider: provider,
                      presenter: mPresenter,
                    )
                        : pr.selectedIndex == 1
                        ? ExistingUnitList(
                      presenter: mPresenter,
                      provider: pr,
                    )
                        : UnitLinkRequest(
                      presenter: mPresenter,
                      homeProvider: homeProvider,
                      provider: pr,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  createPresenter() {
    return UnitPresenter();
  }

  @override
  bool get wantKeepAlive => true;
}

class SearchField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10.w,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: MTextStyles.textGray14,
          prefixIcon: Icon(
            Icons.search_rounded,
            color: MColors.primary_light_color,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: EdgeInsets.zero,
          filled: true,
          fillColor: const Color(0xffF7F7F7),
        ),
      ),
    );
  }
}