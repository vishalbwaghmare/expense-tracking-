import 'dart:async';

import 'package:expense_tracker/core/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LaunchApp extends StatefulWidget {
  const LaunchApp({super.key});

  @override
  State<LaunchApp> createState() => _LaunchAppState();
}

class _LaunchAppState extends State<LaunchApp> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1000), () {
      if (mounted) {
        context.go(AppRoutes.splash.path);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Loading...',
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      ),
    );
  }
}
