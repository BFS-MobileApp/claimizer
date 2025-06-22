import 'package:Cliamizer/CommonUtils/FullScreenImage.dart';
import 'package:Cliamizer/app_widgets/image_loader.dart';
import 'package:Cliamizer/generated/l10n.dart';
import 'package:Cliamizer/res/colors.dart';
import 'package:Cliamizer/res/gaps.dart';
import 'package:Cliamizer/res/styles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class UnitDetailsFiles extends StatelessWidget {

  String contractImage;
  String idImage;
  UnitDetailsFiles({super.key , required this.contractImage , required this.idImage});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S.of(context)!.allFiles,
            style: Theme.of(context).appBarTheme.titleTextStyle),
        Gaps.vGap12,
        SizedBox(
          height: 74,
          child: (contractImage != '' || idImage != '') ? Row(
            children: [
              contractImage != '' ? InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return FullScreenImage(image: contractImage,);
                  }));
                },
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    child: ImageLoader(
                      imageUrl: contractImage,
                      width: 16.w,
                      height: 16.w,
                    )),
              ) : SizedBox(),
              SizedBox(width: 15,),
              idImage != '' ? InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return FullScreenImage(image: idImage,);
                  }));
                },
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    child: ImageLoader(
                      imageUrl: idImage,
                      width: 16.w,
                      height: 16.w,
                    )),
              ) : SizedBox()

            ],
          ): Text(S.of(context)!.noFiles),
        ),
        Gaps.vGap12,
      ],
    );
  }
}
