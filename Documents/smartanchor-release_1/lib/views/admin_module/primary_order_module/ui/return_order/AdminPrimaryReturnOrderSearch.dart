import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartanchor/views/admin_module/primary_order_module/controllers/CustomerNoOrderController.dart';
import 'package:smartanchor/views/admin_module/primary_order_module/controllers/CustomerProfileController.dart';
import 'package:smartanchor/views/tsi_module/secondary_order_module/controllers/secondary_order_controller/SecondaryOrderController.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../common/widgets.dart';
import '../../../../../constants/colorConst.dart';
import '../../../../../debug/printme.dart';
import '../../../../../utils/functionsUtils.dart';
import '../../controllers/CustomerNewOrderController.dart';
import '../../controllers/CustomerReturnOrderController.dart';
import '../customer_details/AdminCustomerDetails.dart';
import '../order_detail/OrderDetail.dart';
import 'ReturnOrderDetail.dart';

class AdminPrimaryReturnOrderSearch extends SearchDelegate<String> {
  AdminPrimaryReturnOrderSearch({
    Key? key,
  });

  AdminCustomerReturnOrderController adminCustomerReturnOrderController = Get.find();

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
    final searchResults = adminCustomerReturnOrderController.orderDetails.where((customer) {
      final codeMatch = customer.customerCode?.toLowerCase().contains(query.toLowerCase());
      final nameMatch = customer.customerName?.toLowerCase().contains(query.toLowerCase());
      return codeMatch! || nameMatch!;
    }).toList();

    return SingleChildScrollView(
      child: GetBuilder<AdminCustomerReturnOrderController>(builder: (controller) {
        return Widgets().customLRPadding(
            child: ListView.builder(
          itemCount: searchResults.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            var items = searchResults[index];
            return GestureDetector(
              onTap: () {},
              child: Widgets().neworderListCardWithStatus(
                customerName: items.customerName!,
                context: context,
                statusTitle: items.orderStatus.toString().capitalizeFirst!,
                orderId: items.orderId!,
                orderDateValue: items.orderDate!,
                customerCode: '(Code : ${items.customerCode!})',
                orderValue: '₹ ${items.orderValue!}',
                orderQtyValue: items.orderQuantity!,
                statusColor: items.orderStatus != 'pending' ? magicMint : salomie,
                onTapOrderDetail: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return AdminReturnOrderDetail(
                      orderId: items.orderId!,
                      customerCode: items.customerCode!,
                      customerName: items.customerName!,
                    );
                  }));
                },
              ),
            );
          },
        ));
      }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchSuggestion = adminCustomerReturnOrderController.orderDetails.where((customer) {
      final codeMatch = customer.customerCode?.toLowerCase().contains(query.toLowerCase());
      final nameMatch = customer.customerName?.toLowerCase().contains(query.toLowerCase());
      return codeMatch! || nameMatch!;
    }).toList();

    return SingleChildScrollView(
      child: GetBuilder<AdminCustomerNoOrderController>(builder: (controller) {
        return Widgets().customLRPadding(
            child: ListView.builder(
          itemCount: searchSuggestion.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            var items = searchSuggestion[index];
            return GestureDetector(
              onTap: () {},
              child: Widgets().neworderListCardWithStatus(
                customerName: items.customerName!,
                context: context,
                statusTitle: items.orderStatus.toString().capitalizeFirst!,
                orderId: items.orderId!,
                orderDateValue: items.orderDate!,
                customerCode: '(Code : ${items.customerCode!})',
                orderValue: '₹ ${items.orderValue!}',
                orderQtyValue: items.orderQuantity!,
                statusColor: items.orderStatus != 'pending' ? magicMint : salomie,
                onTapOrderDetail: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return AdminReturnOrderDetail(
                      orderId: items.orderId!,
                      customerCode: items.customerCode!,
                      customerName: items.customerName!,
                    );
                  }));
                },
              ),
            );
            //Widgets().secRetailerNameAndCodeTile(retailerDetail: " ${items.customerName} / ${items.customerCode}"));
          },
        ));
      }),
    );
  }

  void launchMap(String address) async {
    String query = Uri.encodeComponent(address);
    String googleUrl = "https://www.google.com/maps/search/?api=1&query=$query";

    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    }
  }
}
