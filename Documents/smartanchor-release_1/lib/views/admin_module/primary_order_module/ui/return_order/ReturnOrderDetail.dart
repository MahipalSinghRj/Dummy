import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../common/AppBar.dart';
import '../../../../../common/Drawer.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../utils/functionsUtils.dart';
import '../../controllers/CustomerProfileController.dart';
import '../../controllers/CustomerReturnOrderController.dart';

class AdminReturnOrderDetail extends StatefulWidget {
  final String orderId;
  final String customerName;
  final String customerCode;

  const AdminReturnOrderDetail({Key? key, required this.orderId, required this.customerName, required this.customerCode}) : super(key: key);

  @override
  State<AdminReturnOrderDetail> createState() => _AdminReturnOrderDetailState();
}

class _AdminReturnOrderDetailState extends State<AdminReturnOrderDetail> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  AdminCustomerReturnOrderController adminCustomerNewOrderController = Get.put(AdminCustomerReturnOrderController());
  AdminCustomerProfileController adminCustomerProfileController = Get.put(AdminCustomerProfileController());

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  fetchDetail() async {
    await adminCustomerNewOrderController.getCustomerReturnOrderDetail(orderId: widget.orderId);
    await adminCustomerNewOrderController.calculateTotalValue();

    await adminCustomerProfileController.getCustomerProfileDetail(code: widget.customerCode);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminCustomerReturnOrderController>(builder: (controller) {
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
                            Widgets().statusContainer(statusColor: controller.orderStatus != 'pending' ? magicMint : salomie, statusTitle: controller.orderStatus)
                          ],
                        ),
                        Widgets().verticalSpace(2.h),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Widgets().productListRowDetails(context: context, title: 'Order Date', subTitle: controller.orderDate),
                              ],
                            ),
                            Widgets().horizontalSpace(2.3.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Widgets().productListRowDetails(context: context, title: 'Order Qty', subTitle: controller.orderQuantity),
                              ],
                            ),
                          ],
                        ),
                        Widgets().verticalSpace(2.h),
                      ],
                    )),
                  ),
                  Widgets().verticalSpace(1.h),
                  Widgets().customLRPadding(
                      child: ListView.builder(
                    itemCount: controller.productDetails.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Widgets().newOrderDetailListCard(
                        context: context,
                        productDetailText: controller.productDetails[index].productName!,
                        qtyValue: controller.productDetails[index].quantity!,
                        totalPriceValue: '₹ ${controller.productDetails[index].totalPrice!}',
                      );
                    },
                  )),
                  Widgets().verticalSpace(2.h),
                  Widgets().totalOrderValueTile(context: context, iconName: cartSvgIcon, titleValue: '₹ ${controller.totalValue.toStringAsFixed(2)}'),
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
