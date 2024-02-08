import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/global/common_controllers/GlobalController.dart';
import 'package:smartanchor/utils/FileUtils.dart';
import 'package:smartanchor/views/login_module/login/controllers/LoginController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/return_order_controller/ReturnOrderController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/calculationController/CalculationController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/preview_orde_controller/PreviewOrderController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/primary_order_contoller/PrimaryOrderController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/ui/new_order/NewOrder.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/ui/primary_order/PrimaryOrder.dart';

import '../../../../../common/AppBar.dart';
import '../../../../../common/Drawer.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../debug/printme.dart';
import '../../../../../utils/DateTimeUtils.dart';
import '../../../../../utils/GetLatLong.dart';
import '../../controllers/new_order_controller/NewOrderController.dart';
import '../../models/responseModels/new_order_model/ProductByBUResponse.dart';
import '../../models/responseModels/preview_order_model/GetProductCategoryResponse.dart';
import '../../models/responseModels/primary_order_model/PaymentTermListResponse.dart';
import '../../models/responseModels/return_order_model/ReturnOrderbyIdResponse.dart';
import 'ReturnOrder.dart';

//ignore: must_be_immutable
class ReturnOrderCheckOut extends StatefulWidget {
  List<GetProductCategoryList> selectedValues;
  List<ReturnOrderByIdListData> returnOrderByIdListData;
  final String customerName;
  final String customerCode;
  final String totalOrderValue;

  ReturnOrderCheckOut({
    Key? key,
    required this.selectedValues,
    required this.customerCode,
    required this.customerName,
    required this.totalOrderValue,
    required this.returnOrderByIdListData,
  }) : super(key: key);

  @override
  State<ReturnOrderCheckOut> createState() => _ReturnOrderCheckOutState();
}

