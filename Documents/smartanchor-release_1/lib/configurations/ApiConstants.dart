import 'AppConfigs.dart';

class ApiConstants {
  /// user module apis
  static String getCustomerName = "${AppConfigs.userModule}get-SFA-customer-fullname";
  static String getAuthenticationCustomerWithPassword = "${AppConfigs.userModule}authenticate-customer-with-password";
  static String sendOTP = "${AppConfigs.userModule}send-otp-sfa";
  static String authenticateCustomerWithOTP = "${AppConfigs.userModule}authenticate-customer-with-otp-sfa";
  static String passwordResetFirstTime = "${AppConfigs.userModule}password-reset-first-time";
  static String passwordReset = "${AppConfigs.userModule}password-reset";
  static String passwordResetForgotPassword = "${AppConfigs.userModule}password-reset-forgot-password";

  ///attendanceModule apis
  static String clockInOutApi = "${AppConfigs.attendanceModule}Add-Login-Logout-Details";
  static String dailyAttendanceApi = "${AppConfigs.attendanceModule}Daily-Attendance-Details";
  static String monthlyAttendanceApi = "${AppConfigs.attendanceModule}Attendance-Details";
  static String downloadReports = "${AppConfigs.attendanceModule}Download-Reports";
  static String deleteReports = "${AppConfigs.attendanceModule}Delete_Report";
  static String userAllDetail = "${AppConfigs.attendanceModule}User-All-Detail";
  static String userLeaveApplication = "${AppConfigs.attendanceModule}Leave-Application";

  /// beat master apis
  static String getBeatsUploadData = "${AppConfigs.bestMasterModule}get-beats-upload-data";
  static String bulkBeatUploads = "${AppConfigs.bestMasterModule}bulk-beat-upload";
  static String getBeatTemplate = "${AppConfigs.bestMasterModule}get-beat-template"; //get request
  static String addBeatIndividualUpload = "${AppConfigs.bestMasterModule}add-beat-individual-upload";
  static String editBeatIndividualUpload = "${AppConfigs.bestMasterModule}edit-beat-individual-upload";

  /// beat allocation apis
  static String getBeatsAllocationUploadData = "${AppConfigs.bestMasterModule}get-beats-Allocation-upload-data";
  static String bulkBeatAllocationUpload = "${AppConfigs.bestMasterModule}bulk-beat-Allocation-upload";
  static String getBeatAllocationTemplate = "${AppConfigs.bestMasterModule}get-beat-Allocation-template"; //get request
  static String addBeatAllocationUpload = "${AppConfigs.bestMasterModule}Add-beat-Allocation-upload";
  static String editBeatAllocationUpload = "${AppConfigs.bestMasterModule}Edit-beat-Allocation-upload";

  /// My beat   apis by swaroop
  static String getEventsAllocation = "${AppConfigs.myBeatModule}get-events-allocation";
  static String addEventsForApproval = "${AppConfigs.myBeatModule}add-events-for-approval";
  static String getActionEventApprovalData = "${AppConfigs.myBeatModule}get-action-event-approval-data";
  static String getUserListData = "${AppConfigs.myBeatModule}get-user-List-data";
  static String getBulkExcelTemplate = "${AppConfigs.myBeatModule}get-bulk-excel-template"; //bulk allocation download
  static String getBulkExcelAuidt = "${AppConfigs.myBeatModule}get-bulk-excel-auidt"; //listview
  static String bulkUploadExcel = "${AppConfigs.myBeatModule}bulk-upload-excel"; //bulk allocation upload
  static String getCustomerMapping = "${AppConfigs.myBeatModule}get-customer-mapping";
  static String getCustomerAddress = "${AppConfigs.myBeatModule}get-customer-address";

  /// Primary Order apis
  static String getStatesForCustomers = "${AppConfigs.primaryOrderModule}get-states-for-customers";
  static String getCustomersByState = "${AppConfigs.primaryOrderModule}get-customers-by-state";
  static String getCustomerInfo = "${AppConfigs.primaryOrderModule}get-customer-info";
  static String getCustomersByBeats = "${AppConfigs.primaryOrderModule}get-customers-by-beats";
  static String dropdownFilter = "${AppConfigs.primaryOrderModule}DropdownFilter";
  static String getBeats = "${AppConfigs.primaryOrderModule}get-beats";
  static String customerUnderTsi = "${AppConfigs.customerProfileModule}CustomerUnderTsi";

  ///New order apis
  static String submitNewOrder = "${AppConfigs.primaryOrderModule}submit-new-order";
  static String newOrderFilter = "${AppConfigs.primaryOrderModule}NewOrderFilter";
  static String productByBU = "${AppConfigs.primaryOrderModule}ProductByBU";
  static String discountnTaxOrderValue = "${AppConfigs.primaryOrderModule}DiscountnTaxOrderValue";
  static String getWarehouseForCustomer = "${AppConfigs.primaryOrderModule}get-warehouse-for-customer";
  static String focusedProduct = "${AppConfigs.primaryOrderModule}FocusedProduct";
  static String ProductSearch = "${AppConfigs.primaryOrderModule}ProductSearch";

