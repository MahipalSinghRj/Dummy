import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/common/CustomLoadingWrapper.dart';
import 'package:smartanchor/views/tsi_module/secondary_order_module/controllers/retailer_profile_controller/RetailerController.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../utils/functionsUtils.dart';

class RetailerProfileDetailsScreen extends StatefulWidget {
  final String code;
  const RetailerProfileDetailsScreen({Key? key, required this.code}) : super(key: key);

  @override
  State<RetailerProfileDetailsScreen> createState() => _RetailerProfileDetailsScreenState();
}

class _RetailerProfileDetailsScreenState extends State<RetailerProfileDetailsScreen> {
  final TextEditingController commentController = TextEditingController();

  RetailerController retailerController = Get.put(RetailerController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchDetail();
    });
  }

  fetchDetail() async {
    await retailerController.getSingleRetailerProfileDetail(code: widget.code);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RetailerController>(
        init: retailerController,
        builder: (controller) {
          return SafeArea(
            child: Widgets().scaffoldWithAppBarDrawer(
                context: context,
                body: CustomeLoading(
                  isLoading: controller.isLoading,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Widgets().newOrderUserNameDetailsTile(
                            context: context,
                            titleName: controller.singleRetailerProfileDetails?.retailerDetail.customerName ?? '',
                            titleValue: "(Customer Code : ${controller.singleRetailerProfileDetails?.retailerDetail.code ?? ''})"),
                        Widgets().verticalSpace(2.h),
                        Widgets().customLRPadding(
                          child: Column(
                            children: [
                              Widgets().retailerProfileDetailsExpantionCard(
                                  context: context,
                                  address: controller.singleRetailerProfileDetails?.retailerDetail.address ?? '',
                                  beat: controller.singleRetailerProfileDetails?.retailerDetail.beat ?? '',
                                  city: controller.singleRetailerProfileDetails?.retailerDetail.city ?? '',
                                  state: controller.singleRetailerProfileDetails?.retailerDetail.state ?? '',
                                  creditLimit: controller.singleRetailerProfileDetails?.retailerDetail.creditLimit ?? '',
                                  outstanding: controller.singleRetailerProfileDetails?.retailerDetail.outstanding ?? '',
                                  overdue: controller.singleRetailerProfileDetails?.retailerDetail.overdue ?? '',
                                  callingOnTap: () {
                                    //TODO add permission in info. plist for calling
                                    Utils().makePhoneCall("+91${controller.singleRetailerProfileDetails?.retailerDetail.mobileNo ?? ''}");
                                  },
                                  locationOnTap: () {
                                    launchMap(controller.singleRetailerProfileDetails?.retailerDetail.address ?? '');
                                  },
                                  phoneNumber: controller.singleRetailerProfileDetails?.retailerDetail.mobileNo ?? '',
                                  verify: (controller.singleRetailerProfileDetails?.retailerDetail.verifyFlag ?? '') == "1",
                                  onVerifyClick: () async {
                                    bool result = await controller.verifyUserSendOTP(controller.singleRetailerProfileDetails?.retailerDetail.code ?? '');

                                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                                      Widgets().verificationBottomSheet(
                                          context: context,
                                          message: result ? "You Retailer/SubStockist verified successfully." : "You Retailer/SubStockist not verified.",
                                          onTapOk: () async {
                                            Get.back();
                                            await fetchDetail();
                                          });
                                    });
                                  }),

                              Widgets().verticalSpace(2.h),

                              Widgets().adminDealerDetailCard(
                                  context: context,
                                  power: controller.singleRetailerProfileDetails?.powerDealer ?? '',
                                  iaq: controller.singleRetailerProfileDetails?.iaqDealer ?? '',
                                  lighting: controller.singleRetailerProfileDetails?.lightingDealer ?? ''),
                              Widgets().verticalSpace(2.h),
                              Widgets().tileWithTwoIconAndSingleText(
                                  context: context,
                                  title: 'All Invoices',
                                  titleIcon: noteDetailsIcon,
                                  subtitleIcon: rightArrowWithCircleIcon,
                                  tileGradientColor: [magicMint, oysterBay],

                                  //tileGradientColor: [pink, zumthor],
                                  onTap: () {
                                    Widgets().showToast("Coming Soon");
                                    // Get.to(() =>
                                    //     AllInvoices(customerCode: widget.code));
                                  }),
                              Widgets().verticalSpace(2.h),
                              Widgets().tileWithTwoIconAndSingleText(
                                  context: context,
                                  title: 'Ledger Report',
                                  titleIcon: outstanging,
                                  subtitleIcon: rightArrowWithCircleIcon,
                                  tileGradientColor: [pink, zumthor],
                                  onTap: () {
                                    Widgets().showToast("Coming Soon");

                                    // Get.to(() => LedgerReport());
                                  }),
                              Widgets().verticalSpace(2.h),
                              //Four status color container Customer Details
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: Widgets().retailercolorContainer(
                                            bgColor: lightSkyColor,
                                            borderColor: malibu,
                                            iconName: orderedIcon,
                                            titleText: controller.singleRetailerProfileDetails?.totalOrderedItem ?? '',
                                            subTitleText: 'Total Ordered Items'),
                                      ),
                                      Widgets().horizontalSpace(2.w),
                                      Widgets().retailercolorContainer(
                                          bgColor: lightParrotColor,
                                          borderColor: turquoise,
                                          iconName: amountCollectIcon,
                                          titleText: controller.singleRetailerProfileDetails?.orderValue ?? '',
                                          subTitleText: 'Order Value',
                                          iconColor: turquoise),
                                      Widgets().horizontalSpace(2.w),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Widgets().retailercolorContainer(
                                            bgColor: lightredColor,
                                            borderColor: hotPink,
                                            iconName: transactionIcon,
                                            titleText: controller.singleRetailerProfileDetails?.noOrderCount ?? '',
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
