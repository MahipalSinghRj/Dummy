import 'dart:convert';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/global/common_controllers/GlobalController.dart';
import 'package:smartanchor/utils/FileUtils.dart';
import 'package:smartanchor/utils/GetLatLong.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/preview_orde_controller/PreviewOrderController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/primary_order_contoller/PrimaryOrderController.dart';

import '../../../../../common/AppBar.dart';
import '../../../../../common/Drawer.dart';
import '../../../../../common/NewWidgets.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../debug/printme.dart';
import '../../../../../utils/DateTimeUtils.dart';
import '../../../primary_order_module/models/responseModels/preview_order_model/GetProductCategoryResponse.dart';
import '../../controllers/retailer_calculation_controller/RetailerCalculationController.dart';
import '../../controllers/retailer_checkout_controller/RetailerCheckoutController.dart';
import '../../controllers/retailer_new-order_controller/RetailerNewOrderController.dart';
import '../../controllers/retailer_previous_order_controller/RetailerPreviousOrderController.dart';
import '../../controllers/secondary_order_controller/SecondaryOrderController.dart';
import '../../models/responseModels/retailer_checkout_model/DistributeResponse.dart';
import '../../models/responseModels/retailer_new-order_model/ProductDetailListResponse.dart';
import 'RetailerNewOrder.dart';

//ignore: must_be_immutable
class RetailerCheckOut extends StatefulWidget {
  List<GetProductCategoryList> selectedValues;
  List<ProductLists> productList;
  final String retailerName;
  final String retailerCode;
  final String totalOrderValue;
  final String emailAddress;

  RetailerCheckOut({
    Key? key,
    required this.selectedValues,
    required this.retailerName,
    required this.retailerCode,
    required this.totalOrderValue,
    required this.productList,
    required this.emailAddress,
  }) : super(key: key);

  @override
  State<RetailerCheckOut> createState() => _RetailerCheckOutState();
}