  ///Return order apis
  static String returnOrderbyid = "${AppConfigs.primaryOrderModule}returnOrderbyid";
  static String returnOrdersWithCategory = "${AppConfigs.primaryOrderModule}returnOrdersWithCategory";
  static String returnOrdersWithSubBrand = "${AppConfigs.primaryOrderModule}returnOrdersWithSubBrand";
  static String returnOrdersWithDropDown = "${AppConfigs.primaryOrderModule}returnOrdersWithDropdown";
  static String submitReturnOrder = "${AppConfigs.primaryOrderModule}submit-return-order";

  ///No order apis
  static String submitNoOrder = "${AppConfigs.primaryOrderModule}submit-no-order";
  static String getReasons = "${AppConfigs.primaryOrderModule}get-reasons";

  ///Previous order apis
  static String previousOrdersByFilter = "${AppConfigs.previousOrderModule}previousOrdersByFilter";
  static String getProductCategory = "${AppConfigs.previousOrderSelectInfoModule}get-product-category";

  ///Order details api
  static String OrderDetailsbyId = "${AppConfigs.previousOrderModule}OrderDetailsbyId";

  ///Dasboard api
  static String dashBoardBanner = "${AppConfigs.dashboardModule}get-dashboard-banner-data";
  static String salesActivity = "${AppConfigs.dashboardModule}get-tsi-sales-activity-today";
  static String salesActivityMonthly = "${AppConfigs.dashboardModule}get-tsi-monthly-orders";
  static String salesActivityGraph = "${AppConfigs.dashboardModule}get-tsi-sales-Activity-graph";
  static String topCustomers = "${AppConfigs.dashboardModule}get-tsi-top-customers";
  static String topProducts = "${AppConfigs.dashboardModule}get-tsi-top-products";
  static String getTsiSalesTargetEndpoint = "${AppConfigs.dashboardModule}get-tsi-sales-target";
  static String getTsiDasbhoardproductSalesEndpoint = "${AppConfigs.dashboardModule}get-tsi-dasbhoard-product-sales";
  static String salesWorthGraph = "${AppConfigs.dashboardModule}get-tsi-sales-worth-graph";
  static String customerDemoGraphy = "${AppConfigs.dashboardModule}get-tsi-customer-demography";

  ///Payment term api on checkout
  static String paymentTermList = "${AppConfigs.primaryOrderModule}PaymentTermList";
  static String orderTypeList = "${AppConfigs.primaryOrderModule}OrderTypeList";

  /// Admin Filter APIs
  static String getBuListEndpoint = "${AppConfigs.getAdminFilterModule}get-admin-dashboard-filters";
  static String getAdminActivityTrackerEndpoint = "${AppConfigs.getAdminFilterModule}get-admin-dashboard-activity-tracker";
  static String getAdminDashboardBeatsEndpoint = "${AppConfigs.getAdminFilterModule}get-admin-dashboard-beats";
  static String getAdminDashboardPrimarySecondaryEndpoint = "${AppConfigs.getAdminFilterModule}get-admin-dashboard-primary-secondary";
  static String getAdminDashboardBusinessAchivementEndpoint = "${AppConfigs.getAdminFilterModule}get-admin-dashboard-business-achivement";
  static String getAdminDashboardRetailersEndpoint = "${AppConfigs.getAdminFilterModule}get-admin-dashboard-retailers";
  static String getAdminDashboardTopCustomersEndpoint = "${AppConfigs.getAdminFilterModule}get-admin-dashboard-topCustomers";
  static String getAdminAttendenceGraphEndpoint = "${AppConfigs.getAdminFilterModule}get-admin-attendence-graph";
  static String getAdminProductPerformanceEndpoint = "${AppConfigs.getAdminFilterModule}get-admin-product-performance";
  static String getAdminAttendanceEndpoint = "${AppConfigs.attendanceModule}View-Attendance";
  static String getAdminFilteredAttendanceEndpoint = "${AppConfigs.attendanceModule}View-filteredAttendance";
  static String getAdminTrackEmployeeEndpoint = "${AppConfigs.attendanceModule}AdminTrack-Details";
  static String getAdminRetailerProfile = "${AppConfigs.getAdminSecondaryModule}retailerProfile";
  static String getAdminRetailerProfileDetail = "${AppConfigs.getAdminSecondaryModule}retailerProfileDetails";
  static String getAdminRetailerNewOrders = "${AppConfigs.getAdminSecondaryModule}getNewOrders";
  static String getAdminRetailerNewOrderDetail = "${AppConfigs.getAdminSecondaryModule}orderDetails";
  static String getAdminRetailerNoOrders = "${AppConfigs.getAdminSecondaryModule}noOrders";
  static String getAdminRetailerNoOrderDetail = "${AppConfigs.getAdminSecondaryModule}noOrderDetails";

