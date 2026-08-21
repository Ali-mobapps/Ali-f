import '../../domain/models/inventory_item.dart';
import '../../domain/repositories/inventory_repository.dart';

class MockInventoryRepository implements InventoryRepository {
  final List<InventoryItem> _items = [
    InventoryItem(
      id: '1',
      title: 'The Great Gatsby',
      author: 'F. Scott Fitzgerald',
      category: 'Books',
      location: 'Shelf A1',
      costPrice: 500,
      salePrice: 750,
      stockLevel: 15,
      minStockLevel: 5,
    ),
    InventoryItem(
      id: '2',
      title: 'Atomic Habits',
      author: 'James Clear',
      category: 'Books',
      location: 'Shelf B2',
      costPrice: 800,
      salePrice: 1200,
      stockLevel: 3,
      minStockLevel: 10,
    ),
    InventoryItem(
      id: '3',
      title: 'Blue Ball Pen',
      author: 'Generic',
      category: 'Stationery',
      location: 'Counter 1',
      costPrice: 10,
      salePrice: 20,
      stockLevel: 100,
      minStockLevel: 20,
    ),
  ];

  @override
  Future<List<InventoryItem>> getInventoryItems() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _items;
  }

  @override
  Future<void> addInventoryItem(InventoryItem item) async {
    _items.add(item);
  }

  @override
  Future<void> updateInventoryItem(InventoryItem item) async {
    final index = _items.indexWhere((element) => element.id == item.id);
    if (index != -1) {
      _items[index] = item;
    }
  }

  @override
  Future<void> deleteInventoryItem(String id) async {
    _items.removeWhere((element) => element.id == id);
  }
}
