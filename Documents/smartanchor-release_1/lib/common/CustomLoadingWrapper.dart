import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sizer/sizer.dart';

import '../constants/colorConst.dart';
import 'widgets.dart';

class CustomeLoading extends StatefulWidget {
  const CustomeLoading(
      {Key? key,
      required this.child,
      required this.isLoading,
      this.loadingText})
      : super(key: key);
  final Widget child;
  final bool isLoading;
  final String? loadingText;
  @override
  State<CustomeLoading> createState() => _CustomeLoadingState();
}

class _CustomeLoadingState extends State<CustomeLoading> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.isLoading)
          Container(
              height: 100.h,
              // width: size.height,

              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Container(
                  width: 70.w,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          // mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Processing...",
                              textScaleFactor: 1.4,
                              style: TextStyle(
                                  color: alizarinCrimson,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Widgets().verticalSpace(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 8.0, left: 4),
                              child: CupertinoActivityIndicator(
                                radius: 14,
                              ),
                            ),
                            Text(widget.loadingText ??
                                "Loading Data, Please wait.."),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )),
      ],
    );
  }
}
