import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order.dart' as model;

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _ordersCol =>
      _firestore.collection('orders');

  Future<String> createOrder(model.Order order) async {
    final doc = await _ordersCol.add(order.toMap());
    return doc.id;
  }

  Stream<List<model.Order>> streamOrdersForRetailer() {
    // For now, show all active orders sorted by date; later we can filter by region/category
    return _ordersCol
        .orderBy('availableDate')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((d) => model.Order.fromDoc(d.id, d.data()))
            .toList());
  }

  Future<List<model.Order>> listOrdersForFarmer(String farmerId) async {
    final qs = await _ordersCol
        .where('farmerId', isEqualTo: farmerId)
        .orderBy('createdAt', descending: true)
        .get();
    return qs.docs.map((d) => model.Order.fromDoc(d.id, d.data())).toList();
  }
}


