import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductRecommendationPage extends StatelessWidget {
  final Function(bool) toggleDarkMode; // ✅ Dark mode toggle function

  const ProductRecommendationPage({
    Key? key,
    required this.toggleDarkMode,
  }) : super(key: key);

  // 🌐 Function to open the Amazon search URL
  Future<void> _launchURL(String query) async {
    final url = Uri.parse('https://www.amazon.in/s?k=$query');

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
        throw 'Could not launch $url';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Recommendations'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              toggleDarkMode(!isDark); // ✅ Trigger dark mode change
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select your skin type to get recommendations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.water_drop_outlined),
              label: const Text('Oily Skin'),
              onPressed: () => _launchURL('oily+skin+care'),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.face),
              label: const Text('Normal Skin'),
              onPressed: () => _launchURL('normal+skin+care'),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.ac_unit_outlined),
              label: const Text('Dry Skin'),
              onPressed: () => _launchURL('dry+skin+care'),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            ),
          ],
        ),
      ),
    );
  }
}