class _ReturnOrderCheckOutState extends State<ReturnOrderCheckOut> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  ReturnOrderController returnOrderController = Get.put(ReturnOrderController());
  CalculationController _calculationController = Get.put(CalculationController());
  GlobalController globalController = Get.put(GlobalController());
  PreviewOrderController previewOrderController = Get.put(PreviewOrderController());
  DateTimeUtils dateTimeUtils = Get.put(DateTimeUtils());
  PrimaryOrderController primaryOrderController = Get.put(PrimaryOrderController());
  LoginController loginController = Get.put(LoginController());
  FileUtils fileUtils = Get.put(FileUtils());
  final TextEditingController dateController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  final _sign = GlobalKey<SignatureState>();
  var strokeWidth = 5.0;
  var sign;
  int groupValue = 1;
  DateTime selectedDate = DateTime.now();
  String? orderType;
  String? paymentTerm;
  String? paymentTermId;
  String? newOrderType;
  List<String> orderTypeFromList = [];
  String? newPaymentType;
  List<String> paymentTypeFromList = [];
  var data;
  String? onPremisesOrder;
  String? virtualOrder;
  var selectedValue;

  bool isButtonClicked = false;

  @override
  void initState() {
    getReasonsApiCall();
    super.initState();
    printMe(_calculationController.totalPrice);
  }

  getReasonsApiCall() async {
    await previewOrderController.getReasons();
    await primaryOrderController.orderTypeList(businessUnit: primaryOrderController.businessUnit, customerCode: widget.customerCode);
    await primaryOrderController.paymentTermList();
    getOrderTypeAndPayment();
    //getPaymentTypeAndPayment();
  }

  getOrderTypeAndPayment() {
    for (int i = 0; i < primaryOrderController.orderTypeListItems!.length; i++) {
      newOrderType = primaryOrderController.orderTypeListItems?[i].description;
      orderTypeFromList.add(newOrderType!);
    }
    setState(() {});
  }

  // getPaymentTypeAndPayment() {
  //   for (int i = 0; i < primaryOrderController.paymentTermListItems!.length; i++) {
  //     newPaymentType = primaryOrderController.paymentTermListItems?[i].paymentTermId;
  //     paymentTypeFromList.add(newPaymentType!);
  //   }
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: MainAppBar(context, scaffoldKey),
        drawer: MainDrawer(context),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GetBuilder<ReturnOrderController>(builder: (controller) {
                return Column(
                  children: [
                    Widgets().newOrderUserNameDetailsTile(context: context, titleName: widget.customerName, titleValue: "(Customer Code : ${widget.customerCode})"),
                    Widgets().checkOutExpantionCard(
                      context: context,
                      widget: Column(
                        children: [
                          _calculationController.selectedReturnProductList.isEmpty
                              ? Center(child: Widgets().textWidgetWithW700(titleText: "No item available in cart.", fontSize: 12.sp))
                              : ListView.builder(
                                  itemCount: _calculationController.selectedReturnProductList.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (BuildContext context, int index) {
                                    var items = _calculationController.selectedReturnProductList[index];
                                    return Widgets().previousOrderListCard(
                                        context: context,
                                        editIconOnTap: () {
                                          Widgets().editOrderBottomSheet(
                                              context: context,
                                              productListCardWidget: StatefulBuilder(builder: (context, myState) {
                                                return Widgets().returnOrderListCard(
                                                    context: context,
                                                    productDetailText: items.poductName ?? '',
                                                    deleteOnTap: () {
                                                      Get.back();
                                                      returnOrderController.deleteReturnProductItem(items);
                                                      myState(() {});
                                                    },
                                                    skuCodeValue: items.sKUCode ?? '',
                                                    mrpValue: '₹ ${items.mRP!}',
                                                    dlpValue: '₹ ${items.dLP!}',
                                                    totalValue: items.itemCount == 1 ? "₹ ${items.dLP}" : '₹ ${items.totalPrice}',
                                                    onTapDecrease: () {
                                                      printMe("On tapped increase : ");
                                                      int currentQty = items.itemCount;
                                                      if (currentQty > 1) {
                                                        currentQty--;
                                                      }
                                                      returnOrderController.updateReturnQtyValue(currentQty, items);
                                                      myState(() {});
                                                    },
                                                    onTapInCrease: () {
                                                      printMe("On tapped increase : ");
                                                      int currentQty = items.itemCount;
                                                      currentQty++;
                                                      returnOrderController.updateReturnQtyValue(currentQty, items);
                                                      myState(() {});
                                                    },
                                                    qtyText: items.itemCount == 1 ? "1" : "${items.itemCount}",
                                                    totalValueText: items.itemCount == 1 ? "₹ ${items.dLP}" : '₹ ${items.totalPrice}');
                                              }),
                                              saveButton: () {
                                                Get.back();
                                              });
                                        },
                                        deleteIconOnTap: () {
                                          returnOrderController.deleteReturnProductItem(items);
                                        },
                                        productDetailText: items.poductName ?? '',
                                        qtyValue: items.itemCount.toString(),
                                        totalPriceValue: '₹ ${items.itemCount > 1 ? items.totalPrice : items.dLP}');
                                  },
                                ),
                          Widgets().verticalSpace(2.h),
                          Widgets().iconElevationButton(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);

                              // Navigator.push(context, MaterialPageRoute(builder: (_) {
                              //   return ReturnOrder(
                              //     bu: primaryOrderController.businessUnit,
                              //     customerCode: widget.customerCode,
                              //     customerName: widget.customerName,
                              //   );
                              // }));
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
              GetBuilder<CalculationController>(builder: (controller) {
                return Widgets().totalOrderValueTile(context: context, iconName: cartSvgIcon, titleValue: '₹ ${controller.totalReturnPrice}');
              }),
              GetBuilder<PreviewOrderController>(builder: (controller) {
                return Column(
                  children: [
                    Widgets().verticalSpace(2.h),
                    Widgets().customLRPadding(
                        child: Column(
                      children: [
                        Widgets().simpleTextInRow(titleText: 'Warehouses', valueText: '${primaryOrderController.selectedWarehouse}', context: context),
                        Widgets().verticalSpace(2.h),
                        Widgets().filterByCard(
                            widget: Widgets().commonDropdown(
                                hintText: "Order Type",
                                onChanged: (value) {
                                  setState(() {
                                    orderType = value;
                                  });
                                },
                                itemValue: orderTypeFromList,
                                selectedValue: orderType)),
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
                            child: DropdownButton<PaymentTermList>(
                                underline: DropdownButtonHideUnderline(child: Container()),
                                isExpanded: true,
                                isDense: true,
                                focusColor: alizarinCrimson,
                                iconSize: 3.h,
                                icon: const Icon(Icons.keyboard_arrow_down_sharp),
                                value: selectedValue,
                                style: TextStyle(color: codGray),
                                iconEnabledColor: codGray,
                                items: primaryOrderController.paymentTermListItems!.map<DropdownMenuItem<PaymentTermList>>((PaymentTermList value) {
                                  return DropdownMenuItem<PaymentTermList>(
                                    value: value,
                                    child: Text(value.description!),
                                  );
                                }).toList(),
                                hint: Text(
                                  'Payment term',
                                  style: TextStyle(fontSize: 10.sp),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    paymentTerm = value!.paymentTermId;
                                    selectedValue = value;
                                    printMe("Value -->$paymentTerm");
                                  });
                                }),
                          ),
                        ))
                      ],
                    )),
                    Widgets().verticalSpace(2.h),
                    Widgets().horizontalDivider(),
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
                        Widgets().simpleTextInRow(
                            titleText: 'Product Sample board', valueText: returnOrderController.pSampleBoardGroupValue == 1 ? 'Yes' : "No", context: context),
                      ],
                    )),
                    Widgets().verticalSpace(2.h),
                    Widgets().horizontalDivider(),
                    Widgets().verticalSpace(2.h),
                    Widgets().customLRPadding(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Widgets()
                            .simpleTextInRow(titleText: 'Dealer Board', valueText: returnOrderController.dealerBoardGroupValue == 1 ? 'Yes' : "No", context: context),
                        Widgets().verticalSpace(2.h),
                        Widgets().filterByCard(
                            widget: Widgets().datePicker(
                                context: context,
                                onTap: () {
                                  Get.back();
                                },
                                controller: dateController,
                                hintText: 'Shipment date',
                                width: 100.w,
                                initialDateTime: selectedDate,
                                onDateTimeChanged: (value) {
                                  selectedDate = value;
                                  dateController.text = dateTimeUtils.formatDateTime(selectedDate);
                                })),
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
                                      groupValue = int.tryParse((value ?? '0').toString()) ?? 0;
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
                        Widgets().commentContainer(hintText: 'Enter Remark', commentController: remarkController),
                        Widgets().verticalSpace(2.h),
                        // Center(
                        //   child: Widgets().textWidgetWithW700(titleText: "Please Sign Below...", fontSize: 12.sp),
                        // ),
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
                              previewOrderController.base64Sign = base64.encode(data.buffer.asUint8List());
                              previewOrderController.extension = previewOrderController.base64Sign.split('.').last;
                              //sign.clear();
                            },
                          ),
                        ),
                        Widgets().verticalSpace(2.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Widgets().dynamicButton(
                                onTap: () {
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
                                  if (_calculationController.selectedReturnProductList.isEmpty) {
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
                                    globalController.setLastOrderRemark(lastOrderRemark: remarkController.text);
                                    printMe("Remark : ${remarkController.text}");
                                    List<Map> sfaUploadMaps = [];
                                    List<Map> productMasterIds = [];
                                    List<String> masterIds = [];

                                    printMe("selectedValues :${widget.selectedValues.length}");
                                    printMe("productByBuItemsList : ${widget.returnOrderByIdListData.length}");

                                    for (int i = 0; i < widget.selectedValues.length; i++) {
                                      printMe("-------");
                                      Map s = {
                                        "categoryAvailable": "${widget.selectedValues[i].sfaProductUploadId}",
                                        "sfaUploadId": (widget.selectedValues[i].groupValue == 0) ? "Yes" : "No",
                                      };
                                      printMe("CASE1 added");
                                      printMe(s);

                                      sfaUploadMaps.add(s);
                                    }

                                    printMe(sfaUploadMaps);

                                    for (int i = 0; i < widget.returnOrderByIdListData.length; i++) {
                                      masterIds.add(widget.returnOrderByIdListData[i].productMasterId!);
                                    }

                                    for (int i = 0; i < widget.returnOrderByIdListData.length; i++) {
                                      printMe("CASE2");
                                      Map p = {
                                        "productMasterId": "${widget.returnOrderByIdListData[i].productMasterId}",
                                        "productValue": '${widget.returnOrderByIdListData[i].itemCount}',
                                      };
                                      productMasterIds.add(p);
                                    }

                                    var map = {
                                      "customerCode": widget.customerCode,
                                      "productMaps": productMasterIds,
                                      "productMasterIds": masterIds,
                                      "remarks": remarkController.text,
                                      "screenName": globalController.customerScreenName,
                                      "selectReason": controller.selectedReason
                                    };

                                    printMe("Map : $map");

                                    if (paymentTerm == null) {
                                      Widgets().showToast("Payment term can not be empty.");
                                      setState(() {
                                        isButtonClicked = false;
                                      });
                                    } else if (data == null) {
                                      Widgets().showToast("Signature field can not be empty.");
                                      setState(() {
                                        isButtonClicked = false;
                                      });
                                    } else {
                                      await returnOrderController.submitReturnOrder(submitDetailsMap: map).then((value) {
                                        if (value != null && value.successCode == 200) {
                                          printMe("Email id : ${globalController.customerEmailAddress}");

                                          controller.isBottomSheetClosed = false.obs;
                                          Widgets().orderIsGeneratedBottomSheet(
                                              discountedPrice: '',
                                              orderNo: '',
                                              context: context,
                                              userEmailId: globalController.customerEmailAddress,
                                              onTap: () async {
                                                await _calculationController.setSelectedListItems([]);
                                                //_calculationController.selectedProductListItems.clear();
                                                await _calculationController.setTotalPrice('0.0');
                                                Navigator.pop(context);
                                                globalController.splashNavigation();
                                              },
                                              discountValue: "",
                                              tax: "",
                                              totalValue: '');
                                        } else {
                                          Widgets().showToast("Something went wrong.");
                                        }
                                      });
                                    }
                                  }
                                },
                                height: 6.h,
                                width: 45.w,
                                buttonBGColor: (isButtonClicked) ? boulder : alizarinCrimson,
                                titleText: 'Return Order',
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
    );
  }
}
