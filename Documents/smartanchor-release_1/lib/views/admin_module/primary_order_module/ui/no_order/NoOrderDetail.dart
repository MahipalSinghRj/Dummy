import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/views/admin_module/primary_order_module/controllers/CustomerNoOrderController.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../common/AppBar.dart';
import '../../../../../common/Drawer.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../utils/functionsUtils.dart';
import '../../controllers/CustomerProfileController.dart';

class AdminNoOrderDetail extends StatefulWidget {
  final String customerCode;
  final String orderId;
  final String customerName;
  final String date;
  const AdminNoOrderDetail({Key? key, required this.customerCode, required this.orderId, required this.customerName, required this.date}) : super(key: key);

  @override
  State<AdminNoOrderDetail> createState() => _AdminNoOrderDetailState();
}

class _AdminNoOrderDetailState extends State<AdminNoOrderDetail> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  AdminCustomerNoOrderController adminCustomerNoOrderController = Get.put(AdminCustomerNoOrderController());
  AdminCustomerProfileController adminCustomerProfileController = Get.put(AdminCustomerProfileController());

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  fetchDetail() async {
    await adminCustomerNoOrderController.getCustomerNoOrderDetail(orderId: widget.orderId);
    await adminCustomerProfileController.getCustomerProfileDetail(code: widget.customerCode);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminCustomerNoOrderController>(builder: (controller)
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
                  Widgets().newOrderUserNameDetailsTile(context: context, titleName: widget.customerName, titleValue: "(Customer Code : ${widget.customerCode})"),
                  Container(
                    decoration: Widgets().commonDecoration(borderRadius: 0, bgColor: magnolia),
                    child: Widgets().customLRadding40(
                        child: Column(
                          children: [
                            Widgets().verticalSpace(2.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Widgets().richTextInRow(titleName: 'Order ID ', titleValue: widget.orderId, fontColor: curiousBlue),
                              ],
                            ),
                            Widgets().verticalSpace(2.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Widgets().productListRowDetails(context: context, title: 'Order Date', subTitle: widget.date),
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
                    child: Widgets().AdmincustomerNoOrderDetailCard(
                        context: context,
                        reason: controller.reason,
                        remark: controller.remarks,
                        attachment: ':   ${controller.fileName}'),
                  ),
                  Widgets().verticalSpace(2.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.h),
                    child: Widgets().customerDetailsExpantionCard(
                        context: context,
                        address: adminCustomerProfileController.address,
                        beat: adminCustomerProfileController.beat,
                        city: adminCustomerProfileController.city,
                        state: adminCustomerProfileController.state,
                        creditLimit: adminCustomerProfileController.creditLimit,
                        outstanding: adminCustomerProfileController.outstanding,
                        overdue: adminCustomerProfileController.overdue,
                        callingOnTap: () {
                          //TODO add permission in info. plist for calling
                          Utils().makePhoneCall(adminCustomerProfileController.phoneNo);
                        },
                        locationOnTap: () {
                          launchMap(adminCustomerProfileController.address);
                        },
                        phoneNumber: adminCustomerProfileController.phoneNo,
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
