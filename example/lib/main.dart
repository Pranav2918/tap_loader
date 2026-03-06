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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tap Loader Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             // Basic usage
              _Section(
                title: 'Basic Usage',
                child: TapLoaderButton(
                  text: 'Submit',
                  onTap: () async {
                    await Future.delayed(const Duration(seconds: 2));
                  },
                ),
              ),

              // Custom Colors
              _Section(
                title: 'Custom Colors',
                child: TapLoaderButton(
                  text: 'Save Changes',
                  buttonColor: Colors.green,
                  textColor: Colors.white,
                  loaderColor: Colors.white,
                  onTap: () async {
                    await Future.delayed(const Duration(seconds: 2));
                  },
                ),
              ),

              // Custom Child with Icon
              _Section(
                title: 'Custom Child (Icon + Text)',
                child: TapLoaderButton(
                  buttonColor: Colors.blueAccent,
                  onTap: () async {
                    await Future.delayed(const Duration(seconds: 2));
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cloud_upload, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Upload File', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),

              // Custom Loader
              _Section(
                title: 'Custom Loader Widget',
                child: TapLoaderButton(
                  text: 'Fetching Data...',
                  buttonColor: Colors.orange,
                  loaderWidget: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                  onTap: () async {
                    await Future.delayed(const Duration(seconds: 2));
                  },
                ),
              ),

              // Full Width
              _Section(
                title: 'Full Width & Rounded',
                child: TapLoaderButton(
                  text: 'LOGIN',
                  width: double.infinity,
                  height: 50,
                  borderRadius: 25,
                  buttonColor: Colors.black,
                  onTap: () async {
                    await Future.delayed(const Duration(seconds: 2));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey)),
          const SizedBox(height: 8),
          child,
          const Divider(height: 32),
        ],
      ),
    );
  }
}
