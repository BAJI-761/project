import 'package:flutter/foundation.dart';

// Placeholder model
class RetailerOffer {
  final String crop;
  final double price;
  final double rating;
  final String retailerId;

  RetailerOffer(this.crop, this.price, this.rating, this.retailerId);
}

class MarketService {
  List<RetailerOffer> get retailerOffers => [
        RetailerOffer('Wheat', 50.0, 4.2, 'retailer1'),
        RetailerOffer('Rice', 30.0, 4.5, 'retailer2'),
      ];

  List<String> get marketInsights => [
        'Wheat prices are up 5% this week.',
        'Rice demand is stable.',
      ];

  void addReview(String retailerId, double rating) {
    // Placeholder: Simulate review update
    debugPrint('Added review for $retailerId with rating $rating');
  }

  void updateRetailerInventory(String retailerId, Map<String, int> inventory) {
    // Placeholder: Simulate inventory update
    debugPrint('Updated inventory for $retailerId: $inventory');
  }
}
