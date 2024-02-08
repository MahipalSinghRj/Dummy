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
import 'package:smartanchor/views/login_module/login/controllers/LoginController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/calculationController/CalculationController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/order_detail_controller/OrderDetailByIdController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/preview_orde_controller/PreviewOrderController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/previous_order_controller/PreviousOrderController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/primary_order_contoller/PrimaryOrderController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/return_order_controller/ReturnOrderController.dart';

import '../../../../../common/AppBar.dart';
import '../../../../../common/Drawer.dart';
import '../../../../../common/NewWidgets.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../debug/printme.dart';
import '../../../../../utils/DateTimeUtils.dart';
import '../../../../../utils/GetLatLong.dart';
import '../../controllers/new_order_controller/NewOrderController.dart';
import '../../models/responseModels/new_order_model/ProductByBUResponse.dart';
import '../../models/responseModels/order_detail_model/OrderDetailsByIdResponse.dart';
import '../../models/responseModels/preview_order_model/GetProductCategoryResponse.dart';
import '../../models/responseModels/primary_order_model/PaymentTermListResponse.dart';
import '../new_order/NewOrder.dart';

//ignore: must_be_immutable
class OrderAgainCheckOut extends StatefulWidget {
  List<GetProductCategoryList> selectedValues;
  List<ProductDetailsbodies> productDetailsBodiesList;
  final String customerName;
  final String customerCode;
  final String totalOrderValue;
  final String navigationTag;

  OrderAgainCheckOut({
    Key? key,
    required this.selectedValues,
    required this.customerCode,
    required this.customerName,
    required this.totalOrderValue,
    required this.productDetailsBodiesList,
    required this.navigationTag,
  }) : super(key: key);

  @override
  State<OrderAgainCheckOut> createState() => _OrderAgainCheckOutState();
}

