import 'package:Cliamizer/ui/units_screen/units_presenter.dart';
import 'package:Cliamizer/ui/units_screen/units_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../generated/l10n.dart';
import '../../../res/colors.dart';
import '../../../res/gaps.dart';
import '../../../res/styles.dart';
import 'build_qrcode_field.dart';

enum UnitSearchOption {
  unitLinkQR,
  mobileNumber,
  emailID,
  nationalID,
  passportNumber,
}

class SearchAboutUnitByQR extends StatefulWidget {
  const SearchAboutUnitByQR({
    Key? key,
    required this.provider,
    required this.presenter,
  }) : super(key: key);

  final UnitProvider provider;
  final UnitPresenter presenter;

  @override
  State<SearchAboutUnitByQR> createState() => _SearchAboutUnitByQRState();
}

class _SearchAboutUnitByQRState extends State<SearchAboutUnitByQR> {
  UnitSearchOption _selectedOption = UnitSearchOption.unitLinkQR;
  bool _showDetail = false;

  // Controllers for the dynamic form
  final TextEditingController _dynamicFieldController = TextEditingController();
  final TextEditingController _contractNumberController = TextEditingController();
  final TextEditingController _contractStartDateController = TextEditingController();
  final TextEditingController _contractEndDateController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _dynamicFieldController.dispose();
    _contractNumberController.dispose();
    _contractStartDateController.dispose();
    _contractEndDateController.dispose();
    super.dispose();
  }

  void _onNext() => setState(() => _showDetail = true);
  void _onBack() => setState(() => _showDetail = false);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.05, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: _showDetail
          ? KeyedSubtree(key: const ValueKey('detail'), child: _buildDetailView(context))
          : KeyedSubtree(key: const ValueKey('choice'), child: _buildChoiceView(context)),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SCREEN 1 — radio choice list
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildChoiceView(BuildContext context) {
    final options = [
      _OptionItem(value: UnitSearchOption.unitLinkQR,     label: S.of(context)!.unitLinkQR),
      _OptionItem(value: UnitSearchOption.mobileNumber,   label: S.of(context)!.mobileNumber),
      _OptionItem(value: UnitSearchOption.emailID,        label: S.of(context)!.emailID),
      _OptionItem(value: UnitSearchOption.nationalID,     label: S.of(context)!.nationalIDTradeLicense),
      _OptionItem(value: UnitSearchOption.passportNumber, label: S.of(context)!.passportNumber),
    ];

    return ListView(
      padding: EdgeInsets.symmetric(vertical: 2.w),
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 4.w),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: AutoSizeText(
                  S.current!.newLinkRequest,
                  style: Theme.of(context)
                      .appBarTheme
                      .titleTextStyle
                      ?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              Gaps.vGap15,
              _sectionHeader(context, S.of(context)!.chooseOptionToFindUnit),
              Gaps.vGap16,
              ...options.map((o) => _buildRadioTile(context, o)),
              Gaps.vGap8,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MColors.primary_color,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.symmetric(vertical: 2.w),
                  ),
                  child: Text(
                    S.of(context)!.next,
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRadioTile(BuildContext context, _OptionItem option) {
    final isSelected = _selectedOption == option.value;
    return GestureDetector(
      onTap: () => setState(() => _selectedOption = option.value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? MColors.primary_color : const Color(0xffE5E5E5),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? MColors.primary_color : const Color(0xffCCCCCC),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: MColors.primary_color),
                ),
              )
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              option.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                color: isSelected ? MColors.primary_text_color : MColors.light_text_color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SCREEN 2 — detail view
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildDetailView(BuildContext context) {
    if (_selectedOption == UnitSearchOption.unitLinkQR) {
      return _buildQRDetailView(context);
    }
    return _buildDynamicFormView(context);
  }

  // ── Unit Link (QR) ───────────────────────────────────────────────────────
  Widget _buildQRDetailView(BuildContext context) {
    return Consumer<UnitProvider>(
      builder: (context, pr, child) => ListView(
        padding: EdgeInsets.symmetric(vertical: 2.w),
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 4.w),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailHeader(context, S.of(context)!.unitLinkQR),
                Gaps.vGap8,
                Text(
                  S.of(context)!.pasteUnitLinkOrScan,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 12, color: MColors.light_text_color),
                ),
                Gaps.vGap16,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 5.h,
                      width: 40.w,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final data = await Clipboard.getData(Clipboard.kTextPlain);
                          if (data?.text != null) pr.qrCode.text = data!.text!;
                        },
                        icon: const Icon(Icons.content_paste_rounded, size: 16, color: Colors.white),
                        label: Text(S.of(context)!.paste,style: TextStyle(fontSize: 15,color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MColors.primary_color,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 2.w),
                        ),
                      ),
                    ),

                    SizedBox(width: 2.w),

                    SizedBox(
                      height: 5.h,
                      width: 40.w,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (pr.qrCode.text.isEmpty) {
                            widget.presenter.view.showToasts(
                              S.of(context)!.pleaseEnterQrCode,
                              'warning',
                            );
                          } else {
                            widget.presenter.checkLinkHasParams(pr.qrCode.text);
                          }
                        },
                        icon: const Icon(Icons.qr_code_scanner_rounded, size: 16, color: Colors.white),
                        label: Text(
                          S.of(context)!.scan,
                          style: const TextStyle(color: Colors.white,fontSize: 15),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MColors.primary_color,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 2.w),
                        ),
                      ),
                    ),
                  ],
                ),
                Gaps.vGap16,
                BuildQRCodeField(provider: widget.provider),
                Gaps.vGap8,
                Text(
                  S.of(context)!.qrCodeTip,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 11, color: MColors.light_text_color),
                ),
                Gaps.vGap16,
                SizedBox(
                  height: 5.5.h,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (pr.qrCode.text.isEmpty) {
                        widget.presenter.view.showToasts(S.of(context)!.pleaseEnterQrCode, 'warning');
                      } else {
                        widget.presenter.checkLinkHasParams(pr.qrCode.text);
                      }
                    },
                    icon: const Icon(Icons.search_rounded, color: Colors.white, size: 20),
                    label: Text(S.of(context)!.search, style: const TextStyle(color: Colors.white,fontSize: 15)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MColors.primary_color,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: EdgeInsets.symmetric(vertical: 3.w),
                    ),
                  ),
                ),
                Gaps.vGap8,
                Visibility(
                  visible: pr.message != null,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xffDA1414).withOpacity(0.10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      pr.message ?? "",
                      style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                        color: const Color(0xffDA1414),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Dynamic form (Mobile / Email / National ID / Passport) ───────────────
  Widget _buildDynamicFormView(BuildContext context) {
    // Resolve label & hint for the dynamic first field
    final String dynamicLabel;
    final String dynamicHint;
    final TextInputType dynamicKeyboard;

    switch (_selectedOption) {
      case UnitSearchOption.mobileNumber:
        dynamicLabel = S.of(context)!.mobileNumber;
        dynamicHint  = S.of(context)!.mobileNumber;
        dynamicKeyboard = TextInputType.phone;
        break;
      case UnitSearchOption.emailID:
        dynamicLabel = S.of(context)!.emailID;
        dynamicHint  = S.of(context)!.emailID;
        dynamicKeyboard = TextInputType.emailAddress;
        break;
      case UnitSearchOption.nationalID:
        dynamicLabel = S.of(context)!.nationalIDTradeLicense;
        dynamicHint  = S.of(context)!.nationalIDTradeLicense;
        dynamicKeyboard = TextInputType.text;
        break;
      case UnitSearchOption.passportNumber:
        dynamicLabel = S.of(context)!.passportNumber;
        dynamicHint  = S.of(context)!.passportNumber;
        dynamicKeyboard = TextInputType.text;
        break;
      default:
        dynamicLabel = '';
        dynamicHint  = '';
        dynamicKeyboard = TextInputType.text;
    }

    return ListView(
      padding: EdgeInsets.symmetric(vertical: 2.w),
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 4.w),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back arrow + section title with red bar
              _detailHeader(context, S.of(context)!.fillAllFields),
              Gaps.vGap15,

              // ── Dynamic first field ──────────────────────────────────
              _buildFormLabel(context, dynamicLabel),
               Gaps.vGap5,
              _buildTextField(
                controller: _dynamicFieldController,
                hint: dynamicHint,
                keyboardType: dynamicKeyboard,
              ),
              Gaps.vGap8,

              // ── Contract Number ──────────────────────────────────────
              _buildFormLabel(context, S.of(context)!.contractNumber),
               Gaps.vGap5,
              _buildTextField(
                controller: _contractNumberController,
                hint: S.of(context)!.contractNumber,
                keyboardType: TextInputType.text,
              ),
              Gaps.vGap8,
              _buildFormLabel(context, S.of(context)!.contractStartDate),
               Gaps.vGap5,
              GestureDetector(
                onTap: () => _pickDate(context,true),
                child: AbsorbPointer(
                  child: _buildTextField(
                    controller: _contractStartDateController,
                    hint: S.of(context)!.contractStartDate,
                    keyboardType: TextInputType.none,
                    suffixIcon: Icon(
                      Icons.calendar_month_rounded,
                      color: MColors.primary_color,
                      size: 22,
                    ),
                  ),
                ),
              ),
              Gaps.vGap8,
              // ── Contract End Date ────────────────────────────────────
              _buildFormLabel(context, S.of(context)!.contractEndDate),
               Gaps.vGap5,
              GestureDetector(
                onTap: () => _pickDate(context,false),
                child: AbsorbPointer(
                  child: _buildTextField(
                    controller: _contractEndDateController,
                    hint: S.of(context)!.contractEndDate,
                    keyboardType: TextInputType.none,
                    suffixIcon: Icon(
                      Icons.calendar_month_rounded,
                      color: MColors.primary_color,
                      size: 22,
                    ),
                  ),
                ),
              ),
              Gaps.vGap8,

              SizedBox(
                height: 5.5.h,
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _onSearchOtherOption(context, dynamicLabel),
                  icon: const Icon(Icons.search_rounded, color: Colors.white, size: 20),
                  label: Text(S.of(context)!.search, style: const TextStyle(color: Colors.white,fontSize: 15)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MColors.primary_color,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.symmetric(vertical: 3.w),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Date picker
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> _pickDate(BuildContext context, bool IsStart) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: MColors.primary_color,
            onPrimary: Colors.white,
            onSurface: MColors.primary_text_color,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: MColors.primary_color,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size(60, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: TextStyle(fontSize: 15),
            ),
          ),
        ),
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: 0.85,
          ),
          child: Transform.scale(
            scale: 0.9,
            child: child!,
          ),
        ),
      ),
    );
    if (picked != null && IsStart) {
      setState(() {
        _selectedDate = picked;
        _contractStartDateController.text =
        '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }else if(picked != null && !IsStart){
      setState(() {
        _selectedDate = picked;
        _contractEndDateController.text =
        '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Search handler for non-QR options — calls the presenter API
  // ─────────────────────────────────────────────────────────────────────────
  void _onSearchOtherOption(BuildContext context, String dynamicLabel) {
    if (_dynamicFieldController.text.isEmpty) {
      widget.presenter.view.showToasts(
          '${S.of(context)!.pleaseEnter} $dynamicLabel', 'warning');
      return;
    }
    if (_contractNumberController.text.isEmpty) {
      widget.presenter.view.showToasts(
          '${S.of(context)!.pleaseEnter} ${S.of(context)!.contractNumber}', 'warning');
      return;
    }
    if (_contractEndDateController.text.isEmpty) {
      widget.presenter.view.showToasts(
          '${S.of(context)!.pleaseEnter} ${S.of(context)!.contractEndDate}', 'warning');
      return;
    }



     widget.presenter.searchUnitByDetails({'type' : "ERP_person_mobile" ,
       'value' : _dynamicFieldController.text.trim(),
     'contract_number' : _contractNumberController.text.trim(),
     'contract_start' : _contractStartDateController.text.trim()},_dynamicFieldController.text.trim(),
       _contractNumberController.text.trim(),_contractStartDateController.text.trim(),_contractEndDateController.text.trim());
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Shared UI helpers
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildFormLabel(BuildContext context, String label) {
    return Row(
      children: [
        Text(
          '* ',
          style: TextStyle(color: MColors.primary_color, fontWeight: FontWeight.w600, fontSize: 13),
        ),
        Text(
          label,
          style: TextStyle(color: MColors.primary_text_color, fontWeight: FontWeight.w500, fontSize: 13),
        ),
        // const SizedBox(width: 8),
        // Text(
        //   S.of(context)!.required,
        //   style: TextStyle(color: MColors.primary_color, fontSize: 12),
        // ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required TextInputType keyboardType,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: MTextStyles.textDark14,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.titleSmall,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.w),
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xffE5E5E5), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: MColors.primary_color, width: 1.2),
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Row(
      children: [
        Container(
          width: 1.w,
          height: 5.w,
          margin: EdgeInsetsDirectional.only(end: 2.w),
          decoration: BoxDecoration(color: MColors.primary_color, borderRadius: BorderRadius.circular(4)),
        ),
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: MColors.primary_text_color),
        ),
      ],
    );
  }

  Widget _detailHeader(BuildContext context, String title) {
    return Row(
      children: [
        GestureDetector(
          onTap: _onBack,
          child: Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: MColors.primary_color),
        ),
        SizedBox(width: 2.w),
        Container(
          width: 1.w,
          height: 5.w,
          margin: EdgeInsetsDirectional.only(end: 2.w),
          decoration: BoxDecoration(color: MColors.primary_color, borderRadius: BorderRadius.circular(4)),
        ),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _OptionItem {
  final UnitSearchOption value;
  final String label;
  const _OptionItem({required this.value, required this.label});
}