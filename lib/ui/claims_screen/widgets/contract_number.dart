import 'package:Cliamizer/CommonUtils/renew_model.dart';
import 'package:Cliamizer/res/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../../res/colors.dart';

class ContractNumber extends StatefulWidget {
  ContractNumber({Key? key,required this.readOnly , required this.controller}) : super(key: key);
  final TextEditingController controller;
  bool readOnly;

  @override
  State<ContractNumber> createState() => _ContractNumberState();
}

class _ContractNumberState extends State<ContractNumber> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .06,
      child: TextFormField(
        controller: widget.controller,
        readOnly: widget.readOnly,
        style: MTextStyles.textDark14,
        decoration: InputDecoration(
          hintText: S.of(context)!.contractNo,
          hintStyle: MTextStyles.textMain14.copyWith(color: MColors.light_text_color, fontWeight: FontWeight.w500),
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
      ),
    );
  }
}
