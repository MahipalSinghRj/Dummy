import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/views/admin_module/primary_order_module/controllers/CustomerProfileController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/calculationController/CalculationController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/previous_order_controller/PreviousOrderController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/ui/customer_profile/controller/CustomerProfileController.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../common/AppBar.dart';
import '../../../../../common/Drawer.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../debug/printme.dart';
import '../../../../../utils/functionsUtils.dart';
import '../../controllers/CustomerNewOrderController.dart';


class AdminOrderDetail extends StatefulWidget {
  final int orderId;
  final String customerName;
  final String customerCode;




  const AdminOrderDetail({Key? key, required this.orderId, required this.customerName, required this.customerCode}) : super(key: key);

  @override
  State<AdminOrderDetail> createState() => _AdminOrderDetailState();
}

class _AdminOrderDetailState extends State<AdminOrderDetail> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  AdminCustomerNewOrderController adminCustomerNewOrderController = Get.put(AdminCustomerNewOrderController());
  AdminCustomerProfileController adminCustomerProfileController = Get.put(AdminCustomerProfileController());


  @override
  void initState() {

    super.initState();
    fetchDetail();

  }

  fetchDetail() async{
  await  adminCustomerNewOrderController.getCustomerNewOrderDetail(orderId: widget.orderId);
  await adminCustomerNewOrderController.calculateTotalValue();

  await adminCustomerProfileController.getCustomerProfileDetail(code: widget.customerCode);

  setState(() {

  });
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminCustomerNewOrderController>(builder: (controller)
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
                                Widgets().richTextInRow(titleName: 'Order ID ', titleValue: widget.orderId.toString(), fontColor: curiousBlue),
                                Widgets().statusContainer(statusColor: controller.orderStatus != 'pending' ? magicMint : salomie, statusTitle: controller.orderStatus.capitalizeFirst!)

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
                                    Widgets().productListRowDetails(context: context, title: 'Order Qty', subTitle: controller.orderQTY),
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
                        itemCount: controller.productLists.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Widgets().newOrderDetailListCard(
                            context: context,

                            productDetailText: controller.productLists[index].productName!,
                            qtyValue: controller.productLists[index].quantity!,
                            totalPriceValue: '₹ ${controller.productLists[index].price!}',
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
