import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smartanchor/global/common_controllers/GlobalController.dart';
import 'package:smartanchor/views/home_module/models/response/CustomerDemoGraphyResponse.dart';
import 'package:smartanchor/views/home_module/models/response/DashBoardBannerResponse.dart';
import 'package:smartanchor/views/home_module/models/response/SalesActivityResponse.dart';

import '../../../configurations/ApiConstants.dart';
import '../../../debug/printme.dart';
import '../../../services/ApiService.dart';
import '../../../utils/ChartsSupportClasses.dart';
import '../models/response/BUSalesResponse.dart';
import '../models/response/SalesActivityGraphResponse.dart';
import '../models/response/SalesActivityMonthlyResponse.dart';
import '../models/response/SalesTsiResponse.dart';
import '../models/response/SalesWorthResponse.dart';
import '../models/response/TopCustomerResponse.dart';
import '../models/response/TopProductsResponse.dart';

class HomeController extends GetxController {
//*******************************************
  GlobalController globalController = Get.put(GlobalController());

  List<BannerItems>? bannerItems = [];

  String todayOrderValue = '';
  String percentageDifference = '';
  String orderCount = '';
  String newCustomers = '';
  String totalMonthlyOrdersCount = '';
  String totalMonthlyOrdersValue = '';

  List<String> primaryCategoriesList = [];
  List<double> primaryOrdersList = [];
  List<String> secondaryCategoriesList = [];
  List<double> secondaryOrdersList = [];

  List<TopCustomerList> topCustomerList = [];

  List<TopProductList> topProductList = [];

  List<String> salesCategoriesList=[];
  List<double> salesOrdersList=[];

  List<int> customerCount = [];
  List<String> customerNames = [];

  List<ChartData> customData = [];

  String? selectedSalesActivityFilter = 'WEEKLY';
  String? selectedSalesWorthFilter = 'WEEKLY';
  String? selectedSalesBUFilter = '';

  String? salesTarget;
  String? salesValueCompleted;

  List<ChartDataTSITarget> salesTSIChartData = [];

  List<String> categoriesListBuSales = [];
  List<String> filtersListBuSales = [];
  List<SalesDataBu> salesDataBuSales = [];

  double totalValue = 0;

  getDashBoardBanner() async {
    await getDashBoardBannerAPI().then((value) {
      if (value != null) {
        bannerItems = value.items;
        update();
      }
    });
  }

  ///API Calls
  Future<DashBoardBannerResponse?> getDashBoardBannerAPI() {
    return ApiService.getRequest(ApiConstants.dashBoardBanner).then((value) {
      try {
        if (value != null) {
          DashBoardBannerResponse getDashBoardBannerResponse = DashBoardBannerResponse.fromJson(value);
          return getDashBoardBannerResponse;
        } else {
          return null;
        }
      } catch (exception, stackTrace) {
        printErrors("ExceptionHandling at parsing  api request : $exception");
        printErrors("Stacktrace : ");
        printErrors(stackTrace);

        return null;
      }
    }, onError: (e) {
      return null;
    });
  }

  getSalesActivity() async{
   await  getSalesActivityAPI().then((value) {
      if (value != null) {
        todayOrderValue = value.todayOrderValue!;
        percentageDifference = value.percentageDifference!;
        orderCount = value.orderCount!;
        newCustomers = value.newCustomers!;

        print(value.percentageDifference);
        print(value.orderCount);

        update();
      }
    });
  }

  ///API Calls

