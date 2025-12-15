class Producto {
  final int id;
  final String name;
  final int unitsInStock;
  final double unitPrice;

  Producto({
    required this.id,
    required this.name,
    required this.unitsInStock,
    required this.unitPrice,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'] ?? 0,
      name: json['name'],
      unitsInStock: json['unitsInStock'],
      unitPrice: (json['unitPrice'] is int)
          ? (json['unitPrice'] as int).toDouble()
          : json['unitPrice'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'unitsInStock': unitsInStock,
      'unitPrice': unitPrice,
    };
  }
}
