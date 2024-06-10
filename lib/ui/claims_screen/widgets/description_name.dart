import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../../res/colors.dart';
import '../../../res/styles.dart';

class DescriptionField extends StatelessWidget {
  const DescriptionField({Key? key,required this.controller}) : super(key: key);
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 3,
      style: MTextStyles.textDark14,
      validator: (val){
        if(val!.isEmpty){
          return S.of(context)!.descriptionRequired;
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: S.of(context)!.writeYourThoughtsHere,
        hintStyle: MTextStyles.textMain14.copyWith(
            color: MColors.secondary_text_color
        ),
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
    );
  }
}
