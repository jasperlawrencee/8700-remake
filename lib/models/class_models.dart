class Item {
  String name;
  String category;
  num price;

  Item({
    required this.name,
    required this.category,
    required this.price,
  });
}

class OrderItem {
  String email;
  DateTime orderDateTime;
  String reference;
  num totalPrice;
  List<Map<String, dynamic>> order;

  OrderItem({
    required this.email,
    required this.orderDateTime,
    required this.reference,
    required this.totalPrice,
    required this.order,
  });
}