  ///Secondary order module apis
  static String retailerFields = "${AppConfigs.getRetailerFieldsModule}Retailer-Fields";
  static String retailersByBeat = "${AppConfigs.getRetailerFieldsModule}Retailers-ByBeat";
  static String retailerDetails = "${AppConfigs.getRetailerFieldsModule}Retailer-Details";
  static String distributeEndpoint = "${AppConfigs.getRetailerFieldsModule}reasons-dealer-list";

  ///Retailer new order apis
  static String productDetailList = "${AppConfigs.getRetailerFieldsModule}product-detail-list";

  ///Retailer no order apis
  static String noOrder = "${AppConfigs.getRetailerFieldsModule}no-order";

  ///Retailer checkout api
  static String saveOrder = "${AppConfigs.getRetailerFieldsModule}save-order";

  ///Retailer Previous order grid api
  static String previousOrderDetails = "${AppConfigs.getRetailerFieldsModule}PreviousOrder-Details";

  ///Retailer Previous order details api
  static String viewPreviousOrder = "${AppConfigs.getRetailerFieldsModule}View-PreviousOrder";
  static String focusProductDetails = "${AppConfigs.getRetailerFieldsModule}focused-product";

  ///retailer previous order again new order api
  static String productsBySku = "${AppConfigs.getRetailerFieldsModule}products-by-sku";

  //CustomerProfileAPI

  static String getCustomerProfileList = "${AppConfigs.customerProfileModule}CustomerDetailsbyCode";
  static String getCustomerProfileDetails = "${AppConfigs.customerProfileModule}GetCustomerDetails";
  static String getAllInvoicesForCustomer = "${AppConfigs.customerProfileModule}GetCustomerDetails-table";
  static String getAllCustomerMarkersDetails = "${AppConfigs.customerProfileModule}CustomerDetailsbyCode-map";

  ////Best Customer Profile API
  static String getProfileDetails(String userId) => "${AppConfigs.bestCustomerProfileModule}get-customer-profile?userId=${userId}";
  static String sendProfileOtp = "${AppConfigs.bestCustomerProfileModule}send-otp";
  static String updateMobileEmail = "${AppConfigs.bestCustomerProfileModule}update-data";
  static String updatePassword = "${AppConfigs.bestCustomerProfileModule}update-password";
  static String updateUserData(String userId) => "${AppConfigs.bestCustomerProfileModule}update-user-data/${userId}";

  /// Admin Primary Order Module
  static String getAdminCustomerProfile = "${AppConfigs.getAdminPrimaryCustomerModule}Customerprofile/CustomerDetailsbyScreenName";
  static String getAdminCustomerDetailProfile = "${AppConfigs.getAdminPrimaryCustomerModule}EachCustomer-Detail";
  static String getAdminCustomerNewOrders = "${AppConfigs.getAdminPrimaryModule}get-new-orders";
  static String getAdminCustomerNewOrderDetail = "${AppConfigs.getAdminPrimaryModule}get-single-new-order?orderId=";
  static String getAdminCustomerNoOrders = "${AppConfigs.getAdminPrimaryCustomerModule}no-order-list";
  static String getAdminCustomerNoOrderDetail = "${AppConfigs.getAdminPrimaryCustomerModule}noOrderDetails";
  static String getAdminCustomerReturnOrders = "${AppConfigs.getAdminPrimaryCustomerModule}return-order-list";
  static String getAdminCustomerReturnOrderDetail = "${AppConfigs.getAdminPrimaryCustomerModule}return-order-detalis?orderId=";
  static String getAdminCustomeroutStandingAmount = "${AppConfigs.getAdminPrimaryCustomerModule}outstanding-amount";
  static String getAdminCustomerAllInvoiceList = "${AppConfigs.getAdminPrimaryCustomerModule}AllInvoice-Detail";
  static String getAdminCustomerFilters = "${AppConfigs.getAdminPrimaryCustomerModule}get-customer-filters";

// Secondary Order Retailer Profile URls

  static String getSingleRetailerProfileDetails(String retailerCode) => "${AppConfigs.getRetailerFieldsModule}get-single-Retailer?retailerCode=$retailerCode";

  static String getRetailerList(String screenName, int pageSize, int pageNo) =>
      "${AppConfigs.getRetailerFieldsModule}get-Retailer-List?screenName=$screenName&pageSize=$pageSize&pageNo=$pageNo";

  static String genrateOtpToVerifyRetailer = "${AppConfigs.getRetailerFieldsModule}generate-verify-otp";
  static String getDropDownValuesForRetailer = "${AppConfigs.getRetailerFieldsModule}dropdown-values";
  static String getCitiesFromDistrict = "${AppConfigs.getRetailerFieldsModule}cityFromDistrict";
  static String addRetailer = "${AppConfigs.getRetailerFieldsModule}add-retailer-data";

  ///Primary order, Secondary order, Product catalog filter api
  static String productFilter = "${AppConfigs.getRetailerFieldsModule}product-filter";
}
