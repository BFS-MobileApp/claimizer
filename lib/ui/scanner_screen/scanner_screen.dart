import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../app_widgets/claimizer_app_bar.dart';
import '../../generated/l10n.dart';
import '../../res/colors.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key, required this.onScanDone}) : super(key: key);

  final Function(String) onScanDone;

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  MobileScannerController controller = MobileScannerController();
  bool isScanned = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              ClaimizerAppBar(title: S.of(context)!.qrScanner),
              Expanded(
                child: Container(
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: Container(
                    width: 90.w,
                    height: 90.w,
                    padding: EdgeInsets.all(20),
                    alignment: Alignment.center,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                            top: -10,
                            left: -10,
                            child: Image.asset(
                              'assets/images/top.png',
                              color: MColors.primary_color,
                            )),
                        Positioned(
                            top: -10,
                            right: -10,
                            child: Image.asset(
                              'assets/images/top_end.png',
                              color: MColors.primary_color,
                            )),
                        Positioned(
                            bottom: -10,
                            left: -10,
                            child: Image.asset(
                              'assets/images/bottom_start.png',
                              color: MColors.primary_color,
                            )),
                        Positioned(
                            bottom: -10,
                            right: -10,
                            child: Image.asset(
                              'assets/images/bottom_end.png',
                              color: MColors.primary_color,
                            )),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: MobileScanner(
                            controller: controller,
                            onDetect: (BarcodeCapture capture) {
                              final List<Barcode> barcodes = capture.barcodes;
                              if (barcodes.isNotEmpty && !isScanned) {
                                final String? code = barcodes.first.rawValue;
                                if (code != null) {
                                  setState(() {
                                    isScanned = true;
                                  });
                                  widget.onScanDone(code);
                                  Navigator.pop(context);
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
