import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/primary_order_contoller/PrimaryOrderController.dart';

import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../../primary_order_module/controllers/new_order_controller/NewOrderController.dart';
import '../../controllers/retailer_new-order_controller/RetailerNewOrderController.dart';

class RetailerProductSearch extends SearchDelegate<String> {
  String retailerCode;

  RetailerProductSearch({
    Key? key,
    required this.retailerCode,
  });

  NewOrderController newOrderController = Get.put(NewOrderController());
  PrimaryOrderController primaryOrderController = Get.put(PrimaryOrderController());
  RetailerNewOrderControllerSec retailerNewOrderControllerSec = Get.put(RetailerNewOrderControllerSec());

  @override
  String get query => super.query;

  @override
  set query(String value) {
    super.query = value;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () async {
          FocusScope.of(context).unfocus();
          Widgets().loadingDataDialog(loadingText: "Data is fetching, please wait.");
          // await retailerNewOrderControllerSec
          //     .productDetailListFn(
          //   category: '',
          //   division: '',
          //   pageNumber: 1,
          //   pageSize: 5,
          //   retailerCode: retailerCode,
          //   subBrand: '',
          //   searchKey: query,
          //   isFocus: false,
          // )

          retailerNewOrderControllerSec.currentPage = 1;
          retailerNewOrderControllerSec.pageSize = 200;

          await retailerNewOrderControllerSec
              .productDetailListFn(
                  category: '',
                  division: '',
                  pageNumber: retailerNewOrderControllerSec.currentPage,
                  pageSize: retailerNewOrderControllerSec.pageSize,
                  retailerCode: retailerCode,
                  subBrand: '',
                  searchKey: query,
                  isFocus: false)
              .then((value) {
            Get.back();
          });
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return GetBuilder<RetailerNewOrderControllerSec>(builder: (controller) {
      return Widgets().customLRPadding(
        child: controller.productLists.isEmpty
            ? Center(child: Widgets().textWidgetWithW700(titleText: "No data found.", fontSize: 12.sp))
            : ListView.builder(
                itemCount: controller.productLists.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const ScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  var items = controller.productLists[index];
                  return Widgets().retailerNewOrderListCard(
                    cardColor: magnolia,
                    iconName: pcDowmLightIcon,
                    productDetailText: items.productName.toString(),
                    checkBoxBGColor: items.cardColor == pippin ? white : checkBoxColor,
                    skuCodeValue: items.skuCode.toString(),
                    availableQtyValue: items.quantity.toString(),
                    //TODO : Pending disti
                    district: items.distributor.toString(),
                    lastOD: items.lastOrderd.toString(),
                    context: context,
                    initialValue: controller.isProductSelected(items),
                    onChanged: (value) {
                      controller.updateProductSelection(items, value!);
                    },
                  );
                },
              ),
      );
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return GetBuilder<RetailerNewOrderControllerSec>(builder: (controller) {
      return Widgets().customLRPadding(
        child: controller.productLists.isEmpty
            ? Center(child: Widgets().textWidgetWithW700(titleText: "No data found.", fontSize: 12.sp))
            : ListView.builder(
                itemCount: controller.productLists.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const ScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  var items = controller.productLists[index];
                  return Widgets().retailerNewOrderListCard(
                    cardColor: magnolia,
                    iconName: pcDowmLightIcon,
                    productDetailText: items.productName.toString(),
                    checkBoxBGColor: items.cardColor == pippin ? white : checkBoxColor,
                    skuCodeValue: items.skuCode.toString(),
                    availableQtyValue: items.quantity.toString(),
                    //TODO : Pending disti
                    district: items.distributor.toString(),
                    lastOD: items.lastOrderd.toString(),
                    context: context,
                    initialValue: controller.isProductSelected(items),
                    onChanged: (value) {
                      controller.updateProductSelection(items, value!);
                    },
                  );
                },
              ),
      );
    });
  }
}