class _OrderAgainCheckOutState extends State<OrderAgainCheckOut> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  ReturnOrderController returnOrderController = Get.put(ReturnOrderController());
  CalculationController _calculationController = Get.put(CalculationController());
  GlobalController globalController = Get.put(GlobalController());
  PreviewOrderController previewOrderController = Get.put(PreviewOrderController());
  DateTimeUtils dateTimeUtils = Get.put(DateTimeUtils());
  PrimaryOrderController primaryOrderController = Get.put(PrimaryOrderController());
  LoginController loginController = Get.put(LoginController());
  FileUtils fileUtils = Get.put(FileUtils());
  PreviousOrderController previousOrderController = Get.put(PreviousOrderController());
  OrderDetailByIdController orderDetailByIdController = Get.put(OrderDetailByIdController());
  GetLatLong getLatLong = Get.put(GetLatLong());
  NewOrderController _newOrderController = Get.put(NewOrderController());

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
  List<TextEditingController> qtyTextControllers = [];
  DateTime initialDateTime = DateTime.now();

  bool isButtonClicked = false;

  @override
  void initState() {
    super.initState();
    getReasonsApiCall();
    updateQtyTextControllers();
  }

  getReasonsApiCall() async {
    await previewOrderController.getReasons();
    await primaryOrderController.orderTypeList(businessUnit: primaryOrderController.businessUnit, customerCode: widget.customerCode);
    await primaryOrderController.paymentTermList();
    getOrderTypeAndPayment();
  }

  getOrderTypeAndPayment() {
    for (int i = 0; i < primaryOrderController.orderTypeListItems!.length; i++) {
      newOrderType = primaryOrderController.orderTypeListItems?[i].description;
      orderTypeFromList.add(newOrderType!);
    }
    setState(() {});
  }

  void updateQtyTextControllers() {
    qtyTextControllers = List.generate(
      widget.productDetailsBodiesList.length,
      (index) => TextEditingController(),
    );
  }

  @override
  Widget build(BuildContext context) {
    printMe("Screen tag : ${widget.navigationTag}");
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
                GetBuilder<PreviousOrderController>(builder: (controller) {
                  return Column(
                    children: [
                      Widgets().newOrderUserNameDetailsTile(context: context, titleName: widget.customerName, titleValue: "(Customer Code : ${widget.customerCode})"),
                      Widgets().checkOutExpantionCard(
                        context: context,
                        widget: Column(
                          children: [
                            widget.productDetailsBodiesList.isEmpty
                                ? Center(child: Widgets().textWidgetWithW700(titleText: "No item available in cart.", fontSize: 12.sp))
                                : ListView.builder(
                                    itemCount: widget.productDetailsBodiesList.length,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context, int index) {
                                      var items = widget.productDetailsBodiesList[index];
                                      updateQtyTextControllers();
                                      TextEditingController qtyTextController = qtyTextControllers[index];
                                      qtyTextController.text = (items.productQty == "1" ? "1" : items.punchedQty.toString());
                                      return NewWidgets().previousOrderListCardNew(
                                        context: context,
                                        editIconOnTap: () {
                                          Widgets().editOrderBottomSheet(
                                              context: context,
                                              productListCardWidget: StatefulBuilder(builder: (context, myState) {
                                                return Widgets().editPreviousOrderBottomSheet(
                                                    deleteOnTap: () {
                                                      Get.back();
                                                      previousOrderController.deletePreviousProductItem(items);
                                                    },
                                                    productDetailText: items.productName!,
                                                    context: context,
                                                    amount: '₹  ${items.unitPriceList}',
                                                    orderIdValue: orderDetailByIdController.orderId!,
                                                    //qtyValue: items.itemCount == 1 ? items.productQty.toString() : "${items.itemCount}",
                                                    qtyValue: items.punchedQty ?? '',
                                                    onTapDecrease: () {
                                                      printMe("On tapped increase : ");
                                                      //int currentQty = items.itemCount;
                                                      int currentQty = int.tryParse(items.punchedQty ?? '0') ?? 0;

                                                      if (currentQty > 1) {
                                                        currentQty--;
                                                      }
                                                      previousOrderController.updatePreviousQtyValue(currentQty, items);
                                                      printMe("Current qty : $currentQty");
                                                      previousOrderController.isInitialTotalUnitPrice = true;
                                                      qtyTextController.text = currentQty.toString();
                                                      myState(() {});
                                                    },
                                                    onTapInCrease: () {
                                                      printMe("On tapped increase : ");
                                                      //int currentQty = items.itemCount;
                                                      int currentQty = int.tryParse(items.punchedQty ?? "0") ?? 0;
                                                      currentQty++;

                                                      //previousOrderController.updatePreviousQtyValue(currentQty, items);
                                                      previousOrderController.isInitialTotalUnitPrice = true;
                                                      //qtyTextController.text = currentQty.toString();
                                                      if (currentQty < 100000) {
                                                        previousOrderController.updatePreviousQtyValue(currentQty, items);
                                                        qtyTextController.text = currentQty.toString();
                                                      } else {
                                                        Widgets().showToast("Quantity can not be greater than 99999");
                                                      }
                                                      myState(() {});
                                                    },
                                                    qtyTextController: qtyTextController,
                                                    onChanged: (valueItemCount) {
                                                      qtyTextController.text = valueItemCount;
                                                      printMe("value item count : $valueItemCount");
                                                      int currentQty = int.tryParse(qtyTextController.text.toString()) ?? 0;
                                                      //previousOrderController.updatePreviousQtyValue(currentQty, items);
                                                      if (currentQty < 100000) {
                                                        if (currentQty != items.itemCount) {
                                                          previousOrderController.updatePreviousQtyValue(currentQty, items);
                                                          qtyTextController.text = currentQty.toString();
                                                        }
                                                      } else {
                                                        Widgets().showToast("Quantity can not be greater than 99999");
                                                      }
                                                      myState(() {});
                                                    },
                                                    //qtyText: items.itemCount == 1 ? "1" : "${items.itemCount}",
                                                    qtyText: items.punchedQty ?? '',
                                                    //totalCalculatedValue: '₹ ${items.itemCount > 1 ? items.totalPrice : items.unitPriceList}',
                                                    totalCalculatedValue:
                                                        '₹ ${((double.tryParse(items.punchedQty ?? '0') ?? 0) >= 1) ? ((double.tryParse(items.unitPriceList ?? '0') ?? 0) * (double.tryParse(items.punchedQty ?? '0') ?? 0) * (double.tryParse(items.sQ ?? '0') ?? 0)) : "0.00"}',
                                                    sqValue: items.sQ!);
                                              }),
                                              saveButton: () {
                                                Get.back();
                                              });
                                        },
                                        deleteIconOnTap: () {
                                          previousOrderController.deletePreviousProductItem(items);
                                        },
                                        productDetailText: items.productName ?? '',
                                        //qtyValue: items.itemCount.toString(),
                                        qtyValue: items.punchedQty.toString(),
                                        //totalPriceValue: '₹ ${items.itemCount > 1 ? items.totalPrice : items.unitPriceList}'
                                        totalPriceValue:
                                            '₹ ${((double.tryParse(items.unitPriceList ?? '') ?? 0) * (double.tryParse(items.punchedQty ?? '') ?? 0) * (double.tryParse(items.sQ ?? '') ?? 0)).toStringAsFixed(2)}',
                                        itemCode: "${items.itemCode}",
                                      );
                                    },
                                  ),
                            Widgets().verticalSpace(2.h),
                            Widgets().iconElevationButton(
                              /*onTap: () {
                          if (widget.navigationTag.toString().toLowerCase() == 'PreviousOrder'.toString().toLowerCase()) {
                            List<ProductByBUItems> newOrderListData = [];
                            printMe("List length : ${calculationController.selectedPreviousProductList.length}");

                            for (int i = 0; i < calculationController.selectedPreviousProductList.length; i++) {
                              ProductByBUItems items = ProductByBUItems(
                                dLP: calculationController.selectedPreviousProductList[i].dLP,
                                lastOD: calculationController.selectedPreviousProductList[i].lastOD,
                                mRP: '',
                                sKUCode: calculationController.selectedPreviousProductList[i].skuCode,
                                sQ: calculationController.selectedPreviousProductList[i].sQ,
                                warehouse: '',
                                availableQty: calculationController.selectedPreviousProductList[i].availableQty,
                                itemCode: calculationController.selectedPreviousProductList[i].itemCode,
                                masterQuantity: calculationController.selectedPreviousProductList[i].masterQuantity,
                                poductName: calculationController.selectedPreviousProductList[i].productName,
                                productMasterId: calculationController.selectedPreviousProductList[i].productMasterId,
                                isSelected: true,
                                cardColor: null,
                                itemCount: 1,
                                totalPrice: 0.0,
                                selectedQty: 1,
                              );
                              newOrderListData.add(items);
                            }

                            Navigator.push(context, MaterialPageRoute(builder: (_) {
                              return NewOrder(
                                customerCode: widget.customerCode,
                                buName: primaryOrderController.businessUnit,
                                customerName: widget.customerName,
                                newOrderListData: newOrderListData,
                                isFromNewOrder: true,
                              );
                            }));
                          } else {
                            Navigator.pop(context);
                          }
                        },*/
                              onTap: () {
                                if (widget.navigationTag.toString().toLowerCase() == 'PreviousOrder'.toString().toLowerCase()) {
                                  List<ProductByBUItems> newOrderListData = [];

                                  for (int i = 0; i < _calculationController.selectedPreviousProductList.length; i++) {
                                    ProductDetailsbodies items = _calculationController.selectedPreviousProductList[i];
                                    ProductByBUItems newOrderItem = ProductByBUItems(
                                      dLP: items.dLP,
                                      lastOD: items.lastOD,
                                      mRP: items.mrp,
                                      //sKUCode: items.skuCode,
                                      sKUCode: items.itemCode,
                                      sQ: items.sQ,
                                      //warehouse: '',
                                      availableQty: items.availableQty,
                                      itemCode: items.itemCode,
                                      masterQuantity: items.masterQuantity,
                                      poductName: items.productName,
                                      productMasterId: items.productMasterId,
                                      isSelected: true,
                                      cardColor: null,
                                      itemCount: 1,
                                      totalPrice: 0.0,
                                      selectedQty: 1,
                                    );
                                    newOrderListData.add(newOrderItem);
                                    printMe("Added new items name : ${newOrderItem.poductName}");
                                  }

                                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                                    return NewOrder(
                                      customerCode: widget.customerCode,
                                      buName: primaryOrderController.businessUnit,
                                      customerName: widget.customerName,
                                      newOrderListData: newOrderListData,
                                      isFromNewOrder: true,
                                    );
                                  }));
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                              icon: addIcon,
                              iconColor: alizarinCrimson,
                              textColor: alizarinCrimson,
                              titleText: 'Add More',
                              isBackgroundOk: false,
                              width: 93.w,
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
                  return Widgets().totalOrderValueTile(context: context, iconName: cartSvgIcon, titleValue: '₹ ${controller.totalPreviousOrderPrice}');
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
                                      child: Text(value.paymentTermName!),
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
                              titleText: 'Product Sample board', valueText: previousOrderController.pSampleBoardGroupValue == 1 ? 'Yes' : "No", context: context),
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
                              .simpleTextInRow(titleText: 'Dealer Board', valueText: previousOrderController.dealerBoardGroupValue == 1 ? 'Yes' : "No", context: context),
                          Widgets().verticalSpace(2.h),
                          // Widgets().filterByCard(
                          //     widget: Widgets().datePickerBlock(
                          //         context: context,
                          //         onTap: () {
                          //           _selectDate(context);
                          //         },
                          //         controller: dateController,
                          //         hintText: 'Shipment date',
                          //         width: 100.w,
                          //         borderRadius: 1.5.h)),

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
                                initialDateTime = value;
                                dateController.text = dateTimeUtils.formatDateTime(initialDateTime);
                              },
                              initialDateTime: initialDateTime,
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
                              widget.navigationTag == "PreviousOrder"
                                  ? Widgets().dynamicButton(
                                      onTap: () async {
                                        if (widget.productDetailsBodiesList.isEmpty) {
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
                                          printMe("productByBuItemsList : ${widget.productDetailsBodiesList.length}");

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

                                          for (int i = 0; i < widget.productDetailsBodiesList.length; i++) {
                                            printMe("Product Master Id : ${widget.productDetailsBodiesList[i]}");
                                            masterIds.add(widget.productDetailsBodiesList[i].productMasterId!);
                                          }

                                          for (int i = 0; i < widget.productDetailsBodiesList.length; i++) {
                                            printMe("CASE2");
                                            Map p = {
                                              "productMasterId": "${widget.productDetailsBodiesList[i].productMasterId}",
                                              "productValue": '${widget.productDetailsBodiesList[i].punchedQty}',
                                            };
                                            productMasterIds.add(p);
                                          }

                                          var baseFile = previewOrderController.base64;
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
                                          var lat = await getLatLong.getLatitude();
                                          var long = await getLatLong.getLongitude();

                                          if (paymentTerm == null) {
                                            Widgets().showToast("Payment term can not be empty.");
                                            setState(() {
                                              isButtonClicked = false;
                                            });
                                          } else if (base64Signature == null || base64Signature == '') {
                                            Widgets().showToast("Signature field can not be empty.");
                                            setState(() {
                                              isButtonClicked = false;
                                            });
                                          } else {
                                            var map = {
                                              "PaymentTermId": paymentTerm,
                                              //Image data
                                              "base64File": baseFile,
                                              "mimeTypeFile": mimeTypeFile,
                                              //Signature data
                                              "mimeTypeSignature": mimeTypeSignature,
                                              "base64Signature": "$base64Signature",
                                              //Other data

                                              "buName": primaryOrderController.businessUnit,
                                              "additionalProperties": "",
                                              "checkoutRemarks": remarkController.text,
                                              "currentLattitude": lat,
                                              "currentLongtitude": long,
                                              "customerCode": widget.customerCode,
                                              "screenName": globalController.customerScreenName,
                                              "needByDate": dateController.text,
                                              "orderSelection": onPremisesOrder,
                                              "productMaps": productMasterIds,
                                              "productMasterIds": masterIds,
                                              "selectReason": controller.selectedReason,
                                              "sfaUploadMaps": sfaUploadMaps,
                                              "shipmentPriority": previewOrderController.selectedShipmentPriority,
                                            };
                                            printMe(paymentTerm);
                                            log("Map : $map");

                                            await _newOrderController.submitNewOrder(submitDetailsMap: map).then((value) {
                                              if (value != null && value.successCode == 200) {
                                                printMe("Email id : ${value.cartid}");

                                                var cartId = value.cartid;
                                                var orderNo = value.orderNo;

                                                _newOrderController.getDiscountPrice(cartid: cartId!).then((value) {
                                                  printMe("Cart value : ${value!.items?[0].orderValue}");
                                                  controller.isBottomSheetClosed = false.obs;
                                                  Widgets().orderIsGeneratedBottomSheet(
                                                      context: context,
                                                      userEmailId: globalController.customerEmailAddress,
                                                      onTap: () async {
                                                        //await _calculationController.setSelectedListItems([]);
                                                        //_calculationController.selectedProductListItems.clear();
                                                        //await _calculationController.setTotalPrice('0.0');
                                                        Get.back();
                                                        globalController.splashNavigation();
                                                      },
                                                      discountedPrice: "${value.items?[0].orderValue}",
                                                      orderNo: orderNo!,
                                                      discountValue: "${value.items?[0].discount}",
                                                      tax: "${value.items?[0].tax}",
                                                      // totalValue: _calculationController.totalPreviousOrderPrice,
                                                      totalValue: "${value.items?[0].totalOrderValue}");
                                                });
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
                                      titleText: 'Place Order',
                                      titleColor: white)
                                  : Widgets().dynamicButton(
                                      onTap: () async {
                                        // if (_calculationController.selectedReturnProductList.isEmpty) {
                                        //   Widgets().showToast("Please add item in cart");
                                        //   return;
                                        // }
                                        if (widget.productDetailsBodiesList.isEmpty) {
                                          Widgets().showToast("Please add item in cart");
                                          return;
                                        }
                                        globalController.setLastOrderRemark(lastOrderRemark: remarkController.text);
                                        printMe("Remark : ${remarkController.text}");
                                        List<Map> sfaUploadMaps = [];
                                        List<Map> productMasterIds = [];
                                        List<String> masterIds = [];

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

                                        for (int i = 0; i < widget.productDetailsBodiesList.length; i++) {
                                          printMe("Product Master Id : ${widget.productDetailsBodiesList[i]}");
                                          masterIds.add(widget.productDetailsBodiesList[i].productMasterId!);
                                        }

                                        for (int i = 0; i < widget.productDetailsBodiesList.length; i++) {
                                          printMe("CASE2");
                                          Map p = {
                                            "productMasterId": "${widget.productDetailsBodiesList[i].productMasterId}",
                                            "productValue": '${widget.productDetailsBodiesList[i].itemCount}',
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
                                        } else if (data == null) {
                                          Widgets().showToast("Signature field can not be empty.");
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
                                      },
                                      height: 6.h,
                                      width: 45.w,
                                      buttonBGColor: alizarinCrimson,
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
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = dateTimeUtils.formatDateTime(selectedDate);
        printMe("Selected Date : $selectedDate");
      });
    }
  }
}
