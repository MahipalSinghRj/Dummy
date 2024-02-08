import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/common/Drawer.dart';
import 'package:smartanchor/common/widgets.dart';

import '../constants/assetsConst.dart';
import '../constants/colorConst.dart';

//ignore: must_be_immutable
class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;
  final GlobalKey<ScaffoldState> _scaffoldKey;
  final bool isShowBackButton;
  const MainAppBar(this.context, this._scaffoldKey, {this.isShowBackButton = true, Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return Container(
      color: Colors.red,
      height: 9.h,
      child: SafeArea(
        child: Container(
          color: alizarinCrimson,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (GetPlatform.isIOS && (isShowBackButton) && navigator!.canPop())
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        CupertinoIcons.back,
                        color: white,
                      )),
                InkWell(
                  onTap: (() {}),
                  child: Row(
                    children: [
                      Container(
                        decoration: Widgets().commonDecoration(borderRadius: 1.h, bgColor: white),
                        child: Padding(
                          padding: EdgeInsets.all(.8.h),
                          child: Image.asset(
                            //anchorLogoWhite,
                            newAppBarLogo,
                            //height: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    // InkWell(
                    //   onTap: () {},
                    //   child: Stack(
                    //     children: [
                    //       CircleAvatar(
                    //         radius: 17,
                    //         backgroundColor: Colors.transparent,
                    //         child: SvgPicture.asset(notificationIcon,
                    //             height: 3.5.h),
                    //       ),
                    //       Positioned(
                    //         top: 0,
                    //         right: 0,
                    //         child: Container(
                    //             padding: EdgeInsets.all(.35.h),
                    //             decoration: ShapeDecoration(
                    //                 shape: const CircleBorder(),
                    //                 color: malachite),
                    //             child: Text(
                    //               "0",
                    //               style:
                    //                   TextStyle(fontSize: 6.sp, color: white),
                    //             )),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    CircleAvatar(
                      radius: 17,
                      child: Badge(
                        label: const Text("3"),
                        child: SvgPicture.asset(notificationIcon, height: 3.5.h),
                      ),
                    ),
                    Widgets().horizontalSpace(2.w),

                    GestureDetector(
                      onLongPress: () {
                        Widgets().showToast("User Role Type : ${globalController.role}");
                      },
                      onTap: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 6.h,
                            width: 10.w,
                            child: ClipOval(
                              child: Image.network(
                                "https://media.istockphoto.com/id/1394781347/photo/hand-holdig-plant-growing-on-green-background-with-sunshine.jpg?s=1024x1024&w=is&k=20&c=KJIpH7RN4AousDF7cdcNkMFV4JBLKe7Ild_9tWCXFys=",
                                fit: BoxFit.cover, // Adjusted to cover the oval container
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -0.5,
                            right: 1,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: ShapeDecoration(shape: const OvalBorder(), color: white),
                              child: const Icon(Icons.dehaze_rounded, size: 7),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Widgets().horizontalSpace(2),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
