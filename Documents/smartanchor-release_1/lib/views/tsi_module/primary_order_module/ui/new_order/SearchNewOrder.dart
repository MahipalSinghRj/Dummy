import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/primary_order_contoller/PrimaryOrderController.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/assetsConst.dart';
import '../../../../../constants/colorConst.dart';
import '../../controllers/new_order_controller/NewOrderController.dart';

class SearchNewOrder extends SearchDelegate<String> {
  String customerCode;
  String buName;
  SearchNewOrder({Key? key, required this.customerCode, required this.buName});

  NewOrderController newOrderController = Get.put(NewOrderController());
  PrimaryOrderController primaryOrderController = Get.put(PrimaryOrderController());

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
          await newOrderController.productSearch(buName: buName, customerCode: customerCode, searchString: query).then((value) {});
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
    return GetBuilder<NewOrderController>(builder: (controller) {
      return Widgets().customLRPadding(
        child:/* controller.productSearchItemList.isEmpty
            ? Center(child: Widgets().textWidgetWithW700(titleText: "No data found.", fontSize: 12.sp))
            : */ListView.builder(
                itemCount: controller.productSearchItemList.length,
                itemBuilder: (BuildContext context, int index) {
                  var items = controller.productSearchItemList[index];
                  return Widgets().newOrderListCard(
                    //TODO : add card color dynamically
                    cardColor: magnolia,
                    iconName: pcDowmLightIcon,
                    productDetailText: items.poductName.toString(),
                    checkBoxBGColor: items.cardColor == pippin ? white : checkBoxColor,
                    skuCodeValue: items.sKUCode.toString(),
                    availableQtyValue: items.availableQty.toString(),
                    wareHouseValue: primaryOrderController.selectedWarehouse ?? '',
                    lastOD: items.lastOD.toString(),
                    context: context,
                    //todo: if from new order show
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
    return GetBuilder<NewOrderController>(builder: (controller) {
      return Widgets().customLRPadding(
        child: /*controller.productSearchItemList.isEmpty
            ? Center(child: Widgets().textWidgetWithW700(titleText: "No data found.", fontSize: 12.sp))
            :*/ ListView.builder(
                itemCount: controller.productSearchItemList.length,
                itemBuilder: (BuildContext context, int index) {
                  var items = controller.productSearchItemList[index];
                  return Widgets().newOrderListCard(
                    //TODO : add card color dynamically
                    cardColor: magnolia,
                    iconName: pcDowmLightIcon,
                    productDetailText: items.poductName.toString(),
                    checkBoxBGColor: items.cardColor == pippin ? white : checkBoxColor,
                    skuCodeValue: items.sKUCode.toString(),
                    availableQtyValue: items.availableQty.toString(),
                    wareHouseValue: primaryOrderController.selectedWarehouse ?? '',
                    lastOD: items.lastOD.toString(),
                    context: context,
                    //todo: if from new order show
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
