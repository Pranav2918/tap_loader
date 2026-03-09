import 'package:flutter/material.dart';
import 'package:tap_loader/tap_loader.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tap Loader Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _manualLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tap Loader Demo'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Standard Usage
            _Section(
              title: 'Standard Async Usage',
              description: 'Wait for 2 seconds automatically',
              child: TapLoaderButton(
                text: 'Async Action',
                onTap: () async {
                  await Future.delayed(const Duration(seconds: 2));
                },
              ),
            ),

            // Synchronous Usage
            _Section(
              title: 'Synchronous Usage',
              description: 'Works instantly without loading indicator',
              child: TapLoaderButton(
                text: 'Sync Action',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Instant click!')),
                  );
                },
              ),
            ),

            // Custom Styling
            _Section(
              title: 'Custom Styling',
              description: 'Custom colors and border radius',
              child: TapLoaderButton(
                text: 'Delete Account',
                backgroundColor: Colors.red.shade600,
                loadingBackgroundColor: Colors.red.shade900,
                textColor: Colors.white,
                borderRadius: 30,
                onTap: () async {
                  await Future.delayed(const Duration(seconds: 2));
                },
              ),
            ),

            // Complex Child
            _Section(
              title: 'Custom Child',
              description: 'With icon and custom layout',
              child: TapLoaderButton(
                backgroundColor: Colors.green.shade600,
                onTap: () async {
                  await Future.delayed(const Duration(seconds: 2));
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.cloud_done, color: Colors.white),
                    SizedBox(width: 12),
                    Text(
                      'Deploy Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // External Control
            _Section(
              title: 'External Control',
              description: 'Controlled by external state',
              child: Column(
                children: [
                  TapLoaderButton(
                    text: _manualLoading ? 'Stop Loading' : 'Start Loading',
                    isLoading: _manualLoading,
                    backgroundColor: Colors.orange,
                    onTap: () {
                      setState(() {
                        _manualLoading = !_manualLoading;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => setState(() => _manualLoading = false),
                    child: const Text('Reset Loader'),
                  ),
                ],
              ),
            ),

            // Custom Indicator
            _Section(
              title: 'Custom Indicator',
              description: 'Use a different progress widget',
              child: TapLoaderButton(
                text: 'Synchronizing...',
                indicatorWidget: const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
                onTap: () async {
                  await Future.delayed(const Duration(seconds: 3));
                },
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String description;
  final Widget child;

  const _Section({
    required this.title,
    required this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 20),
          Center(child: child),
        ],
      ),
    );
  }
}
