class AppConfigs {
  //https://best.lsin.panasonic.com:8443/ secure connection

  ///UAT
  // static String baseUrl = "https://best-uat.lsin.panasonic.com";
  // static String username = 'test';
  // static String password = 'test';

  ///Production mode
  static String baseUrl = "https://best.lsin.panasonic.com";
  static String username = 'best_mobileuse_liferay';
  static String password = 'Panasonic_test@123';

  static String userModule = "/o/panasonic-mobile-user/v1.0/";
  static String attendanceModule = "/o/panasonic-BEST-attendance-api/v1.0/";
  static String bestMasterModule = "/o/best-master-upload-apis/v1.0/";
  static String myBeatModule = "/o/best-mobile-my-beat/v1.0/";
  static String primaryOrderModule = "/o/best-mobile-primary-order/v1.0/";
  static String previousOrderModule = "/o/best-mobile-primary-order/v1.0/primaryOrder/";
  static String previousOrderSelectInfoModule = "/o/best-mobile-primary-order/v1.0/select-info/";
  static String dashboardModule = '/o/best-tsi-mobile-dashboard/v1.0/';
  static String customerProfileModule = '/o/best-mobile-customer-profile/v1.0/Customerprofile/';
  static String getAdminFilterModule = '/o/best-mobile-dashboard/v1.0/';
  static String getAdminSecondaryModule = '/o/best-admin-secondary-order-api/v1.0/';
  static String getAdminPrimaryCustomerModule = '/o/best-mobile-admin-customer-detail-view/v1.0/';
  static String getAdminPrimaryModule = '/o/best-admin-primary-action-mobile/v1.0/';

  ///Secondary Order api module
  static String getRetailerFieldsModule = '/o/best-Secondary-order-api/v1.0/';

  ///My profile module
  static String bestCustomerProfileModule = '/o/best-customer-profile-mobile/v1.0/';
}
