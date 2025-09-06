import 'package:flutter/material.dart';
import '../../services/market_service.dart';

class RetailerSearchScreen extends StatefulWidget {
  const RetailerSearchScreen({super.key});

  @override
  _RetailerSearchScreenState createState() => _RetailerSearchScreenState();
}

class _RetailerSearchScreenState extends State<RetailerSearchScreen> {
  final _searchController = TextEditingController();
  final marketService = MarketService();
  List<RetailerOffer> _filteredOffers = [];
  String _selectedCrop = 'All';

  @override
  void initState() {
    super.initState();
    _filteredOffers = marketService.retailerOffers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Retailers'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search retailers...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: _filterRetailers,
                ),
                const SizedBox(height: 16),

                // Crop Filter
                Row(
                  children: [
                    const Text(
                      'Filter by crop: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: DropdownButton<String>(
                        value: _selectedCrop,
                        isExpanded: true,
                        items: ['All', 'Wheat', 'Rice', 'Corn', 'Soybeans']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCrop = newValue!;
                            _filterRetailers(_searchController.text);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Results Section
          Expanded(
            child: _filteredOffers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No retailers found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: _filteredOffers.length,
                    itemBuilder: (context, index) {
                      final offer = _filteredOffers[index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Retailer ${offer.retailerId}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Crop: ${offer.crop}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '\$${offer.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            size: 16,
                                            color: Colors.orange,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${offer.rating}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        _showContactDialog(context, offer);
                                      },
                                      icon: const Icon(Icons.phone),
                                      label: const Text('Contact'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        marketService.addReview(
                                            offer.retailerId, 4.5);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Review submitted!'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.rate_review),
                                      label: const Text('Rate'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.green,
                                        side: const BorderSide(
                                            color: Colors.green),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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

  void _filterRetailers(String query) {
    setState(() {
      _filteredOffers = marketService.retailerOffers.where((offer) {
        final matchesSearch =
            offer.crop.toLowerCase().contains(query.toLowerCase()) ||
                offer.retailerId.toLowerCase().contains(query.toLowerCase());
        final matchesCrop =
            _selectedCrop == 'All' || offer.crop == _selectedCrop;
        return matchesSearch && matchesCrop;
      }).toList();
    });
  }

  void _showContactDialog(BuildContext context, RetailerOffer offer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Retailer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Retailer: ${offer.retailerId}'),
            const SizedBox(height: 8),
            Text('Crop: ${offer.crop}'),
            const SizedBox(height: 8),
            Text('Price: \$${offer.price.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const Text('Contact Information:'),
            const SizedBox(height: 8),
            const Text('Phone: +1 (555) 123-4567'),
            Text('Email: retailer${offer.retailerId}@agritrade.com'),
            const Text('Address: 123 Main St, City, State'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Contact request sent!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Send Request'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
