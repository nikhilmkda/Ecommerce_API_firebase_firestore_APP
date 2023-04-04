import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class IntListAdapter extends TypeAdapter<List<int>> {
  @override
  final typeId = 0;

  @override
  List<int> read(BinaryReader reader) {
    final length = reader.readByte();
    final list = <int>[];
    for (var i = 0; i < length; i++) {
      list.add(reader.readInt());
    }
    return list;
  }

  @override
  void write(BinaryWriter writer, List<int> list) {
    writer.writeByte(list.length);
    for (final item in list) {
      writer.writeInt(item);
    }
  }
}

class HiveHelper with ChangeNotifier {
  @override
  notifyListeners();
  List<int> itemscart = [];
  List<int> itemListCount = [];
  List<int> totalcartPrice = [];
  List<int> itemQTyList = [];
  num totalCartPriceSum =
      0; // remove from cart total not updatinng instantly, put the cart body in future builder,

  num get cartTotalPrice => totalcartPrice.fold(
      0, (previousValue, element) => previousValue + element);
  Future<void> saveItemQTyListHive() async {
    final intBoxitemCount = await Hive.openBox<List<int>>('intitemCount');
    await intBoxitemCount.put('count', itemQTyList);
    notifyListeners();
  }

  
  Future<void> saveItemPriceHive() async {
    final intBoxprice = await Hive.openBox<List<int>>('intPrice');
    await intBoxprice.put('Price', totalcartPrice);
    notifyListeners();
  }

  Future<void> saveIntListCart(List<int> itemscart, List<int> totalcartPrice,
      List<int> itemQTyList) async {
    final intListBoxcart = await Hive.openBox<List<int>>('intCart');
    final intBoxprice = await Hive.openBox<List<int>>('intPrice');
    final intBoxitemCount = await Hive.openBox<List<int>>('intitemCount');
    await intListBoxcart.put('Cart', itemscart);
    await intBoxprice.put('Price', totalcartPrice);
    await intBoxitemCount.put('count', itemQTyList);
    await intListBoxcart.close();
    await intBoxprice.close();
    await intBoxitemCount.close();
    notifyListeners();
  }

  Future<Map<String, List<int>>> getIntListCart() async {
    final intListBox = await Hive.openBox<List<int>>('intCart');
    final intBoxprice = await Hive.openBox<List<int>>('intPrice');
    final intBoxitemCount = await Hive.openBox<List<int>>('intitemCount');
    print('Box is open: ${intListBox.isOpen}');
    final itemscart = intListBox.get('Cart') ?? <int>[];
    final totalcartPrice = intBoxprice.get('Price') ?? <int>[];
    final itemQTyList = intBoxitemCount.get('count') ?? <int>[];
    print('the get values are $itemscart');
    print('the get prices are $totalcartPrice');
    notifyListeners();
    return {
      'itemscart': itemscart,
      'totalcartPrice': totalcartPrice,
      'itemQTyList': itemQTyList
    };
  }

  Future<void> removeCartItemhive(int index) async {
    final intListBox = await Hive.openBox<List<int>>('intCart');
    final intBoxprice = await Hive.openBox<List<int>>('intPrice');
    final intBoxitemCount = await Hive.openBox<List<int>>('intitemCount');

    final existingList = intListBox.get('Cart', defaultValue: [])!;
    final existingListprice = intBoxprice.get('Price', defaultValue: [])!;
    final existingListCount = intBoxitemCount.get('count', defaultValue: [])!;

    existingList.removeAt(index);
    existingListprice.removeAt(index);
    existingListCount.removeAt(index);

    await intListBox.put('Cart', existingList);
    await intBoxprice.put('Price', existingListprice);
    await intBoxitemCount.put('count', existingListCount);

    itemscart = existingList;
    totalcartPrice = existingListprice;
    itemQTyList = existingListCount;

    notifyListeners();
  }

  void itemCartAddindex(int itemindex) {
    itemscart.add(itemindex);
    notifyListeners();
  }

  void itemQTYincrement(int index, int price) {
    itemQTyList[index]++;
    totalcartPrice[index] += price;
    saveItemQTyListHive();
    saveItemPriceHive();
    notifyListeners();
  }

  void itemQTYidecrement(int index, int price) {
    if (itemQTyList[index] <= 1) {
      return;
    } else {
      itemQTyList[index]--;
      totalcartPrice[index] -= price;
    }
    saveItemQTyListHive();
    saveItemPriceHive();
    notifyListeners();
  }
}
