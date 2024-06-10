import 'dart:io';

import 'package:Cliamizer/CommonUtils/image_utils.dart';
import 'package:Cliamizer/CommonUtils/renew_model.dart';
import 'package:Cliamizer/generated/l10n.dart';
import 'package:Cliamizer/res/colors.dart';
import 'package:Cliamizer/res/gaps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../../res/styles.dart';

class ImagePickerWidget extends StatefulWidget {
  ImagePickerWidget({Key? key, required this.model , required this.itemName , required this.isContractImage}) : super(key: key);
  final RenewModel model;

  final String itemName;

  bool isContractImage;

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if(widget.isContractImage){
          widget.model.setContractImage = File(pickedFile.path);
        } else {
          widget.model.setIdentifyImage = File(pickedFile.path);
        }
      });
    }
    Navigator.pop(context);
  }

  Future<void> getImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        if(widget.isContractImage){
          widget.model.setContractImage = File(pickedFile.path);
        } else {
          widget.model.setIdentifyImage = File(pickedFile.path);
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: MColors.error_color,
        margin: EdgeInsets.all(8),
        behavior: SnackBarBehavior.floating,
        content: Text(S.of(context)!.noImageSelected),
      ));
    }
    Navigator.pop(context);
  }

  Widget imageWidget(){
    if(widget.isContractImage){
      if(widget.model.contractImage.path !=''){
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            widget.model.contractImage,
            width: 10.w,
            height: 10.w,
            fit: BoxFit.cover,
          ),
        );
      } else {
        return Text(
          widget.itemName,
          style: MTextStyles.textDark14,
        );
      }
    } else {
      if(widget.model.identifyImage.path !=''){
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            widget.model.identifyImage,
            width: 10.w,
            height: 10.w,
            fit: BoxFit.cover,
          ),
        );
      } else {
        return Text(
          widget.itemName,
          style: MTextStyles.textDark14,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              insetPadding: EdgeInsets.all(20),
              contentPadding: EdgeInsets.all(16),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60.w,
                    child: ElevatedButton.icon(
                      onPressed: getImageFromCamera,
                      icon: Icon(Icons.camera_alt, color: MColors.text_button_color),
                      label: Text(
                        S.of(context)!.takePhoto,
                        style: MTextStyles.textMain14.copyWith(color: MColors.text_button_color),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 60.w,
                    child: ElevatedButton.icon(
                      onPressed: pickImageFromGallery,
                      icon: Icon(Icons.photo_library, color: MColors.text_button_color),
                      label: Text(
                        S.of(context)!.chooseFromGallery,
                        style: MTextStyles.textMain14.copyWith(color: MColors.text_button_color),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: MColors.textFieldBorder),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            SvgPicture.asset(ImageUtils.getSVGPath("file_upload")),
            Gaps.hGap8,
            imageWidget(),
            Spacer(),
            InkWell(
              onTap: () async {
                setState(() {
                  widget.model.setContractImage = File('');
                });
              },
              child: Icon(Icons.close),
            ),
          ],
        ),
      ),
    );
  }
}
