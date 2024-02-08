/// UI file for admin customer primary module to show customers list on search

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartanchor/views/admin_module/primary_order_module/controllers/CustomerProfileController.dart';
import 'package:smartanchor/views/tsi_module/secondary_order_module/controllers/secondary_order_controller/SecondaryOrderController.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../common/widgets.dart';
import '../../../../../debug/printme.dart';
import '../../../../../utils/functionsUtils.dart';
import '../customer_details/AdminCustomerDetails.dart';

class AdminPrimaryCustomerSearch extends SearchDelegate<String> {
  AdminPrimaryCustomerSearch({
    Key? key,
  });
  AdminCustomerProfileController adminCustomerProfileController = Get.find();

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
    final searchResults = adminCustomerProfileController.customerLists.where((customer) {
      final codeMatch = customer.customerCode?.toLowerCase().contains(query.toLowerCase());
      final nameMatch = customer.customerName?.toLowerCase().contains(query.toLowerCase());
      return codeMatch! || nameMatch!;
    }).toList();


    return SingleChildScrollView(
      child: GetBuilder<AdminCustomerProfileController>(builder: (controller) {
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
                      /*  String retailerCode = items.customerCode!;
                      controller.retailerCode = retailerCode;
                      printMe("Customer Retailer Code : $retailerCode");
                      await controller.retailerDetailsFn(retailerCode: retailerCode).then((value) async {
                        controller.isSecondaryCustomerInfo(isSelectedInfo: true);
                        Navigator.of(context).pop();
                      });*/
                    },
                    child: Widgets().customerProfileExpantionCard(
                        context: context,
                        shopTitleText: items.customerName!,
                        customerCode: '(Code : ${items.customerCode!})',
                        address: items.address!,
                        beat: items.beat!,
                        city: items.city!,
                        state: items.state!,
                        creditLimit: items.creditLimit!,
                        outstanding: items.outstanding!,
                        overdue: items.overdue!,
                        viewDetailsOnTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) {
                            return AdminCustomerDetails(
                              customerCode: items.customerCode!,
                              customerName: items.customerName!,
                            );
                          }));
                        },
                        noteDetailsOnTap: () {},
                        callingOnTap: () {
                          Utils().makePhoneCall(items.phoneNo!);
                        },
                        locationOnTap: () {
                          launchMap(items.address!);
                        },
                        isVerified:false
                    ));
              },
            ));
      }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchSuggestion = adminCustomerProfileController.customerLists.where((customer) {
      final codeMatch = customer.customerCode?.toLowerCase().contains(query.toLowerCase());
      final nameMatch = customer.customerName?.toLowerCase().contains(query.toLowerCase());
      return codeMatch! || nameMatch!;
    }).toList();



    return SingleChildScrollView(
      child: GetBuilder<AdminCustomerProfileController>(builder: (controller) {
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
                    /*  String retailerCode = items.customerCode!;
                      controller.retailerCode = retailerCode;
                      printMe("Customer Retailer Code : $retailerCode");
                      await controller.retailerDetailsFn(retailerCode: retailerCode).then((value) async {
                        controller.isSecondaryCustomerInfo(isSelectedInfo: true);
                        Navigator.of(context).pop();
                      });*/
                    },
                    child: Widgets().customerProfileExpantionCard(
                        context: context,
                        shopTitleText: items.customerName!,
                        customerCode: '(Code : ${items.customerCode!})',
                        address: items.address!,
                        beat: items.beat!,
                        city: items.city!,
                        state: items.state!,
                        creditLimit: items.creditLimit!,
                        outstanding: items.outstanding!,
                        overdue: items.overdue!,
                        viewDetailsOnTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) {
                            return AdminCustomerDetails(
                              customerCode: items.customerCode!,
                              customerName: items.customerName!,
                            );
                          }));
                        },
                        noteDetailsOnTap: () {},
                        callingOnTap: () {
                          Utils().makePhoneCall(items.phoneNo!);
                        },
                        locationOnTap: () {
                          launchMap(items.address!);
                        },
                        isVerified:false
                    ));
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
