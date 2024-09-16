class ProductModel {
  final String id;
  final String productName;
  final String productCode;
  final String img;
  final String unitPrice;
  final String qty;
  final String totalPrice;
  final String createdDate;

  ProductModel({
    required this.id,
    required this.productName,
    required this.productCode,
    required this.img,
    required this.unitPrice,
    required this.qty,
    required this.totalPrice,
    required this.createdDate,
  });
}
