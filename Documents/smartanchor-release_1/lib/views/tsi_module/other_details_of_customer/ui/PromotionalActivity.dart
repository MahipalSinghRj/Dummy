import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/views/tsi_module/other_details_of_customer/ui/AddNewMeet.dart';
import 'package:smartanchor/views/tsi_module/other_details_of_customer/ui/NukkadMeetDetails.dart';
import '../../../../../common/PromotionalActivityDialog.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../controllers/PromotionalActivityController.dart';

class PromotionalActivity extends StatefulWidget {
  const PromotionalActivity({Key? key}) : super(key: key);

  @override
  State<PromotionalActivity> createState() => _PromotionalActivityState();
}

class _PromotionalActivityState extends State<PromotionalActivity> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController filterController = TextEditingController();
  PromotionalActivityController promotionalActivityController = Get.put(PromotionalActivityController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PromotionalActivityController>(builder: (controller) {
      return SafeArea(
        child: Widgets().scaffoldWithAppBarDrawer(
            context: context,
            body: Container(
              width: 100.w,
              height: 100.h,
              color: alizarinCrimson,
              child: bottomDetailsSheet(controller: controller),
            )),
      );
    });
  }

  Widget bottomDetailsSheet({required PromotionalActivityController controller}) {
    return DraggableScrollableSheet(
      initialChildSize: 01,
      minChildSize: 01,
      maxChildSize: 1,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          height: 100.h,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(1.5.h),
              topRight: Radius.circular(1.5.h),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: coralRed,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(1.5.h),
                      topRight: Radius.circular(1.5.h),
                    ),
                  ),
                  child: Center(child: Widgets().textWidgetWithW500(titleText: "Promotional Activity", fontSize: 11.sp, textColor: white)),
                ),
                Container(
                  decoration: Widgets().commonDecorationWithGradient(borderRadius: 0, gradientColorList: [pink, zumthor]),
                  child: Widgets().customLRPadding(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Widgets().verticalSpace(2.h),
                        Widgets().iconElevationButton(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) {
                              return const AddNewMeet();
                            }));
                          },
                          icon: addIcon,
                          iconColor: alizarinCrimson,
                          titleText: 'Add New Meet',
                          textColor: alizarinCrimson,
                          isBackgroundOk: false,
                          width: 100.w,
                          bgColor: codGray,
                        ),
                        Widgets().verticalSpace(2.h),
                        Widgets().simpleTextWithIcon(
                            context: context,
                            bgColor: white,
                            titleName: 'Search Meets',
                            iconName: filter,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => const PromotionalActivityDialog(),
                              );
                            }),
                        Widgets().verticalSpace(1.h),
                        Widgets().textFieldWidget(controller: filterController, hintText: 'Name', iconName: search, keyBoardType: TextInputType.text, fillColor: white),
                        Widgets().verticalSpace(2.h),
                      ],
                    ),
                  ),
                ),
                Widgets().verticalSpace(3.h),
                Widgets().customLRPadding(
                  child: ListView.builder(
                    itemCount: controller.promotionActivityDataList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      var items = controller.promotionActivityDataList[index];
                      return Widgets().newPromotionActivity(
                          onTapNukkadMeetCard: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) {
                              return NukkadMeetDetails(index: index);
                            }));
                          },
                          promotionActivityPersonImage: items.image,
                          userName: items.userName,
                          dateIn: items.dateIn,
                          timeIn: items.timeIn,
                          dateOut: items.dateOut,
                          timeOut: items.timeOut,
                          visitBrief: items.visitBrief);
                    },
                  ),
                ),
                Widgets().verticalSpace(2.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
