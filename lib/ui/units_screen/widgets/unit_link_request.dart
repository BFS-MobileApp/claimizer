import 'package:Cliamizer/app_widgets/NoDataFound.dart';
import 'package:Cliamizer/ui/home_screen/HomeProvider.dart';
import 'package:Cliamizer/ui/units_screen/units_presenter.dart';
import 'package:Cliamizer/ui/units_screen/units_provider.dart';
import 'package:Cliamizer/ui/units_screen/widgets/unit_request_item_data.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../CommonUtils/model_eventbus/EventBusUtils.dart';
import '../../../CommonUtils/model_eventbus/ReloadHomeEevet.dart';
import '../../../generated/l10n.dart';
import '../../../res/colors.dart';
import '../../../res/gaps.dart';
import '../../unit_request_details_screen/UnitDetailsScreen.dart';

class UnitLinkRequest extends StatefulWidget {
  UnitLinkRequest({Key? key, required this.presenter, required this.homeProvider, required this.provider}) : super(key: key);
  final UnitPresenter presenter;
  final HomeProvider homeProvider;
  UnitProvider provider;

  @override
  State<UnitLinkRequest> createState() => _UnitLinkRequestState();
}

class _UnitLinkRequestState extends State<UnitLinkRequest> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    print('UnitLinkRequest');
    widget.provider = context.read<UnitProvider>();
    EventBusUtils.getInstance().on<ReloadEvent>().listen((event) {
      if (event.isRefresh != null || event.isLangChanged != null) {
        Map<String, dynamic> linkRequestParams = Map();
        linkRequestParams['search'] = widget.provider.searchController.text.toString();
        widget.presenter.getUnitRequestsApiCall(linkRequestParams);
      }
      setState(() {});
    });
    Map<String, dynamic> linkRequestParams = Map();
    linkRequestParams['search'] = widget.provider.searchController.text.toString();
    widget.presenter.getUnitRequestsApiCall(linkRequestParams);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UnitProvider>(
      builder: (context, pr, child) => pr.unitsRequestList.isNotEmpty
          ? RefreshIndicator(
        onRefresh: () async {
          Map<String, dynamic> linkRequestParams = Map();
          linkRequestParams['search'] = widget.provider.searchController.text.toString();
          widget.presenter.getUnitRequestsApiCall(linkRequestParams);
          pr.unitLinkSearchController.clear();
        },
        child: ListView.builder(
          controller: _scrollController,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
          itemCount: pr.unitsRequestList.length,
          itemBuilder: (context, index) {
            final item = pr.unitsRequestList[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => UnitRequestDetailsScreen(
                        id: item.id!,
                        unitRequestDataBean: item,
                      ),
                    ));
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                margin: EdgeInsets.only(bottom: 3.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context)!.unitRequestCode,
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            SizedBox(height: 1.w),
                            Text(
                              item.refCode ?? "",
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        ),
                        SizedBox(width: 2.w),
                        _buildStatusBadge(item.status ?? ""),
                      ],
                    ),

                    SizedBox(height: 3.w),
                    Divider(color: Colors.grey.shade200, thickness: 1, height: 1),
                    SizedBox(height: 3.w),

                    // Detail Rows
                    _buildDetailRow(S.of(context)!.unitName, item.unitName ?? ""),
                    _buildDividerRow(),
                    _buildDetailRow(S.of(context)!.buildingName, item.buildingName ?? ""),
                    _buildDividerRow(),
                    _buildDetailRow(S.of(context)!.unitType, item.unitType ?? ""),
                    _buildDividerRow(),
                    _buildDetailRow(S.of(context)!.company, item.company ?? ""),
                    _buildDividerRow(),
                    _buildDetailRow(S.of(context)!.contractNo, item.contractNumber ?? ""),
                    _buildDividerRow(),
                    _buildDetailRow(S.of(context)!.startAt, item.startAt ?? ""),
                    _buildDividerRow(),
                    _buildDetailRow(S.of(context)!.endAt, item.endAt ?? ""),
                  ],
                ),
              ),
            );
          },
        ),
      )
          : NoDataWidget(onRefresh: () async {
        Map<String, dynamic> linkRequestParams = Map();
        linkRequestParams['search'] = widget.provider.searchController.text.toString();
        widget.presenter.getUnitRequestsApiCall(linkRequestParams);
      }),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'approved':
        bgColor = Color(0xFFE8F5E9);
        textColor = Color(0xFF2E7D32);
        break;
      case 'pending':
        bgColor = Color(0xFFFFF8E1);
        textColor = Color(0xFFF9A825);
        break;
      case 'rejected':
        bgColor = Color(0xFFFFEBEE);
        textColor = Color(0xFFC62828);
        break;
      default:
        bgColor = widget.presenter.getUnitStatusColorFromString(status.toLowerCase()).withOpacity(0.15);
        textColor = widget.presenter.getUnitStatusColorFromString(status.toLowerCase());
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDividerRow() {
    return Divider(
      color: Colors.grey.shade100,
      thickness: 1,
      height: 1,
    );
  }
}