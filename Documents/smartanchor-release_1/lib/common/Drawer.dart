import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/common/widgets.dart';
import 'package:smartanchor/constants/assetsConst.dart';
import 'package:smartanchor/constants/colorConst.dart';
import 'package:smartanchor/constants/labelConst.dart';
import 'package:smartanchor/global/common_controllers/GlobalController.dart';
import 'package:smartanchor/views/beat_module/ui/beat_opotion01/BeatOption01.dart';

import '../views/admin_module/home_module/bottomNavigation/LandingPageAdmin.dart';
import '../views/admin_module/primary_order_module/ui/new_order/NewOrder.dart';
import '../views/admin_module/primary_order_module/ui/no_order/NoOrder.dart';
import '../views/admin_module/primary_order_module/ui/return_order/ReturnOrder.dart';
import '../views/admin_module/secondary_order_module/ui/new_order/NewOrder.dart';
import '../views/admin_module/secondary_order_module/ui/no_order/NoOrder.dart';
import '../views/attendance_module/viewAttendance/ui/AttendanceMonth.dart';
import '../views/beat_module/ui/get_in_touch/GetInTouch.dart';
import '../views/beat_module/ui/my_beat/MyBeat.dart';
import '../views/beat_module/ui/nearest_patner/NearestPartner.dart';
import '../views/beat_module/ui/price_and_stock/PriceAndStock.dart';
import '../views/beat_module/ui/target/Target.dart';
import '../views/home_module/BottomNavigation/LandingPage.dart';
import '../views/home_module/home/ui/HomePage.dart';
import '../views/login_module/login/ui/login.dart';
import '../views/login_module/splash_screen/ui/splash_screen.dart';
import '../views/profile_module/ui/MyProfileScreen.dart';
import '../views/tsi_module/other_details_of_customer/ui/PromotionalActivity.dart';
import '../views/tsi_module/primary_order_module/ui/customer_profile/CustomerProfile.dart';
import '../views/tsi_module/primary_order_module/ui/primary_order/PrimaryOrder.dart';
import '../views/tsi_module/secondary_order_module/ui/retailer_profile_module/RetailerProfileScreen.dart';

GlobalController globalController = Get.put(GlobalController());

Widget MainDrawer(BuildContext context) {
  return (globalController.role.toString().toLowerCase() == "TSI".toString().toLowerCase() ||
          globalController.role.toString().toLowerCase() == "LAS".toString().toLowerCase())
      ? const Drawer()
      : const AdminDrawer();
}

class Drawer extends StatefulWidget {
  const Drawer({Key? key}) : super(key: key);

  @override
  DrawerState createState() => DrawerState();
}