class _RetailerCheckOutState extends State<RetailerCheckOut> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  GlobalController globalController = Get.put(GlobalController());
  GetLatLong getLatLong = Get.put(GetLatLong());
  PreviewOrderController previewOrderController = Get.put(PreviewOrderController());
  DateTimeUtils dateTimeUtils = Get.put(DateTimeUtils());
  PrimaryOrderController primaryOrderController = Get.put(PrimaryOrderController());
  FileUtils fileUtils = Get.put(FileUtils());
  final TextEditingController dateController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  final _sign = GlobalKey<SignatureState>();
  var strokeWidth = 5.0;
  var sign;
  int groupValue = 1;
  DateTime selectedDate = DateTime.now();
  String? newOrderType;
  List<String> orderTypeFromList = [];
  var data;
  String? onPremisesOrder;

  RetailerCalculationController _retailerCalculationController = Get.put(RetailerCalculationController());
  RetailerCheckOutController retailerCheckOutController = Get.put(RetailerCheckOutController());
  RetailerNewOrderControllerSec retailerNewOrderControllerSec = Get.put(RetailerNewOrderControllerSec());
  RetailerPreviousOrderController retailerPreviousOrderController = Get.put(RetailerPreviousOrderController());
  SecondaryController secondaryController = Get.put(SecondaryController());

  List<Map> productQtyAndSkuCode = [];

  var selectedValue;
  String? dealCode;
  List<TextEditingController> qtyTextControllers = [];

  bool isButtonClicked = false;

  @override
  void initState() {
    super.initState();
    getReasonsApiCall();
    // qtyTextControllers = List.generate(
    //   _retailerCalculationController.selectedRetailerProductListItems.length,
    //   (index) => TextEditingController(),
    // );
    updateQtyTextControllers();
  }

  getReasonsApiCall() async {
    await previewOrderController.getReasons();

    await secondaryController.retailerDistribute(retailerCode: widget.retailerCode).then((value) {});

    setState(() {});
  }

  getProductQtyAndSkuCode() {
    productQtyAndSkuCode = [];
    for (int i = 0; i < _retailerCalculationController.selectedRetailerProductListItems.length; i++) {
      printMe("Quantity is : ${_retailerCalculationController.selectedRetailerProductListItems[i].itemCount}");

      Map s = {
        "quantity": "${_retailerCalculationController.selectedRetailerProductListItems[i].itemCount}",
        "skuCode": _retailerCalculationController.selectedRetailerProductListItems[i].skuCode,
      };
      productQtyAndSkuCode.add(s);
    }
  }

  void updateQtyTextControllers() {
    qtyTextControllers = List.generate(
      _retailerCalculationController.selectedRetailerProductListItems.length,
      (index) => TextEditingController(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        previewOrderController.pSampleBoardGroupValue = 0;
        previewOrderController.dealerBoardGroupValue = 0;
        Navigator.pop(context);
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          appBar: MainAppBar(context, scaffoldKey),
          drawer: MainDrawer(context),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GetBuilder<RetailerNewOrderControllerSec>(builder: (controller) {
                  return Column(
                    children: [
                      Widgets().newOrderUserNameDetailsTile(context: context, titleName: widget.retailerName, titleValue: "(Retailer Code : ${widget.retailerCode})"),
                      Widgets().checkOutExpantionCard(
                        context: context,
                        widget: Column(
                          children: [
                            _retailerCalculationController.selectedRetailerProductListItems.isEmpty
                                ? Center(child: Widgets().textWidgetWithW700(titleText: "No item available in cart.", fontSize: 12.sp))
                                : ListView.builder(
                                    itemCount: _retailerCalculationController.selectedRetailerProductListItems.length,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context, int index) {
                                      var item = _retailerCalculationController.selectedRetailerProductListItems[index];
                                      updateQtyTextControllers();
                                      TextEditingController qtyTextController = qtyTextControllers[index];
                                      qtyTextController.text = item.itemCount == 1 ? "1" : item.itemCount.toString();
                                      return NewWidgets().previousOrderListCardNew(
                                        context: context,
                                        editIconOnTap: () {
                                          Widgets().editOrderSecondaryBottomSheet(
                                              context: context,
                                              productListCardWidget: Widgets().customLRPadding(child: StatefulBuilder(builder: (context, myState) {
                                                return Widgets().productListSecondayCard(
                                                    context: context,
                                                    productDetailText: item.productName!,
                                                    deleteOnTap: () {
                                                      Get.back();
                                                      retailerNewOrderControllerSec.deleteProductItem(item);
                                                    },
                                                    skuCodeValue: item.skuCode!,
                                                    mrpValue: "200.00",
                                                    sqValue: item.sq!,
                                                    availableQtyValue: item.quantity!,
                                                    dlpValue: item.rlp!,
                                                    mqValue: item.mq!,
                                                    lastOdValue: item.lastOrderd!,
                                                    onTapDecrease: () {
                                                      printMe("On tapped increase : ");
                                                      int currentQty = item.itemCount;
                                                      if (currentQty > 1) {
                                                        currentQty--;
                                                      }
                                                      retailerNewOrderControllerSec.updateQtyValue(currentQty, item);
                                                      qtyTextController.text = currentQty.toString();
                                                      myState(() {});
                                                    },
                                                    onTapInCrease: () {
                                                      printMe("On tapped increase : ");
                                                      int currentQty = item.itemCount;
                                                      currentQty++;
                                                      //retailerNewOrderControllerSec.updateQtyValue(currentQty, item);
                                                      //qtyTextController.text = currentQty.toString();
                                                      if (currentQty < 100000) {
                                                        retailerNewOrderControllerSec.updateQtyValue(currentQty, item);
                                                        qtyTextController.text = currentQty.toString();
                                                      } else {
                                                        Widgets().showToast("Quantity can not be greater than 99999");
                                                      }
                                                      myState(() {});
                                                      printMe("Quantity is f123 : ${item.quantity}");
                                                    },
                                                    qtyTextController: qtyTextController,
                                                    onChanged: (valueItemCount) {
                                                      qtyTextController.text = valueItemCount;
                                                      int currentQty = int.tryParse(qtyTextController.text.toString()) ?? 0;
                                                      //controller.updateQtyValue(currentQty, item);
                                                      if (currentQty < 100000) {
                                                        if (currentQty != item.itemCount) {
                                                          retailerNewOrderControllerSec.updateQtyValue(currentQty, item);
                                                          qtyTextController.text = currentQty.toString();
                                                        }
                                                      } else {
                                                        Widgets().showToast("Quantity can not be greater than 99999");
                                                      }
                                                      myState(() {});
                                                    },
                                                    //qtyText: item.itemCount == 1 ? "1" : "${item.itemCount}",
                                                    totalValueText: item.itemCount == 1 ? "₹ ${item.rlp}" : '₹ ${item.totalPrice?.toStringAsFixed(2)}');
                                              })),
                                              saveButton: () {
                                                Get.back();
                                              });
                                        },
                                        deleteIconOnTap: () {
                                          printMe("Clicked delete icon");
                                          retailerNewOrderControllerSec.deleteProductItem(item);
                                        },
                                        productDetailText: item.productName!,
                                        qtyValue: item.itemCount.toString(),
                                        totalPriceValue: '₹ ${item.itemCount > 1 ? item.totalPrice!.toStringAsFixed(2) : item.rlp}',
                                        itemCode: "${item.skuCode}",
                                      );
                                    },
                                  ),
                            Widgets().verticalSpace(2.h),
                            Widgets().iconElevationButton(
                              onTap: () {
                                List<ProductLists> retailerNewOrderList = [];

                                for (int i = 0; i < retailerPreviousOrderController.orderDetailsProductList.length; i++) {
                                  if (retailerPreviousOrderController.orderDetailsProductList.isNotEmpty) {
                                    var newItems = retailerPreviousOrderController.orderDetailsProductList[i];
                                    printMe("Quantity is : ${newItems.quantity}");
                                    ProductLists items = ProductLists(
                                      skuCode: newItems.skuCode,
                                      quantity: newItems.quantity,
                                      mq: "",
                                      sq: "",
                                      cardColor: null,
                                      itemCount: 0,
                                      lastOrderd: "",
                                      productName: newItems.productName,
                                      rlp: newItems.rlp,
                                      totalPrice: 0.0,
                                    );
                                    retailerNewOrderList.add(items);
                                  }
                                }
                                Navigator.push(context, MaterialPageRoute(builder: (_) {
                                  return RetailerNewOrder(
                                    retailerCode: widget.retailerCode,
                                    retailerName: widget.retailerName,
                                    buName: secondaryController.selectedBu ?? '',
                                    retailerNewOrderList: retailerNewOrderList,
                                    emailAddress: widget.emailAddress,
                                    isFromNewOrder: true,
                                  );
                                }));
                              },
                              icon: addIcon,
                              iconColor: alizarinCrimson,
                              titleText: 'Add More',
                              textColor: alizarinCrimson,
                              isBackgroundOk: false,
                              width: 100.w,
                              bgColor: codGray,
                            ),
                            Widgets().verticalSpace(2.h),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
                GetBuilder<RetailerCalculationController>(builder: (controller) {
                  return Widgets().totalOrderValueTile(context: context, iconName: cartSvgIcon, titleValue: '₹ ${controller.totalPrice}');
                }),
                GetBuilder<PreviewOrderController>(builder: (controller) {
                  return Column(
                    children: [
                      Widgets().verticalSpace(2.h),
                      Widgets().customLRPadding(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Widgets().textWidgetWithW700(titleText: "Which products are available (Category)", fontSize: 11.sp),
                          Widgets().verticalSpace(2.h),
                          ListView.builder(
                            itemCount: widget.selectedValues.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              var items = widget.selectedValues[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 1.h),
                                child: Widgets().simpleTextInRow(titleText: items.itemName ?? '', valueText: items.groupValue == 1 ? "Yes" : "No", context: context),
                              );
                            },
                          ),
                        ],
                      )),
                      Widgets().verticalSpace(2.h),
                      Widgets().horizontalDivider(),
                      Widgets().verticalSpace(2.h),
                      Widgets().customLRPadding(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Widgets().textWidgetWithW700(titleText: "POSM visibility (Any POSM material available)", fontSize: 11.sp),
                          Widgets().verticalSpace(2.h),
                          Widgets()
                              .simpleTextInRow(titleText: 'Dealer Board', valueText: previewOrderController.dealerBoardGroupValue == 1 ? 'Yes' : "No", context: context),
                        ],
                      )),
                      Widgets().verticalSpace(2.h),
                      Widgets().horizontalDivider(),
                      Widgets().verticalSpace(2.h),
                      Widgets().customLRPadding(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Widgets().simpleTextInRow(
                              titleText: 'Product Sample board', valueText: previewOrderController.pSampleBoardGroupValue == 1 ? 'Yes' : "No", context: context),
                          Widgets().verticalSpace(2.h),
                          Widgets().filterByCard(
                            widget: NewWidgets().datePickerWithNoPreviousDate(
                              context: context,
                              onTap: () {
                                Get.back();
                              },
                              controller: dateController,
                              hintText: 'Shipment date',
                              width: 100.w,
                              onDateTimeChanged: (value) {
                                selectedDate = value;
                                dateController.text = dateTimeUtils.formatDateTime(selectedDate);
                              },
                              initialDateTime: selectedDate,
                            ),
                          ),
                          Widgets().verticalSpace(2.h),
                          Widgets().filterByCard(
                              widget: Widgets().commonDropdown(
                                  hintText: "Shipment Priority",
                                  onChanged: (value) {
                                    controller.getShipmentData(value!);
                                  },
                                  itemValue: controller.shipmentValueList,
                                  selectedValue: controller.selectedShipmentPriority)),
                          Widgets().verticalSpace(2.h),
                          Row(
                            children: [
                              Radio(
                                visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                                activeColor: alizarinCrimson,
                                value: 1,
                                groupValue: groupValue,
                                onChanged: (value) {
                                  setState(() {
                                    groupValue = int.tryParse((value ?? '0').toString()) ?? 0;
                                    if (groupValue == 1) {
                                      onPremisesOrder = "On-premises Order";
                                      printMe("On-premises Order : $onPremisesOrder");
                                    }
                                    printMe("On-premises Order value : $groupValue");
                                  });
                                },
                              ),
                              Widgets().textWidgetWithW400(titleText: "On-premises Order", fontSize: 10.sp, textColor: codGray),
                              Row(
                                children: [
                                  Radio(
                                    visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                                    activeColor: alizarinCrimson,
                                    value: 0,
                                    groupValue: groupValue,
                                    onChanged: (value) {
                                      setState(() {
                                        groupValue = int.tryParse((value ?? "0").toString()) ?? 0;
                                        if (groupValue == 0) {
                                          onPremisesOrder = "Virtual Order";
                                          printMe("Virtual Order : $onPremisesOrder");
                                        }
                                        printMe("Virtual Order value : $groupValue");
                                      });
                                    },
                                  ),
                                  Widgets().textWidgetWithW400(titleText: "Virtual Order", fontSize: 10.sp, textColor: codGray)
                                ],
                              )
                            ],
                          ),
                          Widgets().verticalSpace(2.h),
                          Widgets().iconElevationButton(
                              onTap: () {
                                fileUtils.takeFileWithGallery().then((value) {
                                  if (value != null) {
                                    setState(() {
                                      Widgets().showToast("Photo successfully attached.");
                                      previewOrderController.base64 = fileUtils.fileToBase64(value);
                                      previewOrderController.fileName = fileUtils.getFilename(value);
                                      previewOrderController.extension = previewOrderController.fileName.split('.').last;
                                    });
                                  } else {
                                    Widgets().showToast("Please try again.");
                                  }
                                });
                              },
                              icon: camera,
                              titleText: 'Upload Photo',
                              isBackgroundOk: false,
                              width: 100.w,
                              bgColor: codGray,
                              textColor: alizarinCrimson,
                              iconColor: alizarinCrimson),
                          Widgets().verticalSpace(2.h),
                          Widgets().filterByCard(
                              widget: Widgets().commonDropdown(
                                  hintText: "Reason",
                                  onChanged: (value) {
                                    controller.getReasonsData(value!);
                                  },
                                  itemValue: controller.reasonsList,
                                  selectedValue: controller.selectedReason)),
                          Widgets().verticalSpace(2.h),
                          Widgets().filterByCard(
                              widget: Container(
                            height: 6.h,
                            width: 100.w,
                            padding: EdgeInsets.only(left: 4.w, right: 4.w),
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(1.5.h),
                            ),
                            child: Center(
                              child: DropdownButton<Distributor>(
                                  underline: DropdownButtonHideUnderline(child: Container()),
                                  isExpanded: true,
                                  isDense: true,
                                  focusColor: alizarinCrimson,
                                  iconSize: 3.h,
                                  icon: const Icon(Icons.keyboard_arrow_down_sharp),
                                  value: selectedValue,
                                  style: TextStyle(color: codGray),
                                  iconEnabledColor: codGray,
                                  items: secondaryController.distributorList.map<DropdownMenuItem<Distributor>>((Distributor value) {
                                    return DropdownMenuItem<Distributor>(
                                      value: value,
                                      child: Text("${value.dealerName!}/${value.dealerCode!}"),
                                    );
                                  }).toList(),
                                  hint: Text(
                                    'Select Distributor',
                                    style: TextStyle(fontSize: 10.sp),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      dealCode = value!.dealerCode;
                                      selectedValue = value;
                                      printMe("Value -->$dealCode");
                                    });
                                  }),
                            ),
                          )),
                          Widgets().verticalSpace(2.h),
                          Widgets().commentContainer(hintText: 'Enter Remark', commentController: remarkController),
                          Widgets().verticalSpace(2.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Widgets().textWidgetWithW700(titleText: "Please Sign Below...", fontSize: 12.sp),
                              InkWell(
                                onTap: () {
                                  if (previewOrderController.base64Sign.toString().isNotEmpty) {
                                    sign.clear();
                                    previewOrderController.base64Sign = '';
                                    setState(() {});
                                  }
                                },
                                child: SvgPicture.asset(clearSignIconSvg),
                              ),
                            ],
                          ),
                          Widgets().verticalSpace(2.h),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 350),
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: double.infinity,
                            decoration: Widgets().commonDecoration(borderRadius: 1.5.h, bgColor: white),
                            child: Signature(
                              color: curiousBlue,
                              key: _sign,
                              strokeWidth: strokeWidth,
                              onSign: () async {
                                FocusScope.of(context).unfocus();
                                sign = _sign.currentState;
                                final image = await sign!.getData();
                                data = await image.toByteData(format: ui.ImageByteFormat.png);
                                printMe("Signature Data is : $data");
                                previewOrderController.base64Sign = base64.encode(await data.buffer.asUint8List());
                                previewOrderController.extension = previewOrderController.base64Sign.split('.').last;
                              },
                            ),
                          ),
                          Widgets().verticalSpace(2.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Widgets().dynamicButton(
                                  onTap: () async {
                                    await _retailerCalculationController.removeSelectedProductListItems(key: "selectedRetailerProductListItems");
                                    await _retailerCalculationController.removeSelectedProductListItems(key: "totalPrice");
                                    globalController.splashNavigation();
                                  },
                                  height: 6.h,
                                  width: 45.w,
                                  buttonBGColor: codGray,
                                  titleText: 'Cancel Order',
                                  titleColor: white),
                              Widgets().horizontalSpace(2.w),
                              Widgets().dynamicButton(
                                  onTap: () async {
                                    if (_retailerCalculationController.selectedRetailerProductListItems.isEmpty) {
                                      Widgets().showToast("Please add item in cart");
                                      setState(() {
                                        isButtonClicked = false;
                                      });
                                      return;
                                    }
                                    if (!isButtonClicked) {
                                      setState(() {
                                        isButtonClicked = true;
                                      });
                                      //Function to get product qty and sku code
                                      await getProductQtyAndSkuCode();
                                      globalController.setLastOrderRemark(lastOrderRemark: remarkController.text);
                                      var baseFile = await previewOrderController.base64;
                                      var mimeTypeFile = '';
                                      var mimeTypeSignature = '';
                                      if (baseFile == null) {
                                        baseFile = '';
                                      } else {
                                        mimeTypeFile = "image/png";
                                      }
                                      var base64Signature = previewOrderController.base64Sign;
                                      if (base64Signature == null) {
                                        base64Signature = '';
                                      } else {
                                        mimeTypeSignature = "image/png";
                                      }

                                      if (dealCode == null) {
                                        Widgets().showToast("Please select Distributor.");
                                        setState(() {
                                          isButtonClicked = false;
                                        });
                                      } else if (base64Signature == null || base64Signature == '') {
                                        Widgets().showToast("Signature field can not be empty.");
                                        setState(() {
                                          isButtonClicked = false;
                                        });
                                      } else if (_retailerCalculationController.totalPrice == "0.00") {
                                        Widgets().showToast("Price is not available! Please update the Price");
                                        setState(() {
                                          isButtonClicked = false;
                                        });
                                      } else {
                                        printMe('Sagar');
                                        printMe(_retailerCalculationController.totalPrice.runtimeType);
                                        Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
                                        var lat = await getLatLong.getLatitude();
                                        var long = await getLatLong.getLongitude();
                                        var newMap = {
                                          "POSM": previewOrderController.dealerBoardGroupValue == 1 ? 'Yes' : "No",
                                          "distributorNo": "$dealCode",
                                          "documentInBase64": "$baseFile",
                                          //"documentInBase64": "",
                                          "lat": lat,
                                          "lng": long,
                                          "mimeType": mimeTypeFile,
                                          "needByDate": dateController.text,
                                          "noSelected": retailerNewOrderControllerSec.noRetailerSelectProduct,
                                          "orderType": "NewOrder",
                                          "place": "remote",
                                          "productSampleBoard": previewOrderController.pSampleBoardGroupValue,
                                          "products": productQtyAndSkuCode,
                                          "reason": controller.selectedReason,
                                          "remark": remarkController.text,
                                          "retailerCode": widget.retailerCode,
                                          "screenName": globalController.customerScreenName,
                                          "shipmentPriority": previewOrderController.selectedShipmentPriority,
                                          //"signInBase64": "",
                                          "signInBase64": "$base64Signature",
                                          "yesSelected": retailerNewOrderControllerSec.yesRetailerSelectProduct
                                        };
                                        log("Data map is : $newMap");
                                        await retailerCheckOutController.saveOrderFn(submitDetailsMap: newMap).then((value) {
                                          Get.back();
                                          if (value?.message == 'OrderPlaced') {
                                            Widgets().orderRetailerCheckoutBottomSheet(
                                                context: context,
                                                message: "New Order",
                                                userEmailId: widget.emailAddress,
                                                onTap: () async {
                                                  Get.back();
                                                  await _retailerCalculationController.removeSelectedProductListItems(key: "selectedRetailerProductListItems");
                                                  globalController.splashNavigation();
                                                },
                                                orderNumber: value!.orderNo ?? '');
                                          } else {
                                            Widgets().showToast("Something went wrong : ${value?.message}");
                                          }
                                        });
                                      }
                                    }
                                  },
                                  height: 6.h,
                                  width: 45.w,
                                  buttonBGColor: (isButtonClicked) ? boulder : alizarinCrimson,
                                  titleText: 'Place Order',
                                  titleColor: white),
                            ],
                          ),
                        ],
                      )),
                      Widgets().verticalSpace(2.h),
                    ],
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
