class Order {
  final String id;
  final String farmerId;
  final String crop;
  final double quantity;
  final String unit; // e.g., kg, ton, bag
  final double pricePerUnit;
  final DateTime availableDate; // the only date to go to retailer
  final String location;
  final String notes;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.farmerId,
    required this.crop,
    required this.quantity,
    required this.unit,
    required this.pricePerUnit,
    required this.availableDate,
    required this.location,
    required this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'farmerId': farmerId,
      'crop': crop,
      'quantity': quantity,
      'unit': unit,
      'pricePerUnit': pricePerUnit,
      'availableDate': availableDate.toIso8601String(),
      'location': location,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Order.fromDoc(String id, Map<String, dynamic> data) {
    return Order(
      id: id,
      farmerId: data['farmerId'] as String,
      crop: data['crop'] as String,
      quantity: (data['quantity'] as num).toDouble(),
      unit: data['unit'] as String,
      pricePerUnit: (data['pricePerUnit'] as num).toDouble(),
      availableDate: DateTime.parse(data['availableDate'] as String),
      location: data['location'] as String? ?? '',
      notes: data['notes'] as String? ?? '',
      createdAt: DateTime.parse(data['createdAt'] as String),
    );
  }
}


