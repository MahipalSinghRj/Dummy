import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../common/widgets.dart';
import '../../../../constants/colorConst.dart';

class CustomerFMCDDetailsScreen extends StatefulWidget {
  const CustomerFMCDDetailsScreen({Key? key}) : super(key: key);

  @override
  State<CustomerFMCDDetailsScreen> createState() =>
      _CustomerFMCDDetailsScreenState();
}

class _CustomerFMCDDetailsScreenState extends State<CustomerFMCDDetailsScreen> {
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
                  Widgets().customerFMCDDetailsCardCard(
                    context: context,
                    zone: "Thane",
                    city: "Thane",
                    address:
                        "13 -b Basera Apartment New Lokhandwala Complex Andheri",
                    dateAndTime: "May 21, 2023 | 11:49:08",
                    employeeCode: "252154",
                    information: "Meeting for Lighting Products",
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
