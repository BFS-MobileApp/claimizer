import 'package:Cliamizer/CommonUtils/renew_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../generated/l10n.dart';
import '../../../res/colors.dart';

class DateItem extends StatefulWidget {
   RenewModel model;
   DateItem({Key? key,required this.model}) : super(key: key);
  @override
  _StartEndDatePickerFieldState createState() => _StartEndDatePickerFieldState();
}

class _StartEndDatePickerFieldState extends State<DateItem> {
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd',"en");

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async{
              final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.parse(widget.model.startDate),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now().add(Duration(days: 100000)));
              if (picked != null) {
                print(picked);
                setState(() {
                  widget.model.startDate = picked.toString();
                });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: MColors.textFieldBorder),
              ),
              padding: EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.model.startDate ==''  ? Text(
                    S.of(context)!.startDate,
                  ) :
                  Text(
                    _dateFormat.format(DateTime.parse(widget.model.startDate)),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: GestureDetector(
            onTap: () async{
              final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.parse(widget.model.endDate),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now().add(Duration(days: 100000)));
              if (picked != null) {
                setState(() {
                  widget.model.endDate = picked.toString();
                });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: MColors.textFieldBorder),
              ),
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.model.endDate == '' ? Text(
                    S.of(context)!.endDate,
                  ) : Text(
    _dateFormat.format(DateTime.parse(widget.model.endDate)),),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
