import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import '../../../constants/assetsConst.dart';
import '../../../constants/colorConst.dart';
import 'TabItems.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key, required this.selectedIndex, required this.currentTab, required this.onSelectTab}) : super(key: key);

  final TabItems currentTab;
  final ValueChanged<TabItems> onSelectTab;
  final int selectedIndex;

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int selectedIndex = 0;
  @override
  void initState() {
    setState(() {
      selectedIndex = widget.selectedIndex;
    });
    widget.onSelectTab(
      TabItems.values[selectedIndex],
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 8.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 1,
            width: 100.w,
            color: alizarinCrimson,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    selectedIndex = 0;

                    widget.onSelectTab(
                      TabItems.values[selectedIndex],
                    );
                  });
                },
                child: SizedBox(
                  height: 5.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        homeNavIcon,
                        width: 3.w,
                        height: 3.h,
                        color: selectedIndex == 0 ? alizarinCrimson : codGray,
                      ),
                      // Widgets().verticalSpace(1.h),
                      Text(
                        "Home",
                        style: TextStyle(
                          fontSize: 8.sp,
                          color: selectedIndex == 0 ? alizarinCrimson : codGray,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selectedIndex = 1;
                    widget.onSelectTab(
                      TabItems.values[selectedIndex],
                    );
                  });
                },
                child: SizedBox(
                  height: 5.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        attendanceIcon,
                        width: 3.w,
                        height: 3.h,
                        color: selectedIndex == 1 ? alizarinCrimson : codGray,
                      ),
                      Text(
                        "Attendance",
                        style: TextStyle(
                          fontSize: 8.sp,
                          color: selectedIndex == 1 ? alizarinCrimson : codGray,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selectedIndex = 2;
                    widget.onSelectTab(
                      TabItems.values[selectedIndex],
                    );
                  });
                },
                child: SizedBox(
                  height: 5.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 1.6.h,
                        backgroundColor: selectedIndex == 2 ? alizarinCrimson : silverApprox,
                        child: CircleAvatar(
                          radius: 1.5.h,
                          backgroundColor: white,
                          child: CircleAvatar(
                            radius: 1.4.h,
                            backgroundColor: alizarinCrimson,
                            child: Center(
                                child: Icon(
                              Icons.add,
                              size: 1.6.h,
                              color: white,
                            )),
                          ),
                        ),
                      ),
                      Text(
                        "Primary Order",
                        style: TextStyle(
                          fontSize: 8.sp,
                          color: selectedIndex == 2 ? alizarinCrimson : codGray,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selectedIndex = 3;
                    widget.onSelectTab(
                      TabItems.values[selectedIndex],
                    );
                  });
                },
                child: Container(
                  height: 5.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        cartIcon,
                        width: 2.3.w,
                        height: 2.3.h,
                        color: selectedIndex == 3 ? alizarinCrimson : codGray,
                      ),
                      Text(
                        "Sec. Order",
                        style: TextStyle(
                          fontSize: 8.sp,
                          color: selectedIndex == 3 ? alizarinCrimson : codGray,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selectedIndex = 4;
                    widget.onSelectTab(
                      TabItems.values[selectedIndex],
                    );
                  });
                },
                child: Container(
                  height: 5.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        reportBlackIcon,
                        width: 3.w,
                        height: 3.h,
                        color: selectedIndex == 4 ? alizarinCrimson : codGray,
                      ),
                      Text(
                        "Reports",
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: selectedIndex == 4 ? alizarinCrimson : codGray,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container()
        ],
      ),
    );
  }
}
