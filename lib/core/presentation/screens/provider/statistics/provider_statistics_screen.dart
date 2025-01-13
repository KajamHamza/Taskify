import 'package:flutter/material.dart';
import 'widgets/statistics_card.dart';
import 'widgets/revenue_chart.dart';
import 'widgets/request_status_chart.dart';

class ProviderStatisticsScreen extends StatelessWidget {
  const ProviderStatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle time range selection
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'week',
                child: Text('Last Week'),
              ),
              const PopupMenuItem(
                value: 'month',
                child: Text('Last Month'),
              ),
              const PopupMenuItem(
                value: 'year',
                child: Text('Last Year'),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: StatisticsCard(
                  title: 'Total Revenue',
                  value: '\$1,234',
                  icon: Icons.attach_money,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatisticsCard(
                  title: 'Total Requests',
                  value: '56',
                  icon: Icons.assignment,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Revenue Overview'),
                  SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: RevenueChart(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Request Status'),
                  SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: RequestStatusChart(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}