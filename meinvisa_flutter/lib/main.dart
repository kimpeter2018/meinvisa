import 'package:echad/features/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://bodtgiisuipwoqzkxsks.supabase.co",
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJvZHRnaWlzdWlwd29xemt4c2tzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc0MjIyNjYsImV4cCI6MjA3Mjk5ODI2Nn0.sbzFGvASVyAAkdqY4AnB66bZBUMKXtCtgP2oi8UDSOc',
  );

  await GoogleSignIn.instance.initialize(
    clientId:
        "1095073134659-p4scb9kfrt7bldjd8mk9d3gli1l9h621.apps.googleusercontent.com",
    serverClientId:
        "1095073134659-lbsnrjnm2o95sjjuel3t7bv55ccjt40u.apps.googleusercontent.com",
  );

  runApp(const ProviderScope(child: App()));
}