  Future<SalesActivityResponse?> getSalesActivityAPI() {
    var map = {"employeeScreenName": globalController.customerScreenName};
//AP0POW001
    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.salesActivity, requestJson).then((value) {
      try {
        if (value != null) {
          SalesActivityResponse getSalesActivityResponse = SalesActivityResponse.fromJson(value);
          return getSalesActivityResponse;
        } else {
          return null;
        }
      } catch (exception, stackTrace) {
        printErrors("ExceptionHandling at parsing  api request : $exception");
        printErrors("Stacktrace : ");
        printErrors(stackTrace);

        return null;
      }
    }, onError: (e) {
      return null;
    });
  }

  getSalesActivityMonthly() async{
    await getSalesActivityMonthlyAPI().then((value) {
      if (value != null) {
        totalMonthlyOrdersValue = value.totalMonthlyOrdersValue!;
        totalMonthlyOrdersCount = value.totalMonthlyOrdersCount!;

        update();
      }
    });
  }

  ///API Calls

  Future<SalesActivityMonthlyResponse?> getSalesActivityMonthlyAPI() {
    var map = {"employeeScreenName": globalController.customerScreenName};
//AP0POW001
    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.salesActivityMonthly, requestJson).then((value) {
      try {
        if (value != null) {
          SalesActivityMonthlyResponse getSalesActivityMonthlyResponse = SalesActivityMonthlyResponse.fromJson(value);
          return getSalesActivityMonthlyResponse;
        } else {
          return null;
        }
      } catch (exception, stackTrace) {
        printErrors("ExceptionHandling at parsing  api request : $exception");
        printErrors("Stacktrace : ");
        printErrors(stackTrace);

        return null;
      }
    }, onError: (e) {
      return null;
    });
  }

  getSalesActivityGraph(filterValue)async {
    await getSalesActivityGraphAPI(filterValue).then((value) {
      if (value != null) {
        primaryCategoriesList =[];
        primaryOrdersList =[];
        secondaryCategoriesList=[];
        secondaryOrdersList=[];

        primaryCategoriesList = value.primaryCategoriesList!;
        primaryOrdersList = value.primaryOrdersList!;
        secondaryCategoriesList = value.secondaryCategoriesList!;
        secondaryOrdersList = value.secondaryOrdersList!;

        printMe("primaryCategoriesList : ${primaryCategoriesList.length}");
        printMe("primaryOrdersList : ${primaryOrdersList.length}");
        printMe("secondaryOrdersList : ${secondaryOrdersList.length}");

        update();
      }
    });
  }

  ///API Calls

  Future<SalesActivityGraphResponse?> getSalesActivityGraphAPI(filter) {
    var map = {"employeeScreenName": globalController.customerScreenName, "filtertype": filter};
//AP0POW001
    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.salesActivityGraph, requestJson).then((value) {
      try {
        if (value != null) {
          SalesActivityGraphResponse getSalesActivityGraphResponse = SalesActivityGraphResponse.fromJson(value);
          return getSalesActivityGraphResponse;
        } else {
          return null;
        }
      } catch (exception, stackTrace) {
        printErrors("ExceptionHandling at parsing  api request : $exception");
        printErrors("Stacktrace : ");
        printErrors(stackTrace);

        return null;
      }
    }, onError: (e) {
      return null;
    });
  }

  getTopCustomers() async{
    await getTopCustomersAPI().then((value) {
      if (value != null) {
        topCustomerList = value.topCustomerList!;
        update();
      }
    });
  }

  ///API Calls

  Future<TopCustomersResponse?> getTopCustomersAPI() {
    var map = {
      "employeeScreenName": globalController.customerScreenName,
    };
//AP0POW001
    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.topCustomers, requestJson).then((value) {
      try {
        if (value != null) {
          TopCustomersResponse getTopCustomersResponse = TopCustomersResponse.fromJson(value);
          return getTopCustomersResponse;
        } else {
          return null;
        }
      } catch (exception, stackTrace) {
        printErrors("ExceptionHandling at parsing  api request : $exception");
        printErrors("Stacktrace : ");
        printErrors(stackTrace);

        return null;
      }
    }, onError: (e) {
      return null;
    });
  }

  getTopProducts() async{
    await getTopProductsAPI().then((value) {
      if (value != null) {
        topProductList = value.topProductList!;

        update();
      }
    });
  }

  ///API Calls

  Future<TopProductsResponse?> getTopProductsAPI() {
    var map = {
      "employeeScreenName": globalController.customerScreenName,
    };
//AP0POW001
    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.topProducts, requestJson).then((value) {
      try {
        if (value != null) {
          TopProductsResponse getTopProductsResponse = TopProductsResponse.fromJson(value);
          return getTopProductsResponse;
        } else {
          return null;
        }
      } catch (exception, stackTrace) {
        printErrors("ExceptionHandling at parsing  api request : $exception");
        printErrors("Stacktrace : ");
        printErrors(stackTrace);

        return null;
      }
    }, onError: (e) {
      return null;
    });
  }

  getSalesWorthGraph(filterValue) async {
    await getSalesWorthGraphAPI(filterValue).then((value) {
      if (value != null) {
        salesCategoriesList = value.categoriesList!;
        salesOrdersList = value.ordersList!;

        update();
      }
    });
  }

  ///API Calls

  Future<SalesWorthResponse?> getSalesWorthGraphAPI(filter) {
    var map = {"employeeScreenName": globalController.customerScreenName, "filtertype": filter};
//AP0POW001
    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.salesWorthGraph, requestJson).then((value) {
      try {
        if (value != null) {
          SalesWorthResponse getSalesWorthGraphResponse = SalesWorthResponse.fromJson(value);
          return getSalesWorthGraphResponse;
        } else {
          return null;
        }
      } catch (exception, stackTrace) {
        printErrors("ExceptionHandling at parsing  api request : $exception");
        printErrors("Stacktrace : ");
        printErrors(stackTrace);

        return null;
      }
    }, onError: (e) {
      return null;
    });
  }

  getCustomerDemoGraphy() async {
    await getCustomerDemoGraphyApi().then((value) {
      if (value != null) {
        customerCount = value.customerCount!;
        customerNames = value.customerNames!;
        calculateTotalValue(customerCount);
        log(customerNames.toString(), name: 'customerNAME');
        update();
      }
    });
  }

  ///API Calls

  Future<CustomerDemoGraphResponse?> getCustomerDemoGraphyApi() {
    var map = {"employeeScreenName": globalController.customerScreenName};
//AP0POW001
    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.customerDemoGraphy, requestJson).then((value) {
      try {
        if (value != null) {
          CustomerDemoGraphResponse getCustomerDemoGraphyResponse = CustomerDemoGraphResponse.fromJson(value);
          return getCustomerDemoGraphyResponse;
        } else {
          return null;
        }
      } catch (exception, stackTrace) {
        printErrors("ExceptionHandling at parsing  api request : $exception");
        printErrors("Stacktrace : ");
        printErrors(stackTrace);

        return null;
      }
    }, onError: (e) {
      return null;
    });
  }

  isSelectedSalesActivityFilter({required String filter}) {
    selectedSalesActivityFilter = filter;
    update();
  }

  isSelectedSalesWorthFilter({required String filter}) {
    selectedSalesWorthFilter = filter;
    update();
  }

   getSalesTargetAttainment() async{
    await getSalesTargetAttainmentAPI().then((value) {

      var sT = 0.0;
      var sV = 0.0;





      if (value != null) {

        printMe("salesTarget : ${value.salesTarget}");
        printMe("salesValueCompleted : ${value.salesValueCompleted}");


        if(value.salesTarget==null || value.salesTarget=='' || value.salesTarget=='null'){
          sT = 0.0;
        }else{
          sT = double.parse(value.salesTarget!);
        }

        if(value.salesValueCompleted==null || value.salesValueCompleted==''){
          sV = 0.0;
        }else{
          sV = double.parse(value.salesValueCompleted!);
        }
        salesTSIChartData.insert(0,ChartDataTSITarget('Sales Target', sT,const Color(0xffFFB538)));
        salesTSIChartData.insert(1, ChartDataTSITarget('Sales Value', sV,const Color(0xff46DDCC)));
        update();
      }
    });
  }

  Future<SalesTsiResponse?> getSalesTargetAttainmentAPI() {
    var map = {
      "employeeScreenName": globalController.customerScreenName,
    };
    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getTsiSalesTargetEndpoint, requestJson).then((value) {
      try {
        if (value != null) {
          SalesTsiResponse getTopProductsResponse = SalesTsiResponse.fromJson(value);
          return getTopProductsResponse;
        } else {
          return null;
        }
      } catch (exception, stackTrace) {
        printErrors("ExceptionHandling at parsing  api request : $exception");
        printErrors("Stacktrace : ");
        printErrors(stackTrace);

        return null;
      }
    }, onError: (e) {
      return null;
    });
  }

  Future<bool?> getTsiDashboardProductSales(selectedSalesBUFilter) async {
    await getTsiDashboardProductSalesAPI(selectedSalesBUFilter).then((value) {
      if (value != null) {
        categoriesListBuSales = value.categoriesList!;
        filtersListBuSales = value.filtersList!;
        salesDataBuSales = value.salesData!;
        update();
        return true;
      }
    });
    return false;
  }

  Future<BUSalesResponse?> getTsiDashboardProductSalesAPI(selectedSalesBUFilter) {
    var map = {
      "employeeScreenName": globalController.customerScreenName,
      "filterType": selectedSalesBUFilter
    };
    var requestJson = jsonEncode(map);

    return ApiService.postRequest(ApiConstants.getTsiDasbhoardproductSalesEndpoint, requestJson).then((value) {
      try {
        if (value != null) {
          BUSalesResponse getTopProductsResponse = BUSalesResponse.fromJson(value);
          return getTopProductsResponse;
        } else {
          return null;
        }
      } catch (exception, stackTrace) {
        printErrors("ExceptionHandling at parsing  api request : $exception");
        printErrors("Stacktrace : ");
        printErrors(stackTrace);

        return null;
      }
    }, onError: (e) {
      return null;
    });
  }

  isSelectedSalesBuFilter({required String filter}) {
    selectedSalesBUFilter = filter;
    update();
  }


   calculateTotalValue(List<int> numbers) {
     for (int number in numbers) {
       totalValue += number;
     }
   }
}
