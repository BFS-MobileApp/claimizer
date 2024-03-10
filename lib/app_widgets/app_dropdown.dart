import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../res/colors.dart';

class AppDropdown extends StatelessWidget {
  const AppDropdown({
    Key? key,
    required this.items,
    required this.onChange,
    required this.selectedItem,
    this.prefixIcon,
    this.dropdownHeight,
    required this.validator,
  }) : super(key: key);

  final List<String> items;
  final Function(String) onChange;
  final String? selectedItem;
  final Icon? prefixIcon;
  final double? dropdownHeight;
  final Function(String) validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      child: DropdownSearch<String>(
        enabled: true,
        items: items,
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            prefixIcon: prefixIcon,
            filled: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12,vertical: 0),
            fillColor: MColors.gray_ce.withOpacity(.2),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                BorderSide(color: Theme.of(context).focusColor)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                BorderSide(color: Theme.of(context).focusColor)),

          ),
        ),
        onChanged: (value)=>onChange(value!),
        validator: (text) {
          return validator(text!);
        },
        selectedItem: selectedItem,

      ),
    );
  }

  DropdownMenuItem<String> buildDropdownItem(String itemAsString, BuildContext context) {
    return DropdownMenuItem<String>(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: MColors.gray_ce.withOpacity(.2),
          border: Border.all(color: Theme.of(context).focusColor),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          itemAsString,
          style: TextStyle(fontSize: 14.sp),
        ),
      ),
      value: itemAsString,
    );
  }
}
