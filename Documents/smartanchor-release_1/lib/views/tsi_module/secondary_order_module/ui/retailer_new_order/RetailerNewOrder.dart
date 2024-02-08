import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/primary_order_contoller/PrimaryOrderController.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../../../../../common/AppBar.dart';
import '../../../../../../common/Drawer.dart';
import '../../../../../../common/widgets.dart';
import '../../../../../../constants/assetsConst.dart';
import '../../../../../../constants/colorConst.dart';
import '../../../../../common/CustomLoadingWrapper.dart';
import '../../../../../common/NewWidgets.dart';
import '../../../../../debug/printme.dart';
import '../../../other_details_of_customer/controllers/ProductFilterController.dart';
import '../../controllers/retailer_calculation_controller/RetailerCalculationController.dart';
import '../../controllers/retailer_new-order_controller/RetailerNewOrderController.dart';
import '../../controllers/secondary_order_controller/SecondaryOrderController.dart';
import '../../models/responseModels/retailer_new-order_model/ProductDetailListResponse.dart';
import '../retailer_product_list/RetailerProductList.dart';

//ignore: must_be_immutable
class RetailerNewOrder extends StatefulWidget {
  final String retailerName;
  final String retailerCode;
  final String buName;
  final String emailAddress;
  final List<ProductLists> retailerNewOrderList;
  final bool? isFromNewOrder;

  const RetailerNewOrder({
    Key? key,
    required this.retailerName,
    required this.retailerCode,
    required this.buName,
    required this.emailAddress,
    required this.retailerNewOrderList,
    required this.isFromNewOrder,
  }) : super(key: key);

  @override
  State<RetailerNewOrder> createState() => _RetailerNewOrderState();
}