class DrawerState extends State<Drawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85.w,
      height: 100.h,
      padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
      color: white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back)),
              SvgPicture.asset(settingIcon)
            ],
          ),
          Widgets().verticalSpace(1.h),
          Theme(
            data: Theme.of(context).copyWith(
              dividerTheme: const DividerThemeData(color: Colors.transparent),
            ),
            child: DrawerHeader(
              padding: const EdgeInsets.only(top: 10),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: 14.h,
                    child: Widgets().drawerItemBox(
                      () {},
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Widgets().verticalSpace(3.h),
                          Text(
                            globalController.userName,
                            style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
                          ),
                          Widgets().verticalSpace(0.5.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Emplyee Code :",
                                style: TextStyle(fontWeight: FontWeight.w300, color: Colors.grey),
                              ),
                              Text(
                                globalController.customerScreenName,
                                style: TextStyle(fontWeight: FontWeight.w300, color: alizarinCrimson),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -1,
                    left: 1,
                    right: 1,
                    child: InkWell(
                      onTap: () {
                        Get.to(() => const MyProfileScreen());
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        minRadius: 41,
                        backgroundImage: AssetImage(
                          profileBackgroundImage,
                          // color: codGray,
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          minRadius: 30,
                          child: CachedNetworkImage(
                            imageUrl: "https://cdn4.iconfinder.com/data/icons/ionicons/512/icon-ios7-contact-512.png",
                            fit: BoxFit.fill,
                            height: 76,
                            width: 76,
                            progressIndicatorBuilder: (context, url, downloadProgress) => const CupertinoActivityIndicator(),
                            errorWidget: (context, url, error) => Icon(
                              CupertinoIcons.person,
                              size: 20,
                              color: codGray,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// vertical space
          Widgets().verticalSpace(1.h),

          /// Home
          Widgets().drawerItemBox(
            () {
              Navigator.pop(context);
              Get.offAll(const LandingPage(selectedItemIndex: 0));
            },
            Widgets().drawerRowWithIconWidget(iconPath: homeIcon, labelText: homeLabel),
          ),

          Widgets().verticalSpace(1.h),

          /// attendance
          Widgets().drawerItemBox(
            () {
              Navigator.pop(context);
              Get.offAll(const LandingPage(
                selectedItemIndex: 1,
              ));
              /*Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) {
                  return const LandingPage(
                    selectedItemIndex: 1,
                  );
                }),
                (route) => false,
              );*/
            },
            Widgets().drawerRowWithIconWidget(iconPath: attendanceIcon, labelText: attendanceLabel),
          ),

          Widgets().verticalSpace(1.h),

          /// primary Action
          Widgets().expansionDrawerItemBox(
            () {},
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ListTileTheme(
                contentPadding: const EdgeInsets.all(0),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.all(0),
                  title: Widgets().drawerRowWithIconWidget(iconPath: primaryIcon, labelText: primaryActionLabel),
                  children: [
                    /// primary order
                    Padding(
                      padding: EdgeInsets.fromLTRB(3.h, 1.h, 2.h, 1.5.h),
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            /*Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return const LandingPage(selectedItemIndex: 2);
                              }),
                              (route) => false,
                            );*/
                            Get.offAll(const LandingPage(selectedItemIndex: 2));
                            /* Navigator.push(context, MaterialPageRoute(builder: (builder) {
                              return const PrimaryOrder(navigationTag: "PrimaryOrder");
                            }));*/
                          },
                          child: Widgets().drawerExpansionRowWithIcon(iconPath: drawerItemIcon, labelText: primaryOrderLabel)),
                    ),

                    /// customer profile
                    Padding(
                      padding: EdgeInsets.fromLTRB(3.h, 1.h, 2.h, 2.h),
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (_) {
                              return const CustomerProfile();
                            }));
                          },
                          child: Widgets().drawerExpansionRowWithIcon(iconPath: drawerItemIcon, labelText: customerProfileLabel)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Widgets().verticalSpace(1.h),

          /// secondary Action
          Widgets().expansionDrawerItemBox(
            () {},
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ListTileTheme(
                contentPadding: const EdgeInsets.all(0),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.all(0),
                  title: Widgets().drawerRowWithIconWidget(iconPath: primaryIcon, labelText: secondaryActionLabel),
                  children: [
                    ///secondary order
                    Padding(
                      padding: EdgeInsets.fromLTRB(3.h, 1.h, 2.h, 1.5.h),
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Get.offAll(const LandingPage(selectedItemIndex: 3));
                          },
                          child: Widgets().drawerExpansionRowWithIcon(iconPath: drawerItemIcon, labelText: secondaryOrderLabel)),
                    ),

                    /// beat
                    Visibility(
                      visible: globalController.role == 'TSI',
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return const BeatOption01();
                          }));
                          // Get.to(MyBeat());
                        },
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(3.h, 1.h, 2.h, 2.h),
                            child: Widgets().drawerExpansionRowWithIcon(
                              iconPath: drawerItemIcon,
                              labelText: beatLabel,
                            )),
                      ),
                    ),

                    /// retailer profile
                    Padding(
                      padding: EdgeInsets.fromLTRB(3.h, 1.h, 2.h, 2.h),
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (_) {
                              return RetailerProfileScreen();
                            }));
                            //  Widgets().showToast("Coming soon");
                          },
                          child: Widgets().drawerExpansionRowWithIcon(
                            iconPath: drawerItemIcon,
                            labelText: retailerProfileLabel,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Widgets().verticalSpace(1.h),

          /// promotional activity

          (globalController.customerScreenName == "abhishek.malla")
              ? const SizedBox()
              : Widgets().drawerItemBox(() {
                  Navigator.pop(context);
                  /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return const PromotionalActivity();
              }),
            );*/
                }, Widgets().drawerRowWithIconWidget(iconPath: promotionIcon, labelText: promotionalActivityLabel)),
          Widgets().verticalSpace(1.h),

          /// my beat
          Visibility(
            child: Widgets().drawerItemBox(() {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return const MyBeat();
              }));
            }, Widgets().drawerRowWithIconWidget(iconPath: nearestIcon, labelText: myBeatLabel)),
          ),
          Widgets().verticalSpace(1.h),

          /// nearest partners
          (globalController.customerScreenName == "abhishek.malla")
              ? const SizedBox()
              : Widgets().drawerItemBox(() {
                  Navigator.pop(context);
                  /*Navigator.push(context, MaterialPageRoute(builder: (_) {
              return const NearestPartner();
            }));*/
                }, Widgets().drawerRowWithIconWidget(iconPath: nearestIcon, labelText: nearestPartnersLabel)),
          Widgets().verticalSpace(1.h),

          /// price and stock
          (globalController.customerScreenName == "abhishek.malla")
              ? const SizedBox()
              : Widgets().drawerItemBox(() {
                  Navigator.pop(context);
                  /*Navigator.push(context, MaterialPageRoute(builder: (_) {
              return const PriceAndStock();
            }));*/
                }, Widgets().drawerRowWithIconWidget(iconPath: priceIcon, labelText: priceStockLabel)),
          Widgets().verticalSpace(1.h),

          /// target
          (globalController.customerScreenName == "abhishek.malla")
              ? const SizedBox()
              : Widgets().drawerItemBox(() {
                  Navigator.pop(context);
                  /*Navigator.push(context, MaterialPageRoute(builder: (_) {
              return const Target();
            }));*/
                }, Widgets().drawerRowWithIconWidget(iconPath: targetIcon, labelText: targetLabel)),
          Widgets().verticalSpace(1.h),

          /// my achievements
          (globalController.customerScreenName == "abhishek.malla")
              ? const SizedBox()
              : Widgets().drawerItemBox(() {
                  Navigator.pop(context);
                }, Widgets().drawerRowWithIconWidget(iconPath: achievementIcon, labelText: myAchievementsLabel)),
          Widgets().verticalSpace(1.h),

          ///sync
          (globalController.customerScreenName == "abhishek.malla")
              ? const SizedBox()
              : Widgets().drawerItemBox(() {
                  Navigator.pop(context);
                }, Widgets().drawerRowWithIconWidget(iconPath: syncIcon, labelText: syncLabel)),
          Widgets().verticalSpace(1.h),

          /// New Product & Competitor FMCD
          (globalController.customerScreenName == "abhishek.malla")
              ? const SizedBox()
              : Widgets().expansionDrawerItemBox(
                  () {},
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ListTileTheme(
                      contentPadding: const EdgeInsets.all(0),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.all(0),
                        title: Widgets().drawerRowWithIconWidget(iconPath: primaryIcon, labelText: productAndCompetitorLabel),
                        children: [
                          /// product Catalogue
                          Padding(
                            padding: EdgeInsets.fromLTRB(3.h, 1.h, 2.h, 1.5.h),
                            child: Widgets().drawerExpansionRowWithIcon(iconPath: drawerItemIcon, labelText: productAndCatalogueLabel),
                          ),

                          /// customer FMCD
                          Padding(
                              padding: EdgeInsets.fromLTRB(3.h, 1.h, 2.h, 2.h),
                              child: Widgets().drawerExpansionRowWithIcon(iconPath: drawerItemIcon, labelText: competitorFMCDLabel)),
                        ],
                      ),
                    ),
                  ),
                ),

          Widgets().verticalSpace(1.h),

          /// advertisement
          (globalController.customerScreenName == "abhishek.malla")
              ? const SizedBox()
              : Widgets().drawerItemBox(() {
                  Navigator.pop(context);
                }, Widgets().drawerRowWithIconWidget(iconPath: announcementIcon, labelText: myAdvertisementLabel)),
          Widgets().verticalSpace(1.h),

          /// announcement
          (globalController.customerScreenName == "abhishek.malla")
              ? const SizedBox()
              : Widgets().drawerItemBox(() {
                  Navigator.pop(context);
                }, Widgets().drawerRowWithIconWidget(iconPath: announcementIcon, labelText: announcementLabel)),
          Widgets().verticalSpace(1.h),

          ///get in touch
          (globalController.customerScreenName == "abhishek.malla")
              ? const SizedBox()
              : Widgets().drawerItemBox(() {
                  Navigator.pop(context);
                  /*Navigator.push(context, MaterialPageRoute(builder: (_) {
              return const GetInTouch();
            }));*/
                }, Widgets().drawerRowWithIconWidget(iconPath: getInTouchIcon, labelText: getInTouchLabel)),
          Widgets().verticalSpace(1.h),

          ///rank
          (globalController.customerScreenName == "abhishek.malla")
              ? const SizedBox()
              : Widgets().drawerItemBox(() {
                  Navigator.pop(context);
                }, Widgets().drawerRowWithIconWidget(iconPath: rankIcon, labelText: rankLabel)),
          Widgets().verticalSpace(1.h),

          /// reports
          (globalController.customerScreenName == "abhishek.malla")
              ? const SizedBox()
              : Widgets().expansionDrawerItemBox(
                  () {
                    Navigator.pop(context);
                  },
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ListTileTheme(
                      contentPadding: const EdgeInsets.all(0),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.all(0),
                        title: Widgets().drawerRowWithIconWidget(iconPath: targetIcon, labelText: reportsLabel),
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(3.h, 1.h, 2.h, 1.5.h),
                            child: Column(
                              children: [
                                /// Customer Service
                                Widgets().drawerExpansionRowWithIcon(iconPath: drawerItemIcon, labelText: customerServiceLabel),
                                Widgets().verticalSpace(1.5.h),

                                /// scheme
                                Widgets().drawerExpansionRowWithIcon(iconPath: drawerItemIcon, labelText: schemeLabel),
                                Widgets().verticalSpace(1.5.h),

                                ///To-Do list
                                Widgets().drawerExpansionRowWithIcon(iconPath: drawerItemIcon, labelText: toDoListLabel),
                                Widgets().verticalSpace(1.5.h),

                                /// Other info
                                Widgets().drawerExpansionRowWithIcon(iconPath: drawerItemIcon, labelText: otherInfoLabel),
                                Widgets().verticalSpace(1.5.h),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

          Widgets().verticalSpace(1.h),

          ///setting
          (globalController.customerScreenName == "abhishek.malla")
              ? const SizedBox()
              : Widgets().drawerItemBox(() {
                  Navigator.pop(context);
                }, Widgets().drawerRowWithIconWidget(iconPath: primaryIcon, labelText: settingLabel)),
          Widgets().verticalSpace(1.h),

          ///logout
          Widgets().drawerItemBox(() {
            globalController.saveLoginState(isLogin: false, customerScreenName: "");
            globalController.clearAllData();
            Get.offAll(const Login());
          }, Widgets().drawerRowWithIconWidget(iconPath: logoutIcon, labelText: logoutLabel)),
          Widgets().verticalSpace(2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$appVersionLabel ${globalController.appVersion}",
                style: TextStyle(color: boulder),
              ),
            ],
          ),
          Widgets().verticalSpace(10.h),
        ],
      ),
    );
  }
}

class AdminDrawer extends StatefulWidget {
  const AdminDrawer({Key? key}) : super(key: key);

  @override
  State<AdminDrawer> createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85.w,
      height: 100.h,
      padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
      color: white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back)),
              SvgPicture.asset(settingIcon)
            ],
          ),
          Widgets().verticalSpace(1.h),
          Theme(
            data: Theme.of(context).copyWith(
              dividerTheme: const DividerThemeData(color: Colors.transparent),
            ),
            child: DrawerHeader(
              padding: const EdgeInsets.only(top: 10),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: 14.h,
                    child: Widgets().drawerItemBox(
                      () {},
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Widgets().verticalSpace(3.h),
                          Text(
                            globalController.userName,
                            style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
                          ),
                          Widgets().verticalSpace(0.5.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Employee Code :",
                                style: TextStyle(fontWeight: FontWeight.w300, color: Colors.grey),
                              ),
                              Text(
                                globalController.customerScreenName,
                                style: TextStyle(fontWeight: FontWeight.w300, color: alizarinCrimson),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -1,
                    left: 1,
                    right: 1,
                    child: InkWell(
                      onTap: () {
                        Get.to(() => const MyProfileScreen());
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        minRadius: 41,
                        backgroundImage: AssetImage(
                          profileBackgroundImage,
                          // color: codGray,
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          minRadius: 30,
                          child: CachedNetworkImage(
                            imageUrl: "https://cdn4.iconfinder.com/data/icons/ionicons/512/icon-ios7-contact-512.png",
                            fit: BoxFit.fill,
                            height: 76,
                            width: 76,
                            progressIndicatorBuilder: (context, url, downloadProgress) => const CupertinoActivityIndicator(),
                            errorWidget: (context, url, error) => Icon(
                              CupertinoIcons.person,
                              size: 20,
                              color: codGray,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// vertical space
          Widgets().verticalSpace(1.h),

          /// Home
          Widgets().drawerItemBox(
            () {
              Navigator.pop(context);
              Get.offAll(const LandingPageAdmin(selectedItemIndex: 0));
            },
            Widgets().drawerRowWithIconWidget(iconPath: homeIcon, labelText: homeLabel),
          ),

          Widgets().verticalSpace(1.h),

          /// Attendance
          Widgets().expansionDrawerItemBox(
            () {},
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ListTileTheme(
                contentPadding: const EdgeInsets.all(0),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.all(0),
                  title: Widgets().drawerRowWithIconWidget(iconPath: primaryIcon, labelText: "Attendance"),
                  children: [
                    /// View Attendance
                    Padding(
                      padding: EdgeInsets.fromLTRB(3.h, 1.h, 2.h, 1.5.h),
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Get.offAll(const LandingPageAdmin(selectedItemIndex: 1));
                          },
                          child: Widgets().drawerExpansionRowWithIcon(iconPath: drawerItemIcon, labelText: "View Attendance")),
                    ),

                    /// Mark My Attendance
                    (globalController.role.toString().toLowerCase() == "asm")
                        ? Padding(
                            padding: EdgeInsets.fromLTRB(3.h, 1.h, 2.h, 2.h),
                            child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);

                                  Navigator.pop(context);
                                  Get.offAll(const AttendanceMonth());
                                },
                                child: Widgets().drawerExpansionRowWithIcon(iconPath: drawerItemIcon, labelText: "Mark My Attendance")),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
          Widgets().verticalSpace(1.h),

          /// Customer Primary Order
          Widgets().expansionDrawerItemBox(
            () {},
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ListTileTheme(
                contentPadding: const EdgeInsets.all(0),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.all(0),
                  title: Widgets().drawerRowWithIconWidget(iconPath: primaryIcon, labelText: 'Customer - Primary Order'),
                  children: [
                    ///Primary order
                    Padding(
                      padding: EdgeInsets.fromLTRB(3.h, 1.h, 2.h, 1.5.h),
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Get.offAll(const LandingPageAdmin(selectedItemIndex: 2));
                          },
                          child: Widgets().drawerExpansionRowWithIcon(iconPath: drawerItemIcon, labelText: 'Customer Profile')),
                    ),

                    /// New Order
                    Padding(
                      padding: EdgeInsets.fromLTRB(3.h, 1.h, 2.h, 1.5.h),
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (_) {
                              return const AdminNewOrder();
                            }));
                          },
                          child: Widgets().drawerExpansionRowWithIcon(iconPath: drawerItemIcon, labelText: 'New Order')),
                    ),

                    ///NO order
                    Padding(
                      padding: EdgeInsets.fromLTRB(3.h, 1.h, 2.h, 1.5.h),
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (_) {
                              return const AdminNoOrder();
                            }));
                          },
                          child: Widgets().drawerExpansionRowWithIcon(iconPath: drawerItemIcon, labelText: 'No Order')),
                    ),

                    ///Return order
                    Padding(
                      padding: EdgeInsets.fromLTRB(3.h, 1.h, 2.h, 1.5.h),
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (_) {
                              return const AdminReturnOrder();
                            }));
                          },
                          child: Widgets().drawerExpansionRowWithIcon(iconPath: drawerItemIcon, labelText: 'Return Order')),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Widgets().verticalSpace(1.h),

          /// Customer Primary Order
          Widgets().expansionDrawerItemBox(
            () {},
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ListTileTheme(
                contentPadding: const EdgeInsets.all(0),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.all(0),
                  title: Widgets().drawerRowWithIconWidget(iconPath: primaryIcon, labelText: 'Retailers - Secondary Order'),
                  children: [
                    ///Retailers profile
                    Padding(
                      padding: EdgeInsets.fromLTRB(3.h, 1.h, 2.h, 1.5.h),
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Get.offAll(const LandingPageAdmin(selectedItemIndex: 3));
                          },
                          child: Widgets().drawerExpansionRowWithIcon(iconPath: drawerItemIcon, labelText: 'Retailers Profile')),
                    ),

                    /// New Order
                    Padding(
                      padding: EdgeInsets.fromLTRB(3.h, 1.h, 2.h, 1.5.h),
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (_) {
                              return const AdminSecondaryNewOrder();
                            }));
                          },
                          child: Widgets().drawerExpansionRowWithIcon(iconPath: drawerItemIcon, labelText: 'New Order')),
                    ),

                    ///NO order
                    Padding(
                      padding: EdgeInsets.fromLTRB(3.h, 1.h, 2.h, 1.5.h),
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (_) {
                              return const AdminSecondaryNoOrder();
                            }));
                          },
                          child: Widgets().drawerExpansionRowWithIcon(iconPath: drawerItemIcon, labelText: 'No Order')),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Widgets().verticalSpace(1.h),

          /// Beat
          Widgets().drawerItemBox(() {
            Navigator.pop(context);
            if (globalController.role.toString().toLowerCase() == "asm") {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return const BeatOption01();
              }));
            }
          }, Widgets().drawerRowWithIconWidget(iconPath: promotionIcon, labelText: "Beat")),
          Widgets().verticalSpace(1.h),

          /// Product Catalouge
          (globalController.customerScreenName == "abhishek.malla")
              ? const SizedBox()
              : Widgets().drawerItemBox(() {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return const NearestPartner();
                  }));
                }, Widgets().drawerRowWithIconWidget(iconPath: nearestIcon, labelText: "Product Catalogue")),
          Widgets().verticalSpace(1.h),

          /// Schemes
          (globalController.customerScreenName == "abhishek.malla")
              ? const SizedBox()
              : Widgets().drawerItemBox(() {
                  Navigator.pop(context);
                }, Widgets().drawerRowWithIconWidget(iconPath: priceIcon, labelText: "Scheme")),
          Widgets().verticalSpace(1.h),

          /// Ranking
          (globalController.customerScreenName == "abhishek.malla")
              ? const SizedBox()
              : Widgets().drawerItemBox(() {
                  Navigator.pop(context);
                }, Widgets().drawerRowWithIconWidget(iconPath: targetIcon, labelText: "Ranking Details")),
          Widgets().verticalSpace(1.h),

          /// Analytics
          (globalController.customerScreenName == "abhishek.malla")
              ? const SizedBox()
              : Widgets().drawerItemBox(() {}, Widgets().drawerRowWithIconWidget(iconPath: achievementIcon, labelText: "Analytics")),
          Widgets().verticalSpace(1.h),

          /// New Product & Competitor FMCD
          (globalController.customerScreenName == "abhishek.malla")
              ? const SizedBox()
              : Widgets().expansionDrawerItemBox(
                  () {},
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ListTileTheme(
                      contentPadding: const EdgeInsets.all(0),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.all(0),
                        title: Widgets().drawerRowWithIconWidget(iconPath: primaryIcon, labelText: productAndCompetitorLabel),
                        children: [
                          /// product Catalogue
                          Padding(
                            padding: EdgeInsets.fromLTRB(3.h, 1.h, 2.h, 1.5.h),
                            child: Widgets().drawerExpansionRowWithIcon(iconPath: drawerItemIcon, labelText: productAndCatalogueLabel),
                          ),

                          /// customer FMCD
                          Padding(
                              padding: EdgeInsets.fromLTRB(3.h, 1.h, 2.h, 2.h),
                              child: Widgets().drawerExpansionRowWithIcon(iconPath: drawerItemIcon, labelText: competitorFMCDLabel)),
                        ],
                      ),
                    ),
                  ),
                ),

          Widgets().verticalSpace(1.h),

          /// Customer Services
          (globalController.customerScreenName == "abhishek.malla")
              ? const SizedBox()
              : Widgets().drawerItemBox(() {}, Widgets().drawerRowWithIconWidget(iconPath: announcementIcon, labelText: 'Customer Services')),

          Widgets().verticalSpace(1.h),

          /// Task/Target
          (globalController.customerScreenName == "abhishek.malla")
              ? const SizedBox()
              : Widgets().drawerItemBox(() {}, Widgets().drawerRowWithIconWidget(iconPath: announcementIcon, labelText: 'Task / Target')),

          Widgets().verticalSpace(1.h),

          /// advertisement
          (globalController.customerScreenName == "abhishek.malla")
              ? const SizedBox()
              : Widgets().drawerItemBox(() {}, Widgets().drawerRowWithIconWidget(iconPath: announcementIcon, labelText: myAdvertisementLabel)),
          Widgets().verticalSpace(1.h),

          /// announcement
          (globalController.customerScreenName == "abhishek.malla")
              ? const SizedBox()
              : Widgets().drawerItemBox(() {}, Widgets().drawerRowWithIconWidget(iconPath: announcementIcon, labelText: announcementLabel)),
          Widgets().verticalSpace(1.h),

          /// reports
          (globalController.customerScreenName == "abhishek.malla")
              ? const SizedBox()
              : Widgets().expansionDrawerItemBox(
                  () {},
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ListTileTheme(
                      contentPadding: const EdgeInsets.all(0),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.all(0),
                        title: Widgets().drawerRowWithIconWidget(iconPath: targetIcon, labelText: reportsLabel),
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(3.h, 1.h, 2.h, 1.5.h),
                            child: Column(
                              children: [
                                /// Customer Service
                                Widgets().drawerExpansionRowWithIcon(iconPath: drawerItemIcon, labelText: customerServiceLabel),
                                Widgets().verticalSpace(1.5.h),

                                /// scheme
                                Widgets().drawerExpansionRowWithIcon(iconPath: drawerItemIcon, labelText: schemeLabel),
                                Widgets().verticalSpace(1.5.h),

                                ///To-Do list
                                Widgets().drawerExpansionRowWithIcon(iconPath: drawerItemIcon, labelText: toDoListLabel),
                                Widgets().verticalSpace(1.5.h),

                                /// Other info
                                Widgets().drawerExpansionRowWithIcon(iconPath: drawerItemIcon, labelText: otherInfoLabel),
                                Widgets().verticalSpace(1.5.h),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

          Widgets().verticalSpace(1.h),

          ///logout
          Widgets().drawerItemBox(() {
            globalController.saveLoginState(isLogin: false, customerScreenName: "");
            globalController.clearAllData();
            Get.offAll(() => const Login());
          }, Widgets().drawerRowWithIconWidget(iconPath: logoutIcon, labelText: logoutLabel)),
          Widgets().verticalSpace(2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$appVersionLabel ${globalController.appVersion}",
                style: TextStyle(color: boulder),
              ),
            ],
          ),
          Widgets().verticalSpace(10.h),
        ],
      ),
    );
  }
}
