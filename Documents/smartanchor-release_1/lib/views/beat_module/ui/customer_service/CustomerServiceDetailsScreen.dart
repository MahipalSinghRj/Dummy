import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../common/widgets.dart';
import '../../../../constants/colorConst.dart';

class CustomerServiceDetailsScreen extends StatefulWidget {
  const CustomerServiceDetailsScreen({Key? key}) : super(key: key);

  @override
  State<CustomerServiceDetailsScreen> createState() =>
      _CustomerServiceDetailsScreenState();
}

class _CustomerServiceDetailsScreenState
    extends State<CustomerServiceDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Widgets().scaffoldWithAppBarDrawer(
          context: context,
          body: Container(
            width: 100.w,
            height: 100.h,
            color: alizarinCrimson,
            child: bottomDetailsSheet(),
          )),
    );
  }

  Widget bottomDetailsSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 01,
      minChildSize: 01,
      maxChildSize: 1,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
            height: 100.h,
            decoration: Widgets()
                .commonDecorationForTopLRRadiusWithBGColor(bgColor: white),
            child: Widgets().customAll15Padding(
              child: Column(
                children: [
                  Widgets().customerServiceDetailsCardCard(
                    context: context,
                    zone: "Thane",
                    city: "Thane",
                    customerService: "Product Quality",
                    dateAndTime: "May 21, 2023 | 11:49:08",
                    employeeCode: "252154",
                    remark: "Meeting for Lighting Products",
                    state: "Maharashtra",
                    title: "Jalaram Electronic Shop",
                    businessUnit: "Lighting",
                  )
                ],
              ),
            ));
      },
    );
  }
}
