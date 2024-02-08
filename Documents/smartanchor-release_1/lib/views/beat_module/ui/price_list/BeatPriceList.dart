import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../common/widgets.dart';
import '../../../../constants/colorConst.dart';

class PriceList extends StatefulWidget {
  const PriceList({Key? key}) : super(key: key);

  @override
  State<PriceList> createState() => _BeatPriceListState();
}

class _BeatPriceListState extends State<PriceList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Widgets().scaffoldWithAppBarDrawer(
          context: context,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Widgets().verticalSpace(2.h),
                Widgets().customLRPadding(
                  child: ListView.builder(
                    itemCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Widgets().beatPriceListExpantionCard(
                          context: context,
                          customerCode: 'ABTM04247',
                          itemName: 'ABTM04247-ANMOL LED BATTEN 24W 6500K',
                          warehouse: 'Mumbai',
                          mrp: '₹ 166',
                          dlp: '₹ 150',
                          masterQTY: '25',
                          statusColor: malachite,
                          createdAt: '22/09/2023',
                          businessUnit: 'LIGHTING',
                          status: 'Active',
                          updatedAt: '25/09/2023');
                    },
                  ),
                ),
                Widgets().verticalSpace(2.h),
              ],
            ),
          )),
    );
  }
}
