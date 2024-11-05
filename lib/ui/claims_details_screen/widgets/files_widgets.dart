import 'package:Cliamizer/app_widgets/image_loader.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../CommonUtils/FullScreenImage.dart';
import '../../../generated/l10n.dart';
import '../../../res/colors.dart';
import '../../../res/gaps.dart';
import '../../../res/styles.dart';

class FilesWidget extends StatelessWidget {
  final List<dynamic> apiStrings;
  final int count;

  const FilesWidget({Key? key,required this.count, required this.apiStrings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(apiStrings[0]['file_url']);
    /*List<Widget> stringWidgets = [];

    for (String apiString in apiStrings) {
      print(apiString);
      // extract values from apiString and add them to a widget
      stringWidgets.add(ImageLoader(
        imageUrl: apiString[0]['file_url'],
        width: 16.w,
        height: 16.w,
      ));
    }*/
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S.of(context)!.allFiles,
            style: MTextStyles.textMain16.copyWith(
              color: MColors.black,
            )),
        Gaps.vGap12,
        SizedBox(
          height: 74,
          child: apiStrings.isNotEmpty ?  ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: count,
            itemBuilder: (context, index) => GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return FullScreenImage(image: apiStrings[index]['file_url'],);
                }));
              },
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  child: ImageLoader(
                    imageUrl: apiStrings[index]['file_url'],
                    width: 16.w,
                    height: 16.w,
                  )),
            ),
          ): Text(S.of(context)!.noFiles),
        ),
        Gaps.vGap12,
      ],
    );
  }
}
