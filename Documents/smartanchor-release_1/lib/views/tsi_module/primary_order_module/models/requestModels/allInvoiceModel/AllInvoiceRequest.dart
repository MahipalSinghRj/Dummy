import 'package:intl/intl.dart';

class AllInvoiceRequestModal {
  String bu;
  String customerNo;
  int page;
  int pageSize;
  Filter? filter;

  AllInvoiceRequestModal({
    required this.bu,
    required this.customerNo,
    required this.page,
    required this.pageSize,
    this.filter,
  });

  factory AllInvoiceRequestModal.fromJson(Map<String, dynamic> json) =>
      AllInvoiceRequestModal(
        bu: json["Bu"],
        customerNo: json["CustomerNo"],
        page: json["page"],
        pageSize: json["pageSize"],
        filter: json["Filter"] == null ? null : Filter.fromJson(json["Filter"]),
      );

  Map<String, dynamic> toJson() => {
        "Bu": bu,
        "CustomerNo": customerNo,
        "page": page,
        "pageSize": pageSize,
        if (filter != null) "Filter": filter!.toJson(),
      };
}

class Filter {
  String startDate;
  String toDate;

  Filter({
    required this.startDate,
    required this.toDate,
  });

  factory Filter.fromJson(Map<String, dynamic> json) => Filter(
        startDate: json["StartDate"] ?? '',
        toDate: json["ToDate"] ?? '',
      );

  Map<String, dynamic> toJson() {
    final startD = DateFormat('dd/MM/yyyy').parse(startDate);
    final toD = DateFormat('dd/MM/yyyy').parse(toDate);

    return {
      "StartDate":
          "${startD.year.toString().padLeft(4, '0')}-${startD.month.toString().padLeft(2, '0')}-${startD.day.toString().padLeft(2, '0')}",
      "ToDate":
          "${toD.year.toString().padLeft(4, '0')}-${toD.month.toString().padLeft(2, '0')}-${toD.day.toString().padLeft(2, '0')}",
    };
  }
}
