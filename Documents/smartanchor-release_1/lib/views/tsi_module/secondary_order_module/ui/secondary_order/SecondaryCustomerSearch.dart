import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartanchor/views/tsi_module/secondary_order_module/controllers/secondary_order_controller/SecondaryOrderController.dart';
import '../../../../../common/widgets.dart';
import '../../../../../debug/printme.dart';

class SecondaryCustomerSearch extends SearchDelegate<String> {
  SecondaryCustomerSearch({
    Key? key,
  });
  SecondaryController secondaryController = Get.find();

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
    final searchResults = secondaryController.newRetailersDetailsDataList.where((customer) {
      final codeMatch = customer.retailerCode?.toLowerCase().contains(query.toLowerCase());
      final nameMatch = customer.retailerName?.toLowerCase().contains(query.toLowerCase());
      return codeMatch! || nameMatch!;
    }).toList();

    final searchResultsByBeat = secondaryController.retailerDetailsByBeatList.where((customer) {
      final codeMatch = customer.retailerCode?.toLowerCase().contains(query.toLowerCase());
      final nameMatch = customer.retailerName?.toLowerCase().contains(query.toLowerCase());
      return codeMatch! || nameMatch!;
    }).toList();

    return SingleChildScrollView(
      child: GetBuilder<SecondaryController>(builder: (controller) {
        return Widgets().customLRPadding(
            child: controller.selectSecCustomersByBeat
                ? ListView.builder(
                    itemCount: searchResultsByBeat.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      var items = searchResultsByBeat[index];
                      return InkWell(
                          onTap: () async {
                            String retailerCode = items.retailerCode!;
                            controller.retailerCode = retailerCode;
                            printMe("Customer Retailer Code : $retailerCode");
                            await controller.retailerDetailsFn(retailerCode: retailerCode).then((value) async {
                              controller.isSecondaryCustomerInfo(isSelectedInfo: true);
                              Navigator.of(context).pop();
                            });
                          },
                          child: Widgets().secRetailerNameAndCodeTile(retailerDetail: " ${items.retailerName} / ${items.retailerCode}"));
                    },
                  )
                : ListView.builder(
                    itemCount: searchResults.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      var items = searchResults[index];
                      return InkWell(
                          onTap: () async {
                            String retailerCode = items.retailerCode!;
                            controller.retailerCode = retailerCode;
                            printMe("Customer Retailer Code : $retailerCode");
                            await controller.retailerDetailsFn(retailerCode: retailerCode).then((value) async {
                              controller.isSecondaryCustomerInfo(isSelectedInfo: true);
                              Navigator.of(context).pop();
                            });
                          },
                          child: Widgets().secRetailerNameAndCodeTile(retailerDetail: " ${items.retailerName} / ${items.retailerCode}"));
                    },
                  ));
      }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchSuggestion = secondaryController.newRetailersDetailsDataList.where((customer) {
      final codeMatch = customer.retailerCode?.toLowerCase().contains(query.toLowerCase());
      final nameMatch = customer.retailerName?.toLowerCase().contains(query.toLowerCase());
      return codeMatch! || nameMatch!;
    }).toList();

    final searchSuggestionByBeat = secondaryController.retailerDetailsByBeatList.where((customer) {
      final codeMatch = customer.retailerCode?.toLowerCase().contains(query.toLowerCase());
      final nameMatch = customer.retailerName?.toLowerCase().contains(query.toLowerCase());
      return codeMatch! || nameMatch!;
    }).toList();

    return SingleChildScrollView(
      child: GetBuilder<SecondaryController>(builder: (controller) {
        return Widgets().customLRPadding(
            child: controller.selectSecCustomersByBeat
                ? ListView.builder(
                    itemCount: searchSuggestionByBeat.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      var items = searchSuggestionByBeat[index];
                      return InkWell(
                          onTap: () async {
                            String retailerCode = items.retailerCode!;
                            controller.retailerCode = retailerCode;
                            printMe("Customer Retailer Code : $retailerCode");
                            await controller.retailerDetailsFn(retailerCode: retailerCode).then((value) async {
                              controller.isSecondaryCustomerInfo(isSelectedInfo: true);
                              Navigator.of(context).pop();
                            });
                          },
                          child: Widgets().secRetailerNameAndCodeTile(retailerDetail: " ${items.retailerName} / ${items.retailerCode}"));
                    },
                  )
                : ListView.builder(
                    itemCount: searchSuggestion.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      var items = searchSuggestion[index];
                      return InkWell(
                          onTap: () async {
                            String retailerCode = items.retailerCode!;
                            controller.retailerCode = retailerCode;
                            printMe("Customer Retailer Code : $retailerCode");
                            await controller.retailerDetailsFn(retailerCode: retailerCode).then((value) async {
                              controller.isSecondaryCustomerInfo(isSelectedInfo: true);
                              Navigator.of(context).pop();
                            });
                          },
                          child: Widgets().secRetailerNameAndCodeTile(retailerDetail: " ${items.retailerName} / ${items.retailerCode}"));
                    },
                  ));
      }),
    );
  }
}
