import '../../domain/models/sale_record.dart';
import '../../domain/repositories/sales_repository.dart';

class MockSalesRepository implements SalesRepository {
  final List<SaleRecord> _sales = [];

  @override
  Future<List<SaleRecord>> getSalesHistory() async {
    return _sales;
  }

  @override
  Future<void> recordSale(SaleRecord sale) async {
    _sales.add(sale);
  }
}
