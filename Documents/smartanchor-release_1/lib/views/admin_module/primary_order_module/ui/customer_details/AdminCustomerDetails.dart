import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/views/admin_module/primary_order_module/ui/no_order/NoOrder.dart';
import 'package:smartanchor/views/admin_module/primary_order_module/ui/return_order/ReturnOrder.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../utils/functionsUtils.dart';
import '../../controllers/CustomerProfileController.dart';
import '../all_invoices/AllInvoices.dart';
import '../new_order/NewOrder.dart';
import '../outstanding_amount/OutstandingAmount.dart';

class AdminCustomerDetails extends StatefulWidget {
  final String customerCode;
  final String customerName;
  const AdminCustomerDetails({Key? key, required this.customerCode, required this.customerName}) : super(key: key);

  @override
  State<AdminCustomerDetails> createState() => _AdminCustomerDetailsState();
}

class _AdminCustomerDetailsState extends State<AdminCustomerDetails> {
  AdminCustomerProfileController adminCustomerProfileController = Get.put(AdminCustomerProfileController());



  @override
  void initState() {
    super.initState();
    fetchCustomerDetail();
  }
  fetchCustomerDetail() async{
    await adminCustomerProfileController.getCustomerProfileDetail(code: widget.customerCode);


  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminCustomerProfileController>(builder: (controller)
    {
      return SafeArea(
        child: Widgets().scaffoldWithAppBarDrawer(
            context: context,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Widgets().newOrderUserNameDetailsTile(context: context, titleName: widget.customerName, titleValue: "(Customer Code : ${widget.customerCode})"),
                  Widgets().verticalSpace(2.h),
                  Widgets().customLRPadding(
                    child: Column(
                      children: [
                        Widgets().customerDetailsExpantionCard(
                            context: context,
                            address: controller.address,
                            beat: controller.beat,
                            city: controller.city,
                            state: controller.state,
                            creditLimit: controller.creditLimit,
                            outstanding: controller.outstanding,
                            overdue: controller.overdue,
                            callingOnTap: () {
                              //TODO add permission in info. plist for calling
                              Utils().makePhoneCall(controller.phoneNo);
                            },
                            locationOnTap: () {
                              launchMap(controller.address);
                            },
                            phoneNumber: controller.phoneNo,
                            verify: ''),

                        Widgets().verticalSpace(2.h),
                        Widgets().tileWithTwoIconAndSingleText(
                            context: context,
                            title: 'Outstanding Amount',
                            titleIcon: noteDetailsIcon,
                            subtitleIcon: rightArrowWithCircleIcon,
                            tileGradientColor: [pink, zumthor],
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) {
                                return const OutStandingAmount();
                              }));
                            }),
                        Widgets().verticalSpace(2.h),
                        Widgets().tileWithTwoIconAndSingleText(
                            context: context,
                            title: 'All Invoices',
                            titleIcon: noteDetailsIcon,
                            subtitleIcon: rightArrowWithCircleIcon,
                            tileGradientColor: [magicMint, oysterBay],
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) {
                                return const AllAdminInvoices();
                              }));
                            }),
                        Widgets().verticalSpace(2.h),
                        //Four status color container Customer Details
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {

                                  },
                                  child: Widgets().colorContainer(
                                      bgColor: lightSkyColor,
                                      borderColor: malibu,
                                      iconName: orderedIcon,
                                      titleText: controller.totalOrdered,
                                      subTitleText: 'Total Ordered Items'),
                                ),
                                Widgets().horizontalSpace(2.w),
                                Widgets().colorContainer(
                                    bgColor: lightParrotColor,
                                    borderColor: turquoise,
                                    iconName: amountCollectIcon,
                                    titleText: '₹ ${controller.orderedValue}',
                                    subTitleText: 'Order Value',
                                    iconColor: turquoise),
                              ],
                            ),
                            Widgets().verticalSpace(1.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {

                                  },
                                  child: Widgets().colorContainer(
                                      bgColor: lightredColor,
                                      borderColor: hotPink,
                                      iconName: transactionIcon,
                                      titleText: controller.noOrder,
                                      subTitleText: 'No Order Count',
                                      iconColor: hotPink),
                                ),
                                Widgets().horizontalSpace(2.w),
                                GestureDetector(
                                  onTap: () {

                                  },
                                  child: Widgets().colorContainer(
                                      bgColor: lightyellowColor,
                                      borderColor: yellowOrange,
                                      iconName: returnIcon,
                                      titleText: controller.returnOrder,
                                      subTitleText: 'Return Order'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Widgets().verticalSpace(1.h),
                        //Three status color container Retailer / SubStockist Profile
                      ],
                    ),
                  ),
                  Widgets().verticalSpace(2.h),
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
