class OrderDetail{
  String? productName;
  int? quantity;
  int? price;

  OrderDetail(
    this.productName,
    this.quantity,
    this.price,
  );

  getProductName() => this.productName;
  getQuantity() => this.quantity;
  getPrice() => this.price;
  getProduct() => this.price;
 
  OrderDetail.fromJson(Map<String, dynamic> json):
  productName = json['product']['name'],
  price = json['price'],
  quantity = json['quantity'];
}