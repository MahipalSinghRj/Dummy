import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/ui/customer_profile/controller/CustomerProfileController.dart';

import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../utils/functionsUtils.dart';
import '../all_invoices/AllInvoices.dart';
import '../customer_details/CustomerDetails.dart';
import '../customer_on_map/CustomerOnMap.dart';

class CustomerProfile extends StatefulWidget {
  const CustomerProfile({Key? key}) : super(key: key);

  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  ScrollController _scrollController = ScrollController();
  CustomerProfileController controller = Get.put(CustomerProfileController());
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    await controller.fetchCustomerList();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // User has reached the end of the list
      // showBottomLoading = true;
      // setState(() {});
      await controller.fetchCustomerList(page: (controller.pageCount + 1));
      // showBottomLoading = false;
      // setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Widgets().scaffoldWithAppBarDrawer(
          context: context,
          body: GetBuilder<CustomerProfileController>(
            init: CustomerProfileController(),
            builder: (controller) => SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  // Widgets().newOrderUserNameDetailsTile(context: context, titleName: 'Jai Ram Electronic Shop', titleValue: "(Customer Code : 252154)"),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          decoration: Widgets().commonDecorationWithGradient(
                              borderRadius: 0,
                              gradientColorList: [pink, zumthor]),
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
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (_) {
                                      return CustomerOnMap(
                                        isSingleCustomer: false,
                                      );
                                    }));
                                  }),
                              Widgets().verticalSpace(2.h),
                              //Add visibility for add new retailer
                              // Widgets().iconElevationButton(
                              //     onTap: () {
                              //       Navigator.push(context,
                              //           MaterialPageRoute(builder: (_) {
                              //         return const AddNewRetailer();
                              //       }));
                              //     },
                              //     icon: addIcon,
                              //     titleText: 'Add New Retailer',
                              //     isBackgroundOk: false,
                              //     width: 100.w,
                              //     bgColor: codGray,
                              //     textColor: alizarinCrimson,
                              //     iconColor: alizarinCrimson),
                              Widgets().verticalSpace(2.h),
                              Widgets().textWidgetWithW500(
                                  titleText: "Search Customer",
                                  fontSize: 11.sp,
                                  textColor: codGray),
                              Widgets().verticalSpace(2.h),
                              Widgets().textFieldWidget(
                                  controller: controller.searchController,
                                  hintText: 'Search',
                                  iconName: search,
                                  keyBoardType: TextInputType.text,
                                  fillColor: white),
                              Widgets().verticalSpace(2.h),
                            ],
                          ))),
                      Widgets().verticalSpace(2.h),
                      Widgets().customLRPadding(
                        child: ListView.builder(
                          itemCount:
                              controller.filteredCustomerProfileData.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            final item =
                                controller.customerProfiles!.items[index];
                            return Widgets().customerProfileExpantionCard(
                                context: context,
                                shopTitleText: item.customerName,
                                customerCode: '(Code : ${item.customerCode})',
                                address: item.address,
                                beat: item.beat,
                                city: item.city,
                                state: item.state,
                                creditLimit: item.creditLimit,
                                outstanding: item.outstanding,
                                overdue: item.overdue,
                                noteDetailsOnTap: () {
                                  Get.to(() => AllInvoices(
                                      customerCode: item.customerCode));
                                },
                                callingOnTap: () {
                                  Utils().makePhoneCall(item.phoneNo);
                                },
                                locationOnTap: () async {
                                  controller.openMapWithAddress(item.address);
                                  // Get.to(() {});
                                  // controller.openMapWithAddress(item.address);
                                },
                                viewDetailsOnTap: () {
                                  Get.to(() =>
                                      CustomerDetails(masterId: item.masterId));
                                  // Navigator.push(context,
                                  //     MaterialPageRoute(builder: (_) {
                                  //   return ;
                                  // }));
                                },
                                isVerified: false);
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
          )),
    );
  }
}
