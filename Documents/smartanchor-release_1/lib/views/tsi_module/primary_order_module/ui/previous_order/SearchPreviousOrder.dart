import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartanchor/views/tsi_module/primary_order_module/controllers/previous_order_controller/PreviousOrderController.dart';

import '../../../../../common/widgets.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../debug/printme.dart';
import '../order_again/OrderAgain.dart';
import '../order_detail/OrderDetail.dart';

class SearchPreviousOrder extends SearchDelegate<String> {
  final String navigationTag;
  String customerCode;
  String customerName;
  SearchPreviousOrder({Key? key, required this.customerCode, required this.customerName, required this.navigationTag});

  PreviousOrderController previousOrderController = Get.put(PreviousOrderController());

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
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
    printMe("Screen tag : $navigationTag");
    final searchResults = previousOrderController.previousOrderItemsList.where((customer) {
      final codeMatch = customer.orderNo?.toString().toLowerCase().contains(query.toLowerCase());
      return codeMatch!;
    }).toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (BuildContext context, int index) {
        var items = searchResults[index];
        return Widgets().orderDetailsCardWithStatus(
          buttonName: "Order Again",
          context: context,
          orderId: int.tryParse(items.orderNo ?? '0') ?? 0,
          statusTitle: items.sTATUSFLAG == "S" ? "Completed" : "Pending",
          orderDateValue: items.orderDate!,
          orderQtyValue: items.OrderQty!,
          orderValue: items.orderValue!,
          onTapOrderAgain: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return OrderAgain(
                navigationTag: navigationTag,
                orderCartId: items.orderId.toString(),
                customerName: customerName,
                customerCode: customerCode,
                bu: items.BU!,
              );
            }));
          },
          onTapOrderDetail: () {
            printMe('Order detail button clicked');
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return OrderDetail(
                navigationTag: navigationTag,
                orderCartId: items.orderId.toString(),
                customerCode: customerCode,
                customerName: customerName,
                orderNo: items.orderNo.toString(),
                bu: items.BU!,
              );
            }));
          },
          statusColor: items.sTATUSFLAG == "S" ? magicMint : salomie,
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    printMe("Screen tag : $navigationTag");
    final suggestions = previousOrderController.previousOrderItemsList.where((customer) {
      final codeMatch = customer.orderNo?.toString().toLowerCase().contains(query.toLowerCase());
      return codeMatch!;
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int index) {
        var items = suggestions[index];
        return Widgets().orderDetailsCardWithStatus(
          buttonName: "Order Again",
          context: context,
          orderId: int.tryParse(items.orderNo ?? '0') ?? 0,
          statusTitle: items.sTATUSFLAG == "S" ? "Completed" : "Pending",
          orderDateValue: items.orderDate!,
          orderQtyValue: items.OrderQty!,
          orderValue: items.orderValue!,
          onTapOrderAgain: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return OrderAgain(
                navigationTag: navigationTag,
                orderCartId: items.orderId.toString(),
                customerName: customerName,
                customerCode: customerCode,
                bu: items.BU!,
              );
            }));
          },
          onTapOrderDetail: () {
            printMe('Order detail button clicked');
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return OrderDetail(
                navigationTag: navigationTag,
                orderCartId: items.orderId.toString(),
                customerCode: customerCode,
                customerName: customerName,
                orderNo: items.orderNo.toString(),
                bu: items.BU!,
              );
            }));
          },
          statusColor: items.sTATUSFLAG == "S" ? magicMint : salomie,
        );
      },
    );
  }
}
