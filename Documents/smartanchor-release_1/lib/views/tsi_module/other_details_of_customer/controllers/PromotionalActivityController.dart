import 'package:get/get.dart';
import '../../../../../constants/assetsConst.dart';
import '../models/PromotionalActivityModelClass.dart';

class PromotionalActivityController extends GetxController {
  List<PromotionalActivityModelClass> promotionActivityDataList = [
    PromotionalActivityModelClass(
        image: promotionActivityPersonImage,
        userName: 'Tejpal Singh',
        dateIn: 'Jan 21, 2023',
        timeIn: '11:49:08',
        dateOut: 'May 21, 2023',
        timeOut: '11:49:08',
        visitBrief: 'Meeting for Lighting Products'),
    PromotionalActivityModelClass(
        image: promotionActivityPersonImage,
        userName: 'Sumit kumar',
        dateIn: 'Feb 21, 2023',
        timeIn: '11:49:08',
        dateOut: 'Jun 21, 2023',
        timeOut: '11:49:08',
        visitBrief: 'Meeting for Heater Products'),
    PromotionalActivityModelClass(
        image: promotionActivityPersonImage,
        userName: 'Mahipal Singh',
        dateIn: 'Mar 21, 2023',
        timeIn: '11:49:08',
        dateOut: 'July 21, 2023',
        timeOut: '11:49:08',
        visitBrief: 'Meeting for Fan Products'),
  ];
}
