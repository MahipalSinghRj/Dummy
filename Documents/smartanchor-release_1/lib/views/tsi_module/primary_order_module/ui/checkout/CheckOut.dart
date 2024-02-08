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
import 'package:smartanchor/views/login_module/login/controllers/LoginController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/calculationController/CalculationController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/preview_orde_controller/PreviewOrderController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/primary_order_contoller/PrimaryOrderController.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/ui/new_order/NewOrder.dart';

import '../../../../../common/AppBar.dart';
import '../../../../../common/Drawer.dart';
import '../../../../../common/NewWidgets.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../debug/printme.dart';
import '../../../../../utils/DateTimeUtils.dart';
import '../../controllers/new_order_controller/NewOrderController.dart';
import '../../models/responseModels/new_order_model/ProductByBUResponse.dart';
import '../../models/responseModels/preview_order_model/GetProductCategoryResponse.dart';
import '../../models/responseModels/primary_order_model/PaymentTermListResponse.dart';

//ignore: must_be_immutable
class CheckOut extends StatefulWidget {
  List<GetProductCategoryList> selectedValues;
  List<ProductByBUItems> productByBuItemsList;
  final String customerName;
  final String customerCode;
  final String totalOrderValue;

  CheckOut({
    Key? key,
    required this.selectedValues,
    required this.customerCode,
    required this.customerName,
    required this.totalOrderValue,
    required this.productByBuItemsList,
  }) : super(key: key);

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  GlobalController globalController = Get.put(GlobalController());
  GetLatLong getLatLong = Get.put(GetLatLong());
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
  var selectedValue;

  NewOrderController _newOrderController = Get.put(NewOrderController());
  CalculationController _calculationController = Get.put(CalculationController());
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
  List<TextEditingController> qtyTextControllers = [];

  bool isButtonClicked = false;

