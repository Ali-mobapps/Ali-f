import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';

class ExcelHelper {
  static Future<List<Map<String, dynamic>>> pickAndParseExcel() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls', 'csv'],
    );

    if (result != null) {
      var bytes = File(result.files.single.path!).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      List<Map<String, dynamic>> products = [];

      for (var table in excel.tables.keys) {
        var rows = excel.tables[table]?.rows;
        if (rows == null || rows.isEmpty) continue;

        // Assuming Header: Name, Type, Author, Category, Rack, Cost, Price, Stock
        for (int i = 1; i < rows.length; i++) {
          var row = rows[i];
          if (row.isEmpty) continue;

          products.add({
            'id': const Uuid().v4(),
            'name': row[0]?.value.toString() ?? 'Unknown',
            'type': row[1]?.value.toString().toLowerCase() == 'book' ? 'book' : 'stationery',
            'course_or_category': row[3]?.value.toString(),
            'rack_location': row[4]?.value.toString(),
            'cost_price': double.tryParse(row[5]?.value.toString() ?? '0') ?? 0.0,
            'sale_price': double.tryParse(row[6]?.value.toString() ?? '0') ?? 0.0,
            'stock_quantity': int.tryParse(row[7]?.value.toString() ?? '0') ?? 0,
            'min_stock_threshold': 3,
          });
        }
      }
      return products;
    }
    return [];
  }
}
