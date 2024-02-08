import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:smartanchor/constants/colorConst.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../constants/assetsConst.dart';
import 'ProductDataGridSource.dart';

class TableView extends StatefulWidget {
  const TableView({Key? key}) : super(key: key);

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  GlobalKey key = GlobalKey();

  /// DataGridSource required for SfDataGrid to obtain the row data.
  late ProductDataGridSource source;

  /// Collection of GridColumn and it required for SfDataGrid
  late List<GridColumn> columns;

  /// Default sorting operating in drop down widget
  List<String> showMenuItems = <String>['Ascending', 'Descending', 'Clear Sorting'];

  late bool isWebOrDesktop;

  bool isAscending = true;

  @override
  void initState() {
    // TODO: implement initState
    columns = getColumns();
    source = ProductDataGridSource('Custom Header', productDataCount: 20);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      width: 100.w,
      child: SfDataGridTheme(
        data: SfDataGridThemeData(
          headerColor: const Color(0xff009889),
          sortIcon: SvgPicture.asset(
            isAscending ? orderIcon : orderIcon,
            height: 15,
          ),
        ),
        child: SfDataGrid(
          key: key,
          source: source,
          columns: columns,
          columnWidthMode: ColumnWidthMode.fill,
          //isScrollbarAlwaysShown: true,
          frozenColumnsCount: 1,
          verticalScrollPhysics: const NeverScrollableScrollPhysics(),
          allowSorting: true,
          gridLinesVisibility: GridLinesVisibility.both,
          headerGridLinesVisibility: GridLinesVisibility.both,
          onCellTap: (DataGridCellTapDetails details) {
            if (details.rowColumnIndex.rowIndex == 0) {
              setState(() {
                isAscending = !isAscending;
                if (isAscending) {
                  processShowMenuFunctions("Ascending", details.column);
                } else {
                  processShowMenuFunctions("Descending", details.column);
                }
              });
            }
          },
        ),
      ),
    );
  }

  void processShowMenuFunctions(String value, GridColumn gridColumn) {
    print("in side ==$value");
    switch (value) {
      case 'Ascending':
      case 'Descending':
        if (source.sortedColumns.isNotEmpty) {
          source.sortedColumns.clear();
        }
        source.sortedColumns.add(
            SortColumnDetails(name: gridColumn.columnName, sortDirection: value == 'Ascending' ? DataGridSortDirection.ascending : DataGridSortDirection.descending));
        source.sort();
        break;
      case 'Clear Sorting':
        if (source.sortedColumns.isNotEmpty) {
          source.sortedColumns.clear();
          source.sort();
        }
        break;
    }
  }

  Widget buildHeaderCell(Widget headerChild) {
    return Row(
      children: <Widget>[
        Flexible(child: headerChild),
      ],
    );
  }

  List<GridColumn> getColumns() {
    List<GridColumn> columns;
    columns = <GridColumn>[
      GridColumn(
        columnName: 'id',
        width: 140,
        label: buildHeaderCell(Container(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Employee Name',
            style: TextStyle(color: white),
            overflow: TextOverflow.ellipsis,
          ),
        )),
      ),
      GridColumn(
          columnName: 'productId',
          width: 130,
          label: buildHeaderCell(Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Product ID',
              style: TextStyle(color: white),
              overflow: TextOverflow.ellipsis,
            ),
          ))),
      GridColumn(
          columnName: 'name',
          width: 185,
          label: buildHeaderCell(Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Customer Name',
              style: TextStyle(color: white),
              overflow: TextOverflow.ellipsis,
            ),
          ))),
      GridColumn(
          columnName: 'product',
          width: 135,
          label: buildHeaderCell(Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Product',
              style: TextStyle(color: white),
              overflow: TextOverflow.ellipsis,
            ),
          ))),
      GridColumn(
          columnName: 'orderDate',
          width: 150,
          label: buildHeaderCell(Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Order Date',
              style: TextStyle(color: white),
              overflow: TextOverflow.ellipsis,
            ),
          ))),
      GridColumn(
          columnName: 'quantity',
          width: 135,
          label: buildHeaderCell(Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Quantity',
              style: TextStyle(color: white),
              overflow: TextOverflow.ellipsis,
            ),
          ))),
      GridColumn(
          columnName: 'city',
          width: 130,
          label: buildHeaderCell(Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              'City',
              style: TextStyle(color: white),
              overflow: TextOverflow.ellipsis,
            ),
          ))),
      GridColumn(
          columnName: 'unitPrice',
          width: 140,
          label: buildHeaderCell(Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Unit Price',
              style: TextStyle(color: white),
              overflow: TextOverflow.ellipsis,
            ),
          ))),
    ];
    return columns;
  }
}
