import 'package:smartanchor/debug/printme.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  void makePhoneCall(String phoneNum) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNum);

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      printMe("Could not launch");
      throw 'Could not launch $launchUri';
    }
  }

  String formatPrice(double price) {
    return price.toStringAsFixed(2);
  }
}
