import 'package:flutter/material.dart';
import '../../services/market_service.dart';

class InventoryManagementScreen extends StatefulWidget {
  const InventoryManagementScreen({super.key});

  @override
  _InventoryManagementScreenState createState() =>
      _InventoryManagementScreenState();
}

class _InventoryManagementScreenState extends State<InventoryManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cropController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final marketService = MarketService();

  final List<Map<String, dynamic>> _inventory = [
    {'crop': 'Wheat', 'quantity': 1000, 'price': 50.0, 'unit': 'kg'},
    {'crop': 'Rice', 'quantity': 800, 'price': 30.0, 'unit': 'kg'},
    {'crop': 'Corn', 'quantity': 1200, 'price': 25.0, 'unit': 'kg'},
  ];

  bool _isAddingItem = false;

  final List<String> _cropTypes = [
    'Wheat',
    'Rice',
    'Corn',
    'Soybeans',
    'Cotton',
    'Sugarcane',
    'Potatoes',
    'Tomatoes',
    'Onions',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                _isAddingItem = true;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Card
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem('Total Items', '${_inventory.length}'),
                    _buildSummaryItem('Total Value',
                        '\$${_calculateTotalValue().toStringAsFixed(2)}'),
                    _buildSummaryItem('Avg Price',
                        '\$${_calculateAveragePrice().toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
          ),

          // Add Item Form
          if (_isAddingItem) ...[
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Add New Item',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  _isAddingItem = false;
                                  _formKey.currentState?.reset();
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Crop Type Dropdown
                        DropdownButtonFormField<String>(
                          initialValue: _cropController.text.isEmpty
                              ? null
                              : _cropController.text,
                          decoration: InputDecoration(
                            labelText: 'Crop Type',
                            prefixIcon: const Icon(Icons.agriculture),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: _cropTypes.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _cropController.text = newValue ?? '';
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select crop type';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Quantity Input
                        TextFormField(
                          controller: _quantityController,
                          decoration: InputDecoration(
                            labelText: 'Quantity (kg)',
                            prefixIcon: const Icon(Icons.scale),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter quantity';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            if (double.parse(value) <= 0) {
                              return 'Quantity must be greater than 0';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Price Input
                        TextFormField(
                          controller: _priceController,
                          decoration: InputDecoration(
                            labelText: 'Price per kg (\$)',
                            prefixIcon: const Icon(Icons.attach_money),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter price';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            if (double.parse(value) < 0) {
                              return 'Price cannot be negative';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Add Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _addInventoryItem,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Add to Inventory',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],

          // Inventory List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _inventory.length,
              itemBuilder: (context, index) {
                final item = _inventory[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(
                        Icons.agriculture,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      item['crop'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quantity: ${item['quantity']} ${item['unit']}'),
                        Text(
                            'Price: \$${item['price'].toStringAsFixed(2)} per ${item['unit']}'),
                        Text(
                          'Total: \$${(item['quantity'] * item['price']).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: Colors.blue),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete'),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'edit') {
                          _editInventoryItem(index);
                        } else if (value == 'delete') {
                          _deleteInventoryItem(index);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  void _addInventoryItem() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _inventory.add({
        'crop': _cropController.text,
        'quantity': double.parse(_quantityController.text),
        'price': double.parse(_priceController.text),
        'unit': 'kg',
      });
      _isAddingItem = false;
      _formKey.currentState?.reset();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item added to inventory!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _editInventoryItem(int index) {
    final item = _inventory[index];
    _cropController.text = item['crop'];
    _quantityController.text = item['quantity'].toString();
    _priceController.text = item['price'].toString();

    setState(() {
      _isAddingItem = true;
    });

    // Remove the old item
    _inventory.removeAt(index);
  }

  void _deleteInventoryItem(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text(
            'Are you sure you want to delete ${_inventory[index]['crop']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _inventory.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Item deleted!'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  double _calculateTotalValue() {
    return _inventory.fold(
        0.0, (sum, item) => sum + (item['quantity'] * item['price']));
  }

  double _calculateAveragePrice() {
    if (_inventory.isEmpty) return 0.0;
    final totalValue = _calculateTotalValue();
    final totalQuantity =
        _inventory.fold(0.0, (sum, item) => sum + item['quantity']);
    return totalValue / totalQuantity;
  }

  @override
  void dispose() {
    _cropController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}
