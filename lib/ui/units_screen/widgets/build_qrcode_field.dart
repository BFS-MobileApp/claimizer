import 'package:Cliamizer/res/styles.dart';
import 'package:Cliamizer/ui/scanner_screen/scanner_screen.dart';
import 'package:Cliamizer/ui/units_screen/units_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../generated/l10n.dart';
import '../../../res/colors.dart';

class BuildQRCodeField extends StatelessWidget {
  const BuildQRCodeField({Key? key,required this.provider}) : super(key: key);
  final UnitProvider provider;

  @override
  Widget build(BuildContext context) {
    return Consumer<UnitProvider>(
      builder: (context, pr, child) => TextFormField(

        controller: pr.qrCode,
        style:Theme.of(context).appBarTheme.titleTextStyle,
        maxLines: null,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 35.0),
          hintText: S.of(context)!.qrCode,
          hintStyle: Theme.of(context).appBarTheme.titleTextStyle,
          // suffixIcon: SvgPicture.asset(ImageUtils.getSVGPath('scan')),
          prefixIcon: InkWell(
              onTap: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => ScannerScreen(
                            onScanDone: (value) {
                              pr.qrCode.text = value;
                            },
                          ))),
              child: Icon(
                Icons.qr_code_rounded,
                color: MColors.primary_color,
              )),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: MColors.textFieldBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: MColors.textFieldBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: MColors.textFieldBorder),
          ),
        ),
        // onChanged: (value) {
        //   pr.qrCode.text = value;
        // },
      ),
    );
  }
}