  @override
  void initState() {
    getReasonsApiCall();
    super.initState();
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
      _calculationController.selectedProductListItems.length,
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
                GetBuilder<NewOrderController>(builder: (controller) {
                  return Column(
                    children: [
                      Widgets().newOrderUserNameDetailsTile(context: context, titleName: widget.customerName, titleValue: "(Customer Code : ${widget.customerCode})"),
                      Widgets().checkOutExpantionCard(
                        context: context,
                        widget: Column(
                          children: [
                            _calculationController.selectedProductListItems.isEmpty
                                ? Center(child: Widgets().textWidgetWithW700(titleText: "No item available in cart.", fontSize: 12.sp))
                                : ListView.builder(
                                    itemCount: _calculationController.selectedProductListItems.length,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context, int index) {
                                      var item = _calculationController.selectedProductListItems[index];
                                      updateQtyTextControllers();
                                      TextEditingController qtyTextController = qtyTextControllers[index];
                                      qtyTextController.text = item.itemCount.toString();
                                      return NewWidgets().previousOrderListCardNew(
                                        context: context,
                                        editIconOnTap: () {
                                          Widgets().editOrderBottomSheet(
                                              context: context,
                                              productListCardWidget: Widgets().customLRPadding(child: StatefulBuilder(builder: (context, myState) {
                                                return Widgets().productListCard(
                                                    context: context,
                                                    productDetailText: item.poductName!,
                                                    deleteOnTap: () {
                                                      Get.back();
                                                      _newOrderController.deleteProductItem(item);
                                                    },
                                                    skuCodeValue: item.sKUCode!,
                                                    mrpValue: item.mRP!,
                                                    sqValue: item.sQ!,
                                                    availableQtyValue: item.availableQty!,
                                                    dlpValue: item.dLP!,
                                                    mqValue: item.masterQuantity!,
                                                    lastOdValue: item.lastOD!,
                                                    onTapDecrease: () {
                                                      printMe("On tapped increase : ");
                                                      int currentQty = item.itemCount;
                                                      if (currentQty > 1) {
                                                        currentQty--;
                                                      }
                                                      _newOrderController.updateQtyValue(currentQty, item);
                                                      qtyTextController.text = currentQty.toString();
                                                      myState(() {});
                                                    },
                                                    onTapInCrease: () {
                                                      printMe("On tapped increase : ");
                                                      int currentQty = item.itemCount;
                                                      currentQty++;
                                                      //_newOrderController.updateQtyValue(currentQty, item);
                                                      //qtyTextController.text = currentQty.toString();
                                                      if (currentQty < 100000) {
                                                        _newOrderController.updateQtyValue(currentQty, item);
                                                        qtyTextController.text = currentQty.toString();
                                                      } else {
                                                        Widgets().showToast("Quantity can not be greater than 99999");
                                                      }
                                                      myState(() {});
                                                    },
                                                    qtyTextController: qtyTextController,
                                                    onChanged: (valueItemCount) {
                                                      qtyTextController.text = valueItemCount;
                                                      int currentQty = int.tryParse(qtyTextController.text.toString()) ?? 0;
                                                      //_newOrderController.updateQtyValue(currentQty, item);
                                                      if (currentQty < 100000) {
                                                        if (currentQty != item.itemCount) {
                                                          _newOrderController.updateQtyValue(currentQty, item);
                                                          qtyTextController.text = currentQty.toString();
                                                        }
                                                      } else {
                                                        Widgets().showToast("Quantity can not be greater than 99999");
                                                      }
                                                      myState(() {});
                                                    },
                                                    // qtyText: item.itemCount == 1
                                                    //     ? "1"
                                                    //     : "${item.itemCount}",
                                                    totalValueText: item.itemCount == 1
                                                        ? "₹ ${(double.tryParse(item.dLP ?? '0.0') ?? 0.0) * (int.tryParse(item.sQ ?? '0') ?? 0)}"
                                                        : '₹ ${item.totalPrice}');
                                              })),
                                              saveButton: () {
                                                Get.back();
                                              });
                                        },
                                        deleteIconOnTap: () {
                                          printMe("Clicked delete icon");
                                          _newOrderController.deleteProductItem(item);
                                        },
                                        productDetailText: item.poductName!,
                                        qtyValue: item.itemCount.toString(),
                                        totalPriceValue:
                                            '₹ ${item.itemCount > 1 ? item.totalPrice : "${(double.tryParse(item.dLP ?? '0.0') ?? 0.0) * (int.tryParse(item.sQ ?? '0') ?? 0)}"}',
                                        itemCode: "${item.itemCode}",
                                      );
                                    },
                                  ),
                            Widgets().verticalSpace(2.h),
                            Widgets().iconElevationButton(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) {
                                  return NewOrder(
                                      customerCode: widget.customerCode,
                                      buName: primaryOrderController.businessUnit,
                                      customerName: widget.customerName,
                                      newOrderListData: const []);
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
                GetBuilder<CalculationController>(builder: (controller) {
                  return Widgets().totalOrderValueTile(context: context, iconName: cartSvgIcon, titleValue: '₹ ${controller.totalPrice}');
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
                              titleText: 'Product Sample board', valueText: previewOrderController.pSampleBoardGroupValue == 1 ? 'Yes' : "No", context: context),
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
                              .simpleTextInRow(titleText: 'Dealer Board', valueText: previewOrderController.dealerBoardGroupValue == 1 ? 'Yes' : "No", context: context),
                          Widgets().verticalSpace(2.h),
                          Widgets().filterByCard(
                              widget: Widgets().datePickerBlock(
                            context: context,
                            onTap: () {
                              _selectDate(context);
                            },
                            controller: dateController,
                            hintText: 'Shipment date',
                            width: 100.w,
                          )),
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
                                child: SvgPicture.asset(
                                  clearSignIconSvg,
                                  //height: 3.h,
                                ),
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
                                //sign.clear();
                              },
                            ),
                          ),
                          Widgets().verticalSpace(2.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Widgets().dynamicButton(
                                  onTap: () async {
                                    await _calculationController.removeSelectedProductListItems(key: "selectedProductListItems");
                                    await _calculationController.removeSelectedProductListItems(key: "totalPrice");
                                    //Get.to(const PrimaryOrder(navigationTag: "PrimaryOrder"));
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
                                    if (_calculationController.selectedProductListItems.isEmpty) {
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

                                      List<Map> sfaUploadMaps = [];
                                      List<Map> productMasterIds = [];
                                      List<String> masterIds = [];

                                      for (int i = 0; i < widget.selectedValues.length; i++) {
                                        Map s = {
                                          "categoryAvailable": "${widget.selectedValues[i].sfaProductUploadId}",
                                          "sfaUploadId": (widget.selectedValues[i].groupValue == 0) ? "Yes" : "No",
                                        };

                                        sfaUploadMaps.add(s);
                                      }

                                      for (int i = 0; i < widget.productByBuItemsList.length; i++) {
                                        masterIds.add(widget.productByBuItemsList[i].productMasterId!);
                                      }

                                      for (int i = 0; i < widget.productByBuItemsList.length; i++) {
                                        Map p = {
                                          "productMasterId": "${widget.productByBuItemsList[i].productMasterId}",
                                          "productValue": "${widget.productByBuItemsList[i].itemCount}",
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
                                          "base64File": baseFile,
                                          "mimeTypeFile": mimeTypeFile,
                                          "mimeTypeSignature": mimeTypeSignature,
                                          "base64Signature": "$base64Signature",
                                          "PaymentTermId": paymentTerm,
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

                                        log("Map : $base64Signature");

                                        await _newOrderController.submitNewOrder(submitDetailsMap: map).then((value) {
                                          if (value != null && value.successCode == 200) {
                                            var cartId = value.cartid;
                                            var orderNo = value.orderNo;

                                            _newOrderController.getDiscountPrice(cartid: cartId!).then((value) {
                                              controller.isBottomSheetClosed = false.obs;
                                              Widgets().orderIsGeneratedBottomSheet(
                                                context: context,
                                                userEmailId: globalController.customerEmailAddress,
                                                onTap: () async {
                                                  Get.back();
                                                  await _calculationController.removeSelectedProductListItems(key: "selectedProductListItems");
                                                  await _calculationController.removeSelectedProductListItems(key: "totalPrice");
                                                  globalController.splashNavigation();
                                                },
                                                discountedPrice: "${value?.items?[0].orderValue}",
                                                orderNo: orderNo!,
                                                discountValue: "${value?.items?[0].discount}",
                                                tax: "${value?.items?[0].tax}",
                                                //totalValue: _calculationController.totalPrice
                                                totalValue: "${value?.items?[0].totalOrderValue}",
                                              );
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
