import 'package:flutter/material.dart';
import '../services/market_service.dart';

class MarketInsightsScreen extends StatelessWidget {
  const MarketInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final marketService = MarketService();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Insights'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Market data refreshed!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.trending_up, color: Colors.green, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Market Overview',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMarketStat('Active Crops', '12'),
                        _buildMarketStat('Avg Price', '\$38.25'),
                        _buildMarketStat('Market Trend', '+2.3%'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Trending Crops',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              child: Column(
                children: [
                  _buildTrendingCrop(
                      'Wheat', '+5.2%', 52.50, Colors.green, context),
                  _buildTrendingCrop(
                      'Rice', '+2.1%', 30.75, Colors.green, context),
                  _buildTrendingCrop(
                      'Corn', '-1.8%', 24.20, Colors.red, context),
                  _buildTrendingCrop(
                      'Soybeans', '+3.4%', 45.80, Colors.green, context),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Latest News',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              child: Column(
                children: [
                  _buildNewsItem(
                      'Global wheat demand increases due to supply chain disruptions',
                      context),
                  _buildNewsItem(
                      'Rice prices stabilize after recent fluctuations',
                      context),
                  _buildNewsItem(
                      'New agricultural policies expected to impact crop prices',
                      context),
                  _buildNewsItem(
                      'Weather conditions favorable for upcoming harvest season',
                      context),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Price Alerts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              child: Column(
                children: [
                  _buildAlertItem('Wheat prices up 5% this week'),
                  _buildAlertItem('Rice demand remains stable'),
                  _buildAlertItem('Corn prices expected to rise next month'),
                  _buildAlertItem('Soybean exports increase by 15%'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Market Analysis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: marketService.marketInsights.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.purple,
                      child: Icon(Icons.analytics, color: Colors.white),
                    ),
                    title: Text(
                      marketService.marketInsights[index],
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingCrop(String crop, String trend, double price,
      Color color, BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        child: Icon(
          trend.startsWith('+') ? Icons.trending_up : Icons.trending_down,
          color: Colors.white,
          size: 20,
        ),
      ),
      title: Text(
        crop,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('Current Price: \$${price.toStringAsFixed(2)}'),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          trend,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
      onTap: () {
        _showNewsDetail(context, '$crop trending: $trend');
      },
    );
  }

  Widget _buildNewsItem(String news, BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.blue,
        child: Icon(Icons.article, color: Colors.white),
      ),
      title: Text(
        news,
        style: const TextStyle(fontSize: 14),
      ),
      subtitle: const Text(
        '2 days ago',
        style: TextStyle(fontSize: 12, color: Colors.grey),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        _showNewsDetail(context, news);
      },
    );
  }

  Widget _buildAlertItem(String alert) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.orange,
        child: Icon(Icons.notifications, color: Colors.white),
      ),
      title: Text(
        alert,
        style: const TextStyle(fontSize: 14),
      ),
      subtitle: const Text(
        'Alert',
        style: TextStyle(fontSize: 12, color: Colors.orange),
      ),
    );
  }

  void _showNewsDetail(BuildContext context, String news) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Market News'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(news),
            const SizedBox(height: 16),
            Text(
              'This news may impact crop prices and market trends. Stay updated for more information.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
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
                  content: Text('News saved to favorites!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
