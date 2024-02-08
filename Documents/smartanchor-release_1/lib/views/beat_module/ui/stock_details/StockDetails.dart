import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../common/widgets.dart';

class StockDetails extends StatefulWidget {
  const StockDetails({Key? key}) : super(key: key);

  @override
  State<StockDetails> createState() => _StockDetailsState();
}

class _StockDetailsState extends State<StockDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

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
                    itemCount: 5,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Widgets().stockDetailsCardList(
                        context: context,
                        onTap: () {},
                        code: '41PBUM36157',
                        grossStock: '1',
                        unusableStock: '-',
                        warehouseCode: '20',
                        soldStock: '180',
                        sellableStock: '-180',
                        productCode: 'PBUM36157',
                      );
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
