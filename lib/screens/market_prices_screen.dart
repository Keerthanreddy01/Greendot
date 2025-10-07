import 'package:flutter/material.dart';

class MarketPricesScreen extends StatelessWidget {
  const MarketPricesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Market Prices')),
      body: const Center(
        child: Text('Market prices content goes here'),
      ),
    );
  }
}
