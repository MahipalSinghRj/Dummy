import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartanchor/views/admin_module/primary_order_module/controllers/CustomerOutstandingAmountController.dart';
import 'package:smartanchor/views/admin_module/primary_order_module/controllers/CustomerProfileController.dart';
import 'package:smartanchor/views/tsi_module/secondary_order_module/controllers/secondary_order_controller/SecondaryOrderController.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../common/widgets.dart';
import '../../../../../debug/printme.dart';
import '../../../../../utils/functionsUtils.dart';
import '../customer_details/AdminCustomerDetails.dart';

class OutstandingAmountSearch extends SearchDelegate<String> {
  OutstandingAmountSearch({
    Key? key,
  });
  AdminCustomerOutstandingAmountController adminCustomerOutstandingAmountController = Get.find();

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
    final searchResults = adminCustomerOutstandingAmountController.outstandingList.where((customer) {
      final codeMatch = customer.bu?.toLowerCase().contains(query.toLowerCase());
      return codeMatch!;
    }).toList();


    return SingleChildScrollView(
      child: GetBuilder<AdminCustomerOutstandingAmountController>(builder: (controller) {
        return Widgets().customLRPadding(
            child:
            ListView.builder(
              itemCount: searchResults.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                var items = searchResults[index];
                return InkWell(
                    onTap: () async {

                    },
                    child: Widgets().outstandingAmountCard(
                        context: context,
                        credit: '₹ ${items.creditLimit}',
                        outstanding: items.outstanding!,
                        overdue: items.overdue!));
              },
            ));
      }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchSuggestion = adminCustomerOutstandingAmountController.outstandingList.where((customer) {
      final codeMatch = customer.bu?.toLowerCase().contains(query.toLowerCase());
      return codeMatch!;
    }).toList();



    return SingleChildScrollView(
      child: GetBuilder<AdminCustomerOutstandingAmountController>(builder: (controller) {
        return Widgets().customLRPadding(
            child:
            ListView.builder(
              itemCount: searchSuggestion.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                var items = searchSuggestion[index];
                return InkWell(
                    onTap: () async {

                    },
                    child: Widgets().outstandingAmountCard(
                        context: context,
                        credit: '₹ ${items.creditLimit}',
                        outstanding: items.outstanding!,
                        overdue: items.overdue!));
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
