/*
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/constants/colorConst.dart';
import '../constants/assetsConst.dart';

List<Country> countryOptions = <Country>[
  Country(name: 'Jalaram Electronic Shop / 252154', size: 30370000, color: lochmara),
  Country(name: 'Electronic Shop / 252154', size: 44579000, color: magicMint),
  Country(name: 'Electronic Shop / 252154', size: 8600000, color: silverApprox),
  Country(name: 'Jalaram Electronic Shop / 252154', size: 110879, color: cornflowerBlue),
  Country(name: 'Electronic Shop / 252154', size: 9984670, color: californiaColor),
  Country(name: 'Jalaram Electronic Shop / 252154', size: 42916, color: waterlooColor),
  Country(name: 'Electronic Shop / 252154', size: 10180000, color: caribbeanGreenColor),
  Country(name: 'Jalaram Electronic Shop / 252154', size: 3287263, color: secondLightBlue1),
  Country(name: 'Electronic Shop / 252154', size: 3287263, color: secondLightBlue),
];

class AutoCompleteDemo extends StatefulWidget {

  const AutoCompleteDemo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AutoCompleteDemoState();
}

class _AutoCompleteDemoState extends State<AutoCompleteDemo> {
  FocusNode? autoTextFieldFocusNode;
  int i = 0;

  @override
  void initState() {
    autoTextFieldFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    //autoTextFieldFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6.5.h,
      decoration: ShapeDecoration(
        color: white,
        shape: RoundedRectangleBorder(
            borderRadius: i != 0 ? BorderRadius.only(topRight: Radius.circular(1.5.h), topLeft: Radius.circular(1.5.h)) : BorderRadius.circular(1.5.h)),
        shadows: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 3),
            spreadRadius: 5,
          )
        ],
      ),
      child: Autocomplete<Country>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          return countryOptions.where((Country county) => county.name.toLowerCase().startsWith(textEditingValue.text.toLowerCase())).toList();
        },
        displayStringForOption: (Country option) => option.name,
        fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
          autoTextFieldFocusNode = fieldFocusNode;

          return TextField(
            controllers: fieldTextEditingController,
            focusNode: autoTextFieldFocusNode,
            //readOnly: i == 0 ? true : false,
            style: const TextStyle(fontWeight: FontWeight.w400),
            decoration: InputDecoration(
              hintText: 'Type here',
              hintStyle: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(1.5.h),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(1.5.h),
              ),
              filled: true,
              fillColor: white,
              suffixIcon: Image.asset(search),
            ),
            onTap: () {
              setState(() {
                i = 1;
              });
            },
          );
        },
        onSelected: (Country selection) {
          if (kDebugMode) {
            print('Selected: ${selection.name}');
          }
        },
        optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<Country> onSelected, Iterable<Country> options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              child: Container(
                width: 94.w,
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                  itemCount: countryOptions.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          i = 0;
                        });
                        autoTextFieldFocusNode!.unfocus();
                        onSelected(options.elementAt(index));
                      },
                      child: Container(
                        height: 5.h,
                        width: 100.w,
                        color: countryOptions[index].color,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(countryOptions[index].name, style: TextStyle(color: white)),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Country {
  const Country({
    required this.name,
    required this.size,
    required this.color,
  });

  final String name;
  final int size;
  final Color color;

  @override
  String toString() {
    return '$name ($size)';
  }
}
*/

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/constants/colorConst.dart';
import 'package:smartanchor/debug/printme.dart';
import 'package:smartanchor/views/beat_module/controllers/MyBeatController.dart';
import '../constants/assetsConst.dart';

//ignore: must_be_immutable
class AutoCompleteDemo extends StatefulWidget {
  const AutoCompleteDemo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AutoCompleteDemoState();
}

class _AutoCompleteDemoState extends State<AutoCompleteDemo> {
  FocusNode? autoTextFieldFocusNode;
  int i = 0;

  MyBeatController myBeatController = Get.put(MyBeatController());
  TextEditingController searchTextController = TextEditingController();
  @override
  void initState() {
    autoTextFieldFocusNode = FocusNode();
    super.initState();
  }

  void handleTextChange(String text) {
    printMe("Search Text is : $text");
    myBeatController.getUserListData(searchTextController.text.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6.5.h,
      decoration: ShapeDecoration(
        color: white,
        shape: RoundedRectangleBorder(
            borderRadius: i != 0 ? BorderRadius.only(topRight: Radius.circular(1.5.h), topLeft: Radius.circular(1.5.h)) : BorderRadius.circular(1.5.h)),
        shadows: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 3),
            spreadRadius: 5,
          )
        ],
      ),
      child: Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            return myBeatController.userList.where((user) => user.toLowerCase().startsWith(textEditingValue.text.toLowerCase())).toList();
          },
          displayStringForOption: (String input) => input.toString(),
          fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
            autoTextFieldFocusNode = fieldFocusNode;
            searchTextController = fieldTextEditingController;
            return TextField(
              controller: searchTextController,
              focusNode: autoTextFieldFocusNode,
              //readOnly: i == 0 ? true : false,
              style: const TextStyle(fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                hintText: 'Type here',
                hintStyle: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(1.5.h),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(1.5.h),
                ),
                filled: true,
                fillColor: white,
                suffixIcon: Image.asset(search),
              ),
              onTap: () {
                setState(() {
                  i = 1;
                });
              },
              onChanged: handleTextChange,
            );
          },
          // onSelected
          onSelected: (String selection) {
            if (kDebugMode) {
              print('Selected: $selection');
            }
          },
          optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
            return Material(
              elevation: 4.0,
              child: ListView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final option = options.elementAt(index);
                    return GestureDetector(
                      onTap: () {
                        onSelected(option);
                      },
                      child: ListTile(
                        title: Text(option),
                      ),
                    );
                  }),
            );
          }),
    );
  }
}
