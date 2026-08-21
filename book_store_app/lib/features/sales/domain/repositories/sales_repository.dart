import '../models/sale_record.dart';

abstract class SalesRepository {
  Future<List<SaleRecord>> getSalesHistory();
  Future<void> recordSale(SaleRecord sale);
}
