import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:Cliamizer/ui/units_screen/units_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../CommonUtils/image_utils.dart';
import '../../../generated/l10n.dart';
import '../../../res/colors.dart';
import '../../../res/gaps.dart';
import '../../../res/styles.dart';

class BuildContractFilePicker extends StatefulWidget {
   BuildContractFilePicker({Key? key,required this.provider}) : super(key: key);
   UnitProvider provider = UnitProvider();

  @override
  State<BuildContractFilePicker> createState() => _BuildContractFilePickerState();
}

class _BuildContractFilePickerState extends State<BuildContractFilePicker> {

  final picker = ImagePicker();
  @override
  void initState() {
    widget.provider = context.read<UnitProvider>();
    super.initState();
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'mp4', 'mov', 'avi'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      int maxFileSize = widget.provider.maxFileSize ?? 5;
      int sizeInBytes = file.lengthSync();
      double sizeInMb = sizeInBytes / (1024 * 1024);
      if (sizeInMb > maxFileSize) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: MColors.error_color,
            margin: EdgeInsets.all(8),
            behavior: SnackBarBehavior.floating,
            content: Text("${S.of(context)!.fileSizeExceeded} ($maxFileSize MB)")));
        Navigator.pop(context);
        return;
      }
      setState(() {
        widget.provider.contractImg = file;
      });
    }
    Navigator.pop(context);
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      int maxFileSize = widget.provider.maxFileSize ?? 5;
      int sizeInBytes = file.lengthSync();
      double sizeInMb = sizeInBytes / (1024 * 1024);
      if (sizeInMb > maxFileSize) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: MColors.error_color,
            margin: EdgeInsets.all(8),
            behavior: SnackBarBehavior.floating,
            content: Text("${S.of(context)!.fileSizeExceeded} ($maxFileSize MB)")));
        Navigator.pop(context);
        return;
      }
      setState(() {
        widget.provider.contractImg = file;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: MColors.error_color,
          margin: EdgeInsets.all(8),
          behavior: SnackBarBehavior.floating,
          content: Text(S.of(context)!.noImageSelected)));
      Navigator.pop(context);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UnitProvider>(
      builder: (context, pr, child) => GestureDetector(
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
                      Text(S.of(context)!.uploadImageFrom,
                          style: MTextStyles.textMain14.copyWith(color: MColors.primary_text_color)),
                      SizedBox(height: 30),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: getImageFromCamera,
                            child: Container(
                              width: 40.w,
                              padding: EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                  color: MColors.primary_color.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.camera_alt, color: MColors.primary_color),
                                  Gaps.vGap6,
                                  FittedBox(
                                    child: Text(S.of(context)!.takePhoto,
                                        style: MTextStyles.textMain12.copyWith(color: MColors.primary_color)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: pickFile,
                            child: Container(
                              width: 40.w,
                              padding: EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                  color: MColors.primary_color.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.photo_library, color: MColors.primary_color),
                                  Gaps.vGap6,
                                  FittedBox(
                                    child: Text(S.of(context)!.fromGallery,
                                        style: MTextStyles.textMain12.copyWith(color: MColors.primary_color)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: MColors.textFieldBorder), borderRadius: BorderRadius.circular(8)),
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                SvgPicture.asset(ImageUtils.getSVGPath("file_upload")),
                Gaps.hGap8,
                pr.contractImg.path.isNotEmpty
                    ? (pr.contractImg.path.toLowerCase().endsWith('.pdf')
                        ? Icon(Icons.picture_as_pdf, color: Colors.red, size: 10.w)
                        : (pr.contractImg.path.toLowerCase().endsWith('.mp4') ||
                                pr.contractImg.path.toLowerCase().endsWith('.mov') ||
                                pr.contractImg.path.toLowerCase().endsWith('.avi'))
                            ? Icon(Icons.videocam, color: Colors.blue, size: 10.w)
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  pr.contractImg,
                                  width: 10.w,
                                  height: 10.w,
                                  fit: BoxFit.cover,
                                )))
                    : Text(
                  S.of(context)!.uploadContractFile,
                  style: MTextStyles.textDark12.copyWith(color: MColors.primary_color),
                ),
                Spacer(),
                InkWell(
                  onTap: () async {
                    pr.contractFiles = [];
                    pr.contractImg = File('');
                    setState(() {});
                  },
                  child: Icon(Icons.close),
                ),
              ],
            ),
          )),
    );
  }
}