class _RetailerNewOrderState extends State<RetailerNewOrder> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  RetailerCalculationController _retailerCalculationController = Get.put(RetailerCalculationController());
  SecondaryController secondaryController = Get.put(SecondaryController());
  PrimaryOrderController primaryOrderController = Get.put(PrimaryOrderController());
  RetailerNewOrderControllerSec retailerNewOrderControllerSec = Get.put(RetailerNewOrderControllerSec());
  ProductFilterController productFilterController = Get.put(ProductFilterController());

  int selectedToggleIndex = 0;

  var isReload = false;

  List<ProductLists> productLists = [];

  //================================================
  ///For scrolling
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    retailerNewOrderControllerSec.searchVariantController.clear();
    _retailerCalculationController.setSelectedListItems([]);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getDataOfNewOrderApiCall();
      getMoreData();
    });
    super.initState();
  }

  getDataOfNewOrderApiCall() async {
    if (widget.isFromNewOrder!) {
      await retailerNewOrderControllerSec.productDetailListFn(
          category: '',
          division: '',
          pageNumber: retailerNewOrderControllerSec.currentPage,
          pageSize: retailerNewOrderControllerSec.pageSize,
          retailerCode: widget.retailerCode,
          subBrand: '',
          searchKey: "",
          isFocus: false);
      for (int i = 0; i < widget.retailerNewOrderList.length; i++) {
        var items = retailerNewOrderControllerSec.productLists[i];
        retailerNewOrderControllerSec.updateProductSelection(items, true);
      }
    } else {
      await retailerNewOrderControllerSec.productDetailListFn(
          category: '',
          division: '',
          pageNumber: retailerNewOrderControllerSec.currentPage,
          pageSize: retailerNewOrderControllerSec.pageSize,
          retailerCode: widget.retailerCode,
          subBrand: '',
          searchKey: "",
          isFocus: false);
    }
  }

  getMoreData() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        retailerNewOrderControllerSec.loadMoreData(
          category: '',
          division: '',
          pageNumber: retailerNewOrderControllerSec.currentPage,
          pageSize: retailerNewOrderControllerSec.pageSize,
          retailerCode: widget.retailerCode,
          subBrand: '',
          //searchKey: "",
          //isFocus: false,
          selectedIndex: selectedToggleIndex,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RetailerNewOrderControllerSec>(builder: (controller) {
      return WillPopScope(
        onWillPop: () {
          _retailerCalculationController.removeSelectedProductListItems(key: 'selectedRetailerProductListItems');
          Navigator.pop(context);
          return Future.value(false);
        },
        child: SafeArea(
          child: Scaffold(
            key: scaffoldKey,
            appBar: MainAppBar(context, scaffoldKey),
            drawer: MainDrawer(context),
            floatingActionButton: Widgets().notificationCartFAButton(
                notificationCount: _retailerCalculationController.cartItemCount,
                onTap: () async {
                  _retailerCalculationController.cartItemCount == "0"
                      ? Widgets().showToast("Cart is empty.")
                      : Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return RetailerProductList(
                            retailerCode: widget.retailerCode,
                            retailerName: widget.retailerName,
                            emailAddress: widget.emailAddress,
                          );
                        }));
                }),
            body: CustomeLoading(
              isLoading: retailerNewOrderControllerSec.isLoading,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Widgets().newOrderUserNameDetailsTile(context: context, titleName: widget.retailerName, titleValue: "(Retailer Code : ${widget.retailerCode})"),
                    Container(
                      decoration: Widgets().commonDecorationWithGradient(borderRadius: 0, gradientColorList: [pink, zumthor]),
                      child: Widgets().customLRPadding(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Widgets().verticalSpace(2.h),
                            Widgets().simpleTextWithIcon(
                                context: context,
                                bgColor: (selectedToggleIndex == 0) ? white : boulder,
                                titleName: 'Search Variant',
                                iconName: filter,
                                onTap: (selectedToggleIndex == 0)
                                    ? () async {
                                        Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
                                        await retailerNewOrderControllerSec
                                            .productDetailListFn(
                                                category: '',
                                                division: '',
                                                pageNumber: retailerNewOrderControllerSec.currentPage,
                                                pageSize: retailerNewOrderControllerSec.pageSize,
                                                retailerCode: widget.retailerCode,
                                                subBrand: '',
                                                searchKey: retailerNewOrderControllerSec.searchVariantController.text,
                                                isFocus: false)
                                            .then((value) {
                                          Get.back();
                                        });
                                        showNewDialog();
                                      }
                                    : () {
                                        Widgets().showToast("Focus product search not available.");
                                      }),
                            // Widgets().simpleTextWithIcon(
                            //     context: context,
                            //     bgColor: (selectedToggleIndex == 0) ? white : boulder,
                            //     titleName: 'Search Variant',
                            //     iconName: filter,
                            //     onTap: (selectedToggleIndex == 0)
                            //         ? () async {
                            //             await productFilterController
                            //                 .productFilterApiFn(
                            //                     brand: productFilterController.selectBrandValue ?? '',
                            //                     businessUnit: secondaryController.selectedBu ?? '',
                            //                     division: productFilterController.selectDivisionValue ?? "",
                            //                     category: productFilterController.selectCategoryValue ?? '')
                            //                 .then((value) {
                            //               if (value == true) {
                            //                 showNewDialog();
                            //               }
                            //             });
                            //           }
                            //         : () {
                            //             Widgets().showToast("Focus product search not available.");
                            //           }),

                            Widgets().verticalSpace(1.h),
                            // Widgets().textFieldWidgetWithSearchDelegate(
                            //   controller: searchVariantController,
                            //   hintText: "Type here",
                            //   iconName: search,
                            //   fillColor: white,
                            //   keyBoardType: TextInputType.text,
                            //   onTap: () {
                            //     showSearch(
                            //       context: context,
                            //       delegate: RetailerProductSearch(
                            //         retailerCode: widget.retailerCode,
                            //       ),
                            //     );
                            //   },
                            // ),

                            NewWidgets().textFieldWidgetWithSearch(
                                controller: retailerNewOrderControllerSec.searchVariantController,
                                hintText: "Type here",
                                iconName: search,
                                fillColor: white,
                                keyBoardType: TextInputType.text,
                                onChanged: (value) {
                                  retailerNewOrderControllerSec.searchVariantController.text = value;
                                  setState(() {});
                                },
                                onTap: () async {
                                  retailerNewOrderControllerSec.currentPage = 1;
                                  retailerNewOrderControllerSec.pageSize = 10;
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  await retailerNewOrderControllerSec
                                      .productDetailListFn(
                                          category: '',
                                          division: '',
                                          pageNumber: retailerNewOrderControllerSec.currentPage,
                                          pageSize: retailerNewOrderControllerSec.pageSize,
                                          retailerCode: widget.retailerCode,
                                          subBrand: '',
                                          searchKey: retailerNewOrderControllerSec.searchVariantController.text,
                                          isFocus: false)
                                      .then((value) {
                                    setState(() {});
                                  });
                                }),
                            Widgets().verticalSpace(2.h),
                          ],
                        ),
                      ),
                    ),
                    Widgets().verticalSpace(2.h),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.h),
                            ),
                            child: ToggleSwitch(
                              minWidth: 40.w,
                              minHeight: 6.h,
                              cornerRadius: 2.h,
                              activeBgColors: [
                                [alizarinCrimson],
                                [alizarinCrimson],
                              ],
                              customTextStyles: [
                                TextStyle(color: selectedToggleIndex == 0 ? white : codGray, fontSize: 12.sp),
                                TextStyle(color: selectedToggleIndex == 1 ? white : codGray, fontSize: 12.sp)
                              ],
                              inactiveBgColor: magnolia,
                              initialLabelIndex: selectedToggleIndex,
                              totalSwitches: 2,
                              labels: const ['All Product', 'Focused Product'],
                              radiusStyle: true,
                              onToggle: (index) async {
                                printMe("Toggle : $index");
                                retailerNewOrderControllerSec.currentPage = 1;
                                // if (index == 1) {
                                //   if (retailerNewOrderControllerSec.focusProductLists.isEmpty) {
                                //     Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
                                //     await retailerNewOrderControllerSec.productDetailListFn(
                                //         category: '',
                                //         division: '',
                                //         pageNumber: 1,
                                //         pageSize: 10,
                                //         retailerCode: widget.retailerCode,
                                //         subBrand: '',
                                //         searchKey: "",
                                //         isFocus: true);
                                //   }
                                // }
                                if (index == 1) {
                                  retailerNewOrderControllerSec.pageSize = 100;
                                  await retailerNewOrderControllerSec.productDetailListFn(
                                      category: '',
                                      division: '',
                                      pageNumber: retailerNewOrderControllerSec.currentPage,
                                      pageSize: retailerNewOrderControllerSec.pageSize,
                                      retailerCode: widget.retailerCode,
                                      subBrand: '',
                                      searchKey: "",
                                      isFocus: true);
                                }
                                retailerNewOrderControllerSec.pageSize = 10;

                                setState(() {
                                  selectedToggleIndex = index ?? 0;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Widgets().verticalSpace(2.h),
                    (selectedToggleIndex == 0)
                        ? Widgets().customLRPadding(
                            child: controller.productLists.isEmpty
                                ? Center(child: Widgets().textWidgetWithW700(titleText: "No data found.", fontSize: 12.sp))
                                : ListView.builder(
                                    itemCount: controller.productLists.length,
                                    //controller: onLoadScroll,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    //physics: const ScrollPhysics(),
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context, int index) {
                                      var items = controller.productLists[index];
                                      return Widgets().retailerNewOrderListCard1(
                                        cardColor: magnolia,
                                        iconName: pcDowmLightIcon,
                                        productDetailText: items.productName.toString(),
                                        checkBoxBGColor: items.cardColor == pippin ? white : checkBoxColor,
                                        skuCodeValue: items.skuCode.toString(),
                                        availableQtyValue: items.quantity.toString(),
                                        //TODO : Pending distributor
                                        district: items.distributor.toString(),
                                        lastOD: items.lastOrderd.toString(),
                                        context: context,
                                        initialValue: controller.isProductSelected(items),
                                        onChanged: (value) {
                                          controller.updateProductSelection(items, value!);
                                        },
                                      );
                                    },
                                  ))
                        : Widgets().customLRPadding(
                            child: controller.focusProductLists.isEmpty
                                ? Center(child: Widgets().textWidgetWithW700(titleText: "No data found.", fontSize: 12.sp))
                                : ListView.builder(
                                    itemCount: controller.focusProductLists.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    //physics: const ScrollPhysics(),
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context, int index) {
                                      var items = controller.focusProductLists[index];
                                      return Widgets().retailerNewOrderListCard(
                                        cardColor: magnolia,
                                        iconName: pcDowmLightIcon,
                                        productDetailText: items.productName.toString(),
                                        checkBoxBGColor: items.cardColor == pippin ? white : checkBoxColor,
                                        skuCodeValue: items.skuCode.toString(),
                                        availableQtyValue: items.quantity.toString(),
                                        //TODO : Pending distributor
                                        district: items.distributor.toString(),
                                        lastOD: items.lastOrderd.toString(),
                                        context: context,
                                        initialValue: controller.isProductSelected(items),
                                        onChanged: (value) {
                                          controller.updateProductSelection(items, value!);
                                        },
                                      );
                                    },
                                  )),
                    Widgets().verticalSpace(2.h),
                    Widgets().verticalSpace(2.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  void showNewDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(content: GetBuilder<RetailerNewOrderControllerSec>(builder: (controller) {
            return StatefulBuilder(builder: (context1, myState) {
              return SizedBox(
                height: 30.h,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Widgets().textWidgetWithW700(titleText: "Filter by", fontSize: 14.sp),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: SvgPicture.asset(closeIcon))
                      ],
                    ),
                    Widgets().verticalSpace(1.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Widgets().filterByCard(
                            widget: Widgets().commonDropdownWith8sp(
                                hintText: "Select BU",
                                onChanged: (value) {
                                  myState(() {
                                    secondaryController.selectedBu = value;
                                  });
                                },
                                itemValue: secondaryController.selectBuList,
                                selectedValue: secondaryController.selectedBu),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Widgets().filterByCard(
                              widget: Widgets().commonDropdownWith8sp(
                                  hintText: "Select Division",
                                  onChanged: (value) {
                                    myState(() {
                                      retailerNewOrderControllerSec.selectDivision = value;
                                    });
                                  },
                                  itemValue: retailerNewOrderControllerSec.selectDivisionList,
                                  selectedValue: retailerNewOrderControllerSec.selectDivision),
                            )),
                      ],
                    ),
                    Widgets().verticalSpace(1.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 1,
                            child: Widgets().filterByCard(
                              widget: Widgets().commonDropdownWith8sp(
                                  hintText: "Select Category",
                                  onChanged: (value) {
                                    myState(() {
                                      retailerNewOrderControllerSec.selectCategory = value;
                                    });
                                  },
                                  itemValue: retailerNewOrderControllerSec.selectCategoryList,
                                  selectedValue: retailerNewOrderControllerSec.selectCategory),
                            )),
                        Expanded(
                            flex: 1,
                            child: Widgets().filterByCard(
                              widget: Widgets().commonDropdownWith8sp(
                                  hintText: "Select Brand",
                                  onChanged: (value) {
                                    myState(() {
                                      retailerNewOrderControllerSec.selectBrand = value;
                                    });
                                  },
                                  itemValue: retailerNewOrderControllerSec.selectBrandList,
                                  selectedValue: retailerNewOrderControllerSec.selectBrand),
                            )),
                      ],
                    ),
                    Widgets().verticalSpace(1.5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Widgets().dynamicButton(
                            onTap: () async {
                              retailerNewOrderControllerSec.currentPage = 1;
                              Get.back();
                              await retailerNewOrderControllerSec.productDetailListFn(
                                  category: retailerNewOrderControllerSec.selectCategory ?? '',
                                  division: retailerNewOrderControllerSec.selectDivision ?? '',
                                  pageNumber: retailerNewOrderControllerSec.currentPage,
                                  pageSize: retailerNewOrderControllerSec.pageSize,
                                  retailerCode: widget.retailerCode,
                                  subBrand: retailerNewOrderControllerSec.selectBrand ?? '',
                                  //TODO add toggle for search
                                  searchKey: "",
                                  isFocus: false);
                            },
                            height: 5.5.h,
                            width: 32.w,
                            buttonBGColor: alizarinCrimson,
                            titleText: 'Apply',
                            titleColor: white),
                        Widgets().horizontalSpace(2.w),
                        Widgets().dynamicButton(
                            onTap: () async {
                              Get.back();
                            },
                            height: 5.5.h,
                            width: 32.w,
                            buttonBGColor: alizarinCrimson,
                            titleText: 'Clear',
                            titleColor: white),
                        Widgets().verticalSpace(1.5.h),
                      ],
                    ),
                  ],
                ),
              );
            });
          }));
        });
  }
}
