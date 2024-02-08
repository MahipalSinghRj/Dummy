import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/views/admin_module/secondary_order_module/ui/new_order/NewOrder.dart';
import 'package:smartanchor/views/admin_module/secondary_order_module/ui/no_order/NoOrder.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../utils/functionsUtils.dart';
import '../controllers/RetailerProfileContoller.dart';

class AdminRetailerDetails extends StatefulWidget {
  final String code;
  const AdminRetailerDetails({Key? key, required this.code}) : super(key: key);

  @override
  State<AdminRetailerDetails> createState() => _AdminRetailerDetailsState();
}

class _AdminRetailerDetailsState extends State<AdminRetailerDetails> {
  final TextEditingController commentController = TextEditingController();

  List<String> itemValue = ["Mumbai", "Delhi"];
  String? selectedValue;
  String? selectedBu;
  RetailerProfileController retailerProfileController = Get.put(RetailerProfileController());

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  fetchDetail() async {
    await retailerProfileController.getRetailerProfileDetail(code: widget.code);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RetailerProfileController>(builder: (controller) {
      return SafeArea(
        child: Widgets().scaffoldWithAppBarDrawer(
            context: context,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Widgets().newOrderUserNameDetailsTile(context: context, titleName: controller.shopName, titleValue: "(Customer Code : ${widget.code})"),
                  Widgets().verticalSpace(2.h),
                  Widgets().customLRPadding(
                    child: Column(
                      children: [
                        Widgets().retailerDetailsExpantionCard(
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
                              Utils().makePhoneCall(controller.phoneNumber);
                            },
                            locationOnTap: () {
                              launchMap(controller.address);
                            },
                            phoneNumber: controller.phoneNumber,
                            verify: ''),

                        Widgets().verticalSpace(2.h),

                        Widgets().AdminDealerDetailCard(context: context, power: controller.powerDealer, iaq: controller.iaqDealer, lighting: controller.lightingDealer),
                        Widgets().verticalSpace(2.h),
                        Widgets().tileWithTwoIconAndSingleText(
                            context: context,
                            title: 'All Invoices       (Phase 2)',
                            titleIcon: noteDetailsIcon,
                            subtitleIcon: rightArrowWithCircleIcon,
                            tileGradientColor: [magicMint, oysterBay],

                            //tileGradientColor: [pink, zumthor],
                            onTap: () {
                              /*  Navigator.push(context, MaterialPageRoute(builder: (_) {
                              return const AllAdminRetailerInvoices();
                            }));*/
                            }),
                        Widgets().verticalSpace(2.h),
                        Widgets().tileWithTwoIconAndSingleText(
                            context: context,
                            title: 'Ledger Report    (Phase 2)',
                            titleIcon: outstanging,
                            subtitleIcon: rightArrowWithCircleIcon,
                            tileGradientColor: [pink, zumthor],
                            onTap: () {
                              /*  Navigator.push(context, MaterialPageRoute(builder: (_) {
                              return const AdminLedgerReport();
                            }));*/
                            }),
                        Widgets().verticalSpace(2.h),
                        //Four status color container Customer Details
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {

                                  },
                                  child: Widgets().retailercolorContainer(
                                      bgColor: lightSkyColor,
                                      borderColor: malibu,
                                      iconName: orderedIcon,
                                      titleText: "${controller.totalOrderedItems}",
                                      subTitleText: 'Total Ordered Items'),
                                ),
                                Widgets().horizontalSpace(2.w),
                                Widgets().retailercolorContainer(
                                    bgColor: lightParrotColor,
                                    borderColor: turquoise,
                                    iconName: amountCollectIcon,
                                    titleText: "${controller.orderValue}",
                                    subTitleText: 'Order Value',
                                    iconColor: turquoise),
                                Widgets().horizontalSpace(2.w),
                                GestureDetector(
                                  onTap: () {

                                  },
                                  child: Widgets().retailercolorContainer(
                                      bgColor: lightredColor,
                                      borderColor: hotPink,
                                      iconName: transactionIcon,
                                      titleText: "${controller.noOrderCount}",
                                      subTitleText: 'No Order Count',
                                      iconColor: hotPink),
                                ),
                              ],
                            ),
                            Widgets().verticalSpace(1.h),
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
