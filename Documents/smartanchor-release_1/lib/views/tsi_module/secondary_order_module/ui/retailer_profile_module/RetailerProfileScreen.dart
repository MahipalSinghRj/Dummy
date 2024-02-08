import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/common/CustomLoadingWrapper.dart';
import 'package:smartanchor/views/tsi_module/secondary_order_module/controllers/retailer_profile_controller/RetailerController.dart';
import 'package:smartanchor/views/tsi_module/secondary_order_module/ui/retailer_profile_module/SingleRetailerProfileDetails.dart';

import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../utils/functionsUtils.dart';
import 'AddNewRetailer.dart';

class RetailerProfileScreen extends GetView<RetailerController> {
  RetailerProfileScreen({Key? key}) : super(key: key);

  RetailerController controller = Get.put(RetailerController());

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      controller.pageNo = 1;
      controller.lastPage = 0;
      _scrollController.addListener(() {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          // Load more data when reaching the end
          controller.loadMoreData();
        }
      });
      await controller.fetchRetailersList();
    });
    return SafeArea(
      child: Widgets().scaffoldWithAppBarDrawer(
          context: context,
          body: GetBuilder<RetailerController>(
            init: RetailerController(),
            builder: (controller) => CustomeLoading(
              isLoading: controller.isLoading,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    // Widgets().newOrderUserNameDetailsTile(context: context, titleName: 'Jai Ram Electronic Shop', titleValue: "(Customer Code : 252154)"),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            decoration: Widgets().commonDecorationWithGradient(borderRadius: 0, gradientColorList: [pink, zumthor]),
                            child: Widgets().customLRPadding(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Widgets().verticalSpace(2.h),
                                Widgets().tileWithTwoIconAndSingleText(
                                    context: context,
                                    title: 'View Heat Map',
                                    titleIcon: locationIcon,
                                    subtitleIcon: rightArrowWithCircleIcon,
                                    tileGradientColor: [magicMint, oysterBay],
                                    onTap: () {
                                      // Navigator.push(context,
                                      //     MaterialPageRoute(builder: (_) {
                                      //   return CustomerOnMap(
                                      //     isSingleCustomer: false,
                                      //   );
                                      // }));
                                    }),
                                Widgets().verticalSpace(2.h),
                                //Add visibility for add new retailer
                                Widgets().iconElevationButton(
                                    onTap: () async {
                                      final result = await Navigator.push(context, MaterialPageRoute(builder: (_) {
                                        return AddNewRetailer();
                                      }));

                                      if (result) {
                                        controller.pageNo = 1;
                                        controller.lastPage = 0;
                                        await controller.fetchRetailersList();
                                      }
                                    },
                                    icon: addIcon,
                                    titleText: 'Add New Retailer',
                                    isBackgroundOk: false,
                                    width: 100.w,
                                    bgColor: codGray,
                                    textColor: alizarinCrimson,
                                    iconColor: alizarinCrimson),
                                Widgets().verticalSpace(2.h),
                                Widgets().textWidgetWithW500(titleText: "Search Customer", fontSize: 11.sp, textColor: codGray),
                                Widgets().verticalSpace(2.h),
                                Widgets().textFieldWidget(
                                    controller: controller.searchController,
                                    hintText: 'Search',
                                    iconName: search,
                                    onChanged: (vale) {
                                      // controller.filterItemsByName();
                                      controller.update();
                                    },
                                    keyBoardType: TextInputType.text,
                                    fillColor: white),
                                Widgets().verticalSpace(2.h),
                              ],
                            ))),
                        Widgets().verticalSpace(2.h),
                        Widgets().customLRPadding(
                          child: ListView.builder(
                            itemCount: controller.retailerList.length,
                            shrinkWrap: true,
                            reverse: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              final item = controller.retailerList[index];

                              return (item.customerName.toLowerCase().contains(controller.searchController.text.toLowerCase()) ||
                                      item.mobileNo.toLowerCase().contains(controller.searchController.text.toLowerCase()) ||
                                      item.beat.toLowerCase().contains(controller.searchController.text.toLowerCase()) ||
                                      item.city.toLowerCase().contains(controller.searchController.text.toLowerCase()) ||
                                      item.code.toLowerCase().contains(controller.searchController.text.toLowerCase()) ||
                                      item.mobileNo.toLowerCase().contains(controller.searchController.text.toLowerCase()) ||
                                      item.state.toLowerCase().contains(controller.searchController.text.toLowerCase()) ||
                                      item.address.toLowerCase().contains(controller.searchController.text.toLowerCase()))
                                  ? Widgets().retailerProfileExpantionCard(
                                      context: context,
                                      shopTitleText: item.customerName,
                                      customerCode: '(Code : ${item.code})',
                                      address: item.address,
                                      beat: item.beat,
                                      city: item.city,
                                      state: item.state,
                                      remark: "",
                                      noteDetailsOnTap: () {
                                        Widgets().showToast("Coming soon");
                                        // Phase 2
                                        // Get.to(() =>
                                        //     AllInvoices(customerCode: item.code));
                                      },
                                      callingOnTap: () {
                                        Utils().makePhoneCall("+91${item.mobileNo}");
                                      },
                                      locationOnTap: () async {
                                        controller.openMapWithAddress(item.address);
                                      },
                                      viewDetailsOnTap: () {
                                        Get.to(() => RetailerProfileDetailsScreen(
                                              code: item.code,
                                            ));
                                      },
                                      isVerified: item.verifyFlag == "1")
                                  : const SizedBox.shrink();
                            },
                          ),
                        ),
                        if (controller.isLoading)
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: CircularProgressIndicator(),
                              )
                            ],
                          ),
                        Widgets().verticalSpace(2.h),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
