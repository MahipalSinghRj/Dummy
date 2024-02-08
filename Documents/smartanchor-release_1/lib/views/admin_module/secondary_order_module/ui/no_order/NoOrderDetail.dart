import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/utils/DateTimeUtils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../common/AppBar.dart';
import '../../../../../common/Drawer.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../utils/functionsUtils.dart';
import '../../controllers/RetailerNoOrderController.dart';


class AdminSecondaryNoOrderDetail extends StatefulWidget {
  final String code;
  final String orderId;
  final String orderDate;


  const AdminSecondaryNoOrderDetail({Key? key, required this.code, required this.orderId, required this.orderDate}) : super(key: key);

  @override
  State<AdminSecondaryNoOrderDetail> createState() => _AdminSecondaryNoOrderDetailState();
}

class _AdminSecondaryNoOrderDetailState extends State<AdminSecondaryNoOrderDetail> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  RetailerNoOrderController retailerNoOrderController = Get.put(RetailerNoOrderController());

  @override
  void initState() {

    super.initState();
    fetchDetail();
  }

  fetchDetail() async{
    await retailerNoOrderController.getRetailerNoOrderDetail(orderId: widget.orderId);



  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<RetailerNoOrderController>(builder: (controller)
    {
      return SafeArea(
        child: Scaffold(
            key: scaffoldKey,
            appBar: MainAppBar(context, scaffoldKey),
            drawer: MainDrawer(context),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Widgets().newOrderUserNameDetailsTileWithVerify(context: context, titleName: controller.shopName, titleValue: "(Retailer Code : ${widget.code})"),
                  Container(
                    decoration: Widgets().commonDecoration(borderRadius: 0, bgColor: magnolia),
                    child: Widgets().customLRadding40(
                        child: Column(
                          children: [
                            Widgets().verticalSpace(2.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Widgets().richTextInRow(titleName: 'Order ID ', titleValue: '${widget.orderId}', fontColor: curiousBlue),

                              ],
                            ),
                            Widgets().verticalSpace(2.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Widgets().productListRowDetails(context: context, title: 'Order Date', subTitle: widget.orderDate),
                                  ],
                                ),
                              ],
                            ),
                            Widgets().verticalSpace(2.h),
                          ],
                        )),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.h),
                    child: Widgets().AdmincustomerNoOrderDetailCard(context: context,
                        reason: controller.reason,
                        remark: controller.remarks,
                        attachment: '${controller.fileName}'),
                  ),


                  Widgets().verticalSpace(2.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.h),
                    child: Widgets().retailerDetailsExpantionCard(
                        context: context,
                        address:controller.address,
                        beat: controller.beat,
                        city: controller.city,
                        state: controller.state,
                        creditLimit: controller.creditLimit,
                        outstanding: controller.outstanding,
                        overdue: controller.overdue,
                        callingOnTap: () {
                          //TODO add permission in info. plist for calling
                          Utils().makePhoneCall(controller.mobileNo);
                        },
                        locationOnTap: () {
                          launchMap(controller.address);
                        },
                        phoneNumber: controller.mobileNo,
                        verify: ''),
                  )
                ],
              ),
            )),
      );
    });
  }

  void launchMap(String address) async {
    String query = Uri.encodeComponent(address);
    String googleUrl = "https://www.google.com/maps/search/?api=1&query=$query";

    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    }
  }

}
