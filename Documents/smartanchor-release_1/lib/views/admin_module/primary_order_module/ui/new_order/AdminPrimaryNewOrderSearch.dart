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
import '../customer_details/AdminCustomerDetails.dart';
import '../order_detail/OrderDetail.dart';

class AdminPrimaryNewOrderSearch extends SearchDelegate<String> {
  AdminPrimaryNewOrderSearch({
    Key? key,
  });
  AdminCustomerNewOrderController adminCustomerNewOrderController = Get.find();

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
    final searchResults = adminCustomerNewOrderController.orders.where((customer) {
      final codeMatch = customer.customerNumber?.toLowerCase().contains(query.toLowerCase());
      final nameMatch = customer.customerName?.toLowerCase().contains(query.toLowerCase());
      return codeMatch! || nameMatch!;
    }).toList();


    return SingleChildScrollView(
      child: GetBuilder<AdminCustomerNewOrderController>(builder: (controller) {
        return Widgets().customLRPadding(
            child:
                 ListView.builder(
              itemCount: searchResults.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                var items = searchResults[index];
                return GestureDetector(
                  onTap: () {
                   
                  },
                  child: Widgets().neworderListCardWithStatus(
                    customerName: items.customerName!,
                    context: context,
                    statusTitle: items.status!.capitalizeFirst!,
                    orderId: items.orderCartId.toString(),
                    orderDateValue: items.createDate!,
                    customerCode: '(Code : ${items.customerNumber!})',
                    orderValue: '₹ ${items.orderValue}',
                    orderQtyValue: items.quantity.toString(),
                    statusColor: items.status != 'pending' ? magicMint : salomie,
                    onTapOrderDetail: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return AdminOrderDetail(
                          orderId: items.orderCartId!,
                          customerName: items.customerName!,
                          customerCode: items.customerNumber!,
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
    final searchSuggestion = adminCustomerNewOrderController.orders.where((customer) {
      final codeMatch = customer.customerNumber?.toLowerCase().contains(query.toLowerCase());
      final nameMatch = customer.customerName?.toLowerCase().contains(query.toLowerCase());
      return codeMatch! || nameMatch!;
    }).toList();



    return SingleChildScrollView(
      child: GetBuilder<AdminCustomerNoOrderController>(builder: (controller) {
        return Widgets().customLRPadding(
            child:
                 ListView.builder(
              itemCount: searchSuggestion.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                var items = searchSuggestion[index];
                return GestureDetector(
                  onTap: () {

                  },
                  child: Widgets().neworderListCardWithStatus(
                    customerName: items.customerName!,
                    context: context,
                    statusTitle: items.status!.capitalizeFirst!,
                    orderId: items.orderCartId.toString(),
                    orderDateValue: items.createDate!,
                    customerCode: '(Code : ${items.customerNumber!})',
                    orderValue: '₹ ${items.orderValue}',
                    orderQtyValue: items.quantity.toString(),
                    statusColor: items.status == 'pending' ? magicMint : salomie,
                    onTapOrderDetail: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return AdminOrderDetail(
                          orderId: items.orderCartId!,
                          customerName: items.customerName!,
                          customerCode: items.customerNumber!,
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
