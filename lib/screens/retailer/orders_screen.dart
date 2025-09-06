import 'package:flutter/material.dart';
import '../../services/order_service.dart';
import '../../models/order.dart' as model;

class OrdersScreen extends StatelessWidget {
  final OrderService _service = OrderService();

  OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<model.Order>>(
        stream: _service.streamOrdersForRetailer(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return const Center(child: Text('No orders yet'));
          }
          return ListView.separated(
            itemCount: orders.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final o = orders[index];
              return ListTile(
                leading: const Icon(Icons.shopping_bag, color: Colors.green),
                title: Text('${o.crop} • ${o.quantity} ${o.unit}'),
                subtitle: Text(
                  'Price: ${o.pricePerUnit} per ${o.unit}\nAvailable: ${_formatDate(o.availableDate)}\nLocation: ${o.location}',
                ),
                isThreeLine: true,
                trailing: Text(
                    '₹${(o.quantity * o.pricePerUnit).toStringAsFixed(0)}'),
                onTap: () {
                  _showOrderDetails(context, o);
                },
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  void _showOrderDetails(BuildContext context, model.Order o) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(o.crop,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Quantity: ${o.quantity} ${o.unit}'),
              Text('Price per unit: ₹${o.pricePerUnit}'),
              Text('Available date: ${_formatDate(o.availableDate)}'),
              if (o.location.isNotEmpty) Text('Location: ${o.location}'),
              if (o.notes.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text('Notes:'),
                Text(o.notes),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
