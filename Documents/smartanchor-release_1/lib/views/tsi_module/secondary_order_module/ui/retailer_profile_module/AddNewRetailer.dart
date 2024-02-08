import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/common/CustomLoadingWrapper.dart';
import 'package:smartanchor/views/tsi_module/secondary_order_module/models/responseModels/retailer_profile_model/RetailerDropDownResponseModal.dart';

import '../../../../../common/widgets.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../utils/Validators.dart';
import '../../controllers/retailer_profile_controller/AddNewRetailerController.dart';

class AddNewRetailer extends GetView<AddNewRetailerController> {
  AddNewRetailer({Key? key}) : super(key: key);
  AddNewRetailerController addNewRetailerController = Get.put(AddNewRetailerController());

  @override
  Widget build(BuildContext context) {
    addNewRetailerController.selectedState = null;
    addNewRetailerController.selectedDistrict = null;
    addNewRetailerController.selectedCity = null;
    addNewRetailerController.selectedBeat = null;
    addNewRetailerController.selectedPowerDealer = null;
    addNewRetailerController.selectedIaqDealer = null;
    addNewRetailerController.selectedLightingDealer = null;
    addNewRetailerController.shopeNameController.clear();
    addNewRetailerController.proprietorController.clear();
    addNewRetailerController.mobileNoController.clear();
    addNewRetailerController.emailController.clear();
    addNewRetailerController.gstNoController.clear();
    addNewRetailerController.aadharNumberController.clear();
    addNewRetailerController.panCardNoController.clear();
    addNewRetailerController.areaAddressController.clear();
    addNewRetailerController.apartmentAddressController.clear();
    addNewRetailerController.landmarkController.clear();
    addNewRetailerController.pinCodeController.clear();
    addNewRetailerController.cordinatesController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([addNewRetailerController.getDropdownValues(), addNewRetailerController.getCurrentPosition()]);
    });
    return SafeArea(
      child: Widgets().scaffoldWithAppBarDrawer(
          context: context,
          body: GetBuilder<AddNewRetailerController>(
            init: addNewRetailerController,
            builder: (controller) => CustomeLoading(
              isLoading: controller.isLoading,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: Widgets().commonDecorationWithGradient(borderRadius: 0, gradientColorList: [pink, zumthor]),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 15),
                            child: Form(
                              key: controller.addRetailerFormKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Widgets().verticalSpace(2.h),
                                  Widgets().titleText(
                                    titleText: 'Shop Name',
                                    isStar: true,
                                    fontSize: 10.sp,
                                  ),
                                  Widgets().verticalSpace(1.h),
                                  Widgets().textFieldWithoutIcon(controller.shopeNameController, 'Enter Here', TextInputType.text,
                                      showValidator: true, maxLength: 75, counterText: '', disableHeight: true, validator: (val) {
                                    return validateForEmptyOrNull(val);
                                  }),
                                  Widgets().verticalSpace(1.h),
                                  Widgets().titleText(titleText: 'Proprietor Name', isStar: true, fontSize: 10.sp),
                                  Widgets().verticalSpace(1.h),
                                  //Widgets().textFieldWithoutIcon(controller.proprietorController, 'Enter Here', TextInputType.text),
                                  Widgets().textFieldWithoutIcon(controller.proprietorController, 'Enter Here', TextInputType.text,
                                      maxLength: 75, counterText: '', disableHeight: true, showValidator: true, validator: (val) {
                                    return validateProprietorName(val);
                                  }),
                                  Widgets().verticalSpace(1.h),
                                  Widgets().titleText(titleText: 'Email', isStar: true, fontSize: 10.sp),
                                  Widgets().verticalSpace(1.h),
                                  Widgets().textFieldWithoutIcon(
                                    controller.emailController,
                                    'Enter Here',
                                    TextInputType.emailAddress,
                                    validator: (val) {
                                      return validateEmail(val);
                                    },
                                  ),
                                  Widgets().verticalSpace(1.h),
                                  Widgets().titleText(titleText: 'Mobile No.', isStar: true, fontSize: 10.sp),
                                  Widgets().verticalSpace(1.h),
                                  Widgets().textFieldWithoutIcon(
                                    controller.mobileNoController,
                                    'Enter Here',
                                    TextInputType.phone,
                                    maxLength: 10,
                                    counterText: '',
                                    validator: (val) {
                                      return validateMobileNumber(val);
                                    },
                                  ),
                                  Widgets().verticalSpace(1.h),
                                  Widgets().titleText(titleText: 'GST No.', isStar: false, fontSize: 10.sp),
                                  Widgets().verticalSpace(1.h),
                                  Widgets().textFieldWithoutIcon(
                                    controller.gstNoController,
                                    'Enter Here',
                                    TextInputType.text,
                                    // validator: (val) {
                                    //   return validateGSTNumber(val);
                                    // },
                                    showValidator: true,
                                    maxLength: 15,
                                    counterText: "",
                                  ),
                                  Widgets().verticalSpace(1.h),
                                  Widgets().titleText(
                                    titleText: 'Aadhar No.',
                                    isStar: false,
                                    fontSize: 10.sp,
                                  ),
                                  Widgets().verticalSpace(1.h),
                                  Widgets().textFieldWithoutIcon(
                                    controller.aadharNumberController, 'Enter Here', TextInputType.number, maxLength: 12, counterText: "", showValidator: true,
                                    //     validator: (val) {
                                    //   return validateAadharNumber(val);
                                    // },
                                  ),
                                  Widgets().verticalSpace(1.h),
                                  Widgets().titleText(titleText: 'Pan Card No.', isStar: false, fontSize: 10.sp),
                                  Widgets().verticalSpace(1.h),
                                  Widgets().textFieldWithoutIcon(controller.panCardNoController, 'Enter Here', TextInputType.text,
                                      //     validator: (val) {
                                      //   return validatePANCard(val);
                                      // },
                                      showValidator: true,
                                      counterText: "",
                                      maxLength: 10),
                                  Widgets().verticalSpace(1.h),
                                  Widgets().titleText(
                                    titleText: 'Shop No., Building, Comapany, Apartment',
                                    isStar: false,
                                    fontSize: 10.sp,
                                  ),
                                  Widgets().verticalSpace(1.h),
                                  Widgets().textFieldWithoutIcon(
                                    controller.apartmentAddressController,
                                    'Enter Here',
                                    TextInputType.text,
                                    showValidator: true,
                                  ),
                                  Widgets().verticalSpace(1.h),
                                  Widgets().titleText(titleText: 'Area, Colony, Street, Sector, Village', isStar: false, fontSize: 10.sp),
                                  Widgets().verticalSpace(1.h),
                                  Widgets().textFieldWithoutIcon(
                                    controller.areaAddressController,
                                    'Enter Here',
                                    TextInputType.text,
                                    showValidator: true,
                                  ),
                                  Widgets().verticalSpace(1.h),
                                  Widgets().titleText(titleText: 'Landmark', isStar: false, fontSize: 10.sp),
                                  Widgets().verticalSpace(1.h),
                                  Widgets().textFieldWithoutIcon(
                                    controller.landmarkController,
                                    'Enter Here',
                                    TextInputType.text,
                                    showValidator: true,
                                  ),
                                  Widgets().verticalSpace(1.h),
                                  Widgets().titleText(titleText: 'State', isStar: true, fontSize: 10.sp),
                                  Widgets().verticalSpace(1.h),
                                  Widgets().commonDropdown(
                                    hintText: "Select State",
                                    onChanged: (value) {
                                      controller.selectedState = value;
                                      controller.update();
                                    },
                                    itemValue: controller.state,
                                    selectedValue: controller.selectedState,
                                  ),
                                  Widgets().verticalSpace(1.h),
                                  Widgets().titleText(titleText: 'District', isStar: true, fontSize: 10.sp),
                                  Widgets().verticalSpace(1.h),
                                  Widgets().commonDropdown(
                                      hintText: "Select District",
                                      onChanged: (value) {
                                        controller.selectedDistrict = value;
                                        controller.getCitiesFromDistrict(controller.selectedDistrict ?? '');
                                        controller.update();
                                      },
                                      itemValue: controller.district,
                                      selectedValue: controller.selectedDistrict),
                                  Widgets().verticalSpace(1.h),

                                  if (controller.selectedDistrict != null) ...[
                                    Widgets().titleText(titleText: 'City', isStar: true, fontSize: 10.sp),
                                    Widgets().verticalSpace(1.h),
                                    Widgets().commonDropdown(
                                        hintText: "Select City",
                                        onChanged: (value) {
                                          controller.selectedCity = value;
                                          controller.update();
                                        },
                                        itemValue: controller.cities,
                                        selectedValue: controller.selectedCity)
                                  ],
                                  Widgets().verticalSpace(1.h),
                                  Widgets().titleText(titleText: 'Beat', isStar: false, fontSize: 10.sp),
                                  Widgets().verticalSpace(1.h),
                                  Widgets().commonDropdown(
                                      hintText: "Select Beat",
                                      onChanged: (value) {
                                        controller.selectedBeat = value;
                                        controller.update();
                                      },
                                      itemValue: controller.beat,
                                      selectedValue: controller.selectedBeat),
                                  Widgets().verticalSpace(1.h),
                                  Widgets().titleText(titleText: 'PIN Code', isStar: true, fontSize: 10.sp),
                                  Widgets().verticalSpace(1.h),
                                  Widgets().textFieldWithoutIcon(controller.pinCodeController, 'Enter Here', TextInputType.number, maxLength: 6, counterText: '',
                                      validator: (val) {
                                    return validatePincode(val);
                                  }),
                                  Widgets().verticalSpace(1.h),
                                  Widgets().titleText(titleText: 'Geo Coordinates', isStar: true, fontSize: 10.sp),
                                  Widgets().verticalSpace(1.h),
                                  Widgets().textFieldWithGeoCoordinatesContainer(
                                      controller: controller.cordinatesController,
                                      hintText: 'Enter (Latitude, Longitude)',
                                      onTapGeoCoordinate: () {
                                        controller.openMapWithCoordinates();
                                      },
                                      validator: (val) {
                                        return validateForEmptyOrNull(val);
                                      }),
                                  Widgets().verticalSpace(3.h),
                                  Container(
                                    decoration: Widgets().commonDecoration(bgColor: magicMint, borderRadius: 1.5.h),
                                    child: Widgets().customLRPadding(
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Widgets().verticalSpace(1.h),
                                        Widgets().textWidgetWithW700(titleText: 'Dealer Details', fontSize: 11.sp),
                                        Widgets().verticalSpace(2.h),
                                        Widgets().horizontalDivider(),
                                        Widgets().verticalSpace(2.h),
                                        Widgets().textWidgetWithW700(titleText: 'Power Dealer', fontSize: 11.sp),
                                        Widgets().verticalSpace(1.h),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Widgets().commonDropdownGenric<Dealer>(
                                                  hintText: "Select Power Dealer",
                                                  onChanged: (value) {
                                                    controller.selectedPowerDealer = value;
                                                    controller.update();
                                                  },
                                                  items: controller.powerDealer
                                                      .map((e) => DropdownMenuItem<Dealer>(
                                                            child: Text(e.name),
                                                            value: e,
                                                          ))
                                                      .toList(),
                                                  selectedValue: controller.selectedPowerDealer),
                                            ),
                                          ],
                                        ),
                                        Widgets().verticalSpace(2.h),
                                        Widgets().textWidgetWithW700(titleText: 'IAQ Dealer', fontSize: 11.sp),
                                        Widgets().verticalSpace(1.h),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Widgets().commonDropdownGenric<Dealer>(
                                                  hintText: "Select IAQ Dealer",
                                                  onChanged: (value) {
                                                    controller.selectedIaqDealer = value;
                                                    controller.update();
                                                  },
                                                  items: controller.iaqDelar
                                                      .map((e) => DropdownMenuItem<Dealer>(
                                                            child: Text(e.name),
                                                            value: e,
                                                          ))
                                                      .toList(),
                                                  selectedValue: controller.selectedIaqDealer),
                                            ),
                                          ],
                                        ),
                                        Widgets().verticalSpace(2.h),
                                        Widgets().textWidgetWithW700(titleText: 'Lighting Dealer', fontSize: 11.sp),
                                        Widgets().verticalSpace(1.h),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Widgets().commonDropdownGenric<Dealer>(
                                                  hintText: "Select Lighting Dealer",
                                                  onChanged: (value) {
                                                    controller.selectedLightingDealer = value;
                                                    controller.update();
                                                  },
                                                  items: controller.lightingDealer
                                                      .map((e) => DropdownMenuItem<Dealer>(
                                                            child: Text(e.name),
                                                            value: e,
                                                          ))
                                                      .toList(),
                                                  selectedValue: controller.selectedLightingDealer),
                                            ),
                                          ],
                                        ),
                                        Widgets().verticalSpace(2.h),
                                      ]),
                                    ),
                                  ),
                                  Widgets().verticalSpace(2.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Widgets().dynamicButton(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          height: 6.h,
                                          width: 44.w,
                                          buttonBGColor: codGray,
                                          titleText: 'Cancel',
                                          titleColor: white),
                                      Widgets().dynamicButton(
                                          onTap: () async {
                                            bool result = await controller.submitForm();
                                            if (result) {
                                              Navigator.pop(context, result);
                                            }
                                          },
                                          height: 6.h,
                                          width: 44.w,
                                          buttonBGColor: alizarinCrimson,
                                          titleText: 'Submit',
                                          titleColor: white)
                                    ],
                                  ),
                                  Widgets().verticalSpace(2.h),
                                ],
                              ),
                            ),
                          ),
                        ),
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
