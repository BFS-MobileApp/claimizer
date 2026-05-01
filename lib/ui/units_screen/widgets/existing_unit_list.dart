import 'package:Cliamizer/app_widgets/NoDataFound.dart';
import 'package:Cliamizer/ui/units_screen/units_presenter.dart';
import 'package:Cliamizer/ui/units_screen/units_provider.dart';
import 'package:Cliamizer/ui/units_screen/widgets/unit_card_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../generated/l10n.dart';
import '../../../res/colors.dart';
import '../../../res/gaps.dart';
import '../../../res/styles.dart';

class ExistingUnitList extends StatefulWidget {
  ExistingUnitList({Key? key, required this.presenter, required this.provider}) : super(key: key);
  final UnitPresenter presenter;
  UnitProvider provider;

  @override
  State<ExistingUnitList> createState() => _ExistingUnitListState();
}

class _ExistingUnitListState extends State<ExistingUnitList> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    print('Existing Unit');
    widget.provider = context.read<UnitProvider>();
    Map<String, dynamic> params = Map();
    params['search'] = widget.provider.searchController.text.toString();
    widget.presenter.getExistingUnitsApiCall(params);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UnitProvider>(
      builder: (context, pr, child) {
        return pr.unitsList.isNotEmpty
            ? RefreshIndicator(
          onRefresh: () async {
            pr.searchController.clear();
            Map<String, dynamic> params = Map();
            params['search'] = widget.provider.searchController.text.toString();
            await widget.presenter.getExistingUnitsApiCall(params);
          },
          child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            itemCount: pr.unitsList.length,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
            itemBuilder: (context, index) {
              return _buildUnitCard(context, pr, index);
            },
          ),
        )
            : NoDataWidget(
          onRefresh: () async {
            Map<String, dynamic> params = Map();
            params['search'] = widget.provider.searchController.text.toString();
            await widget.presenter.getExistingUnitsApiCall(params);
          },
        );
      },
    );
  }

  Widget _buildUnitCard(BuildContext context, dynamic pr, int index) {
    final unit = pr.unitsList[index];

    return Container(
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
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Name + Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        unit.name ?? "",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      SizedBox(height: 1.w),
                      Text(
                        "${unit.id ?? ""} - ${unit.building ?? ""}",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 2.w),
                // _buildStatusBadge(unit.type),
              ],
            ),

            SizedBox(height: 3.w),
            Divider(color: Colors.grey.shade200, thickness: 1, height: 1),
            SizedBox(height: 3.w),

            // Detail Rows
            _buildDetailRow(context, S.of(context)!.unitName, unit.name ?? ""),
            _buildDividerRow(),
            _buildDetailRow(context, S.of(context)!.buildingName, unit.building ?? ""),
            _buildDividerRow(),
            _buildDetailRow(context, S.of(context)!.unitType, unit.type ?? ""),
            _buildDividerRow(),
            _buildDetailRow(context, S.of(context)!.company, unit.company ?? ""),
            _buildDividerRow(),
            _buildDetailRow(context, S.of(context)!.contractNo, unit.id.toString()),
            _buildDividerRow(),
            _buildDetailRow(context, S.of(context)!.startAt, unit.startAt ?? ""),
            _buildDividerRow(),
            _buildDetailRow(context, S.of(context)!.endAt, unit.endAt ?? ""),
          ],
        ),
      ),
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
        bgColor = Color(0xFFE8F5E9);
        textColor = Color(0xFF2E7D32);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: Theme.of(context).textTheme.displaySmall,
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String title, String value) {
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