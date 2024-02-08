class AllInvoicesListModelClass {
  final String businessUnit;
  final String transactionType;
  final String date;
  final String referenceNo;
  final String salesOrder;
  bool isSelected;

  AllInvoicesListModelClass(
      {required this.businessUnit,
      required this.transactionType,
      required this.date,
      required this.referenceNo,
      required this.salesOrder,
      this.isSelected = false});
}
