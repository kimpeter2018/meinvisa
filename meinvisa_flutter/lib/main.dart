import 'package:meinvisa/features/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final flavor = const String.fromEnvironment('FLAVOR', defaultValue: 'local');
  await dotenv.load(fileName: flavor == 'prod' ? ".env.prod" : ".env.local");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  await GoogleSignIn.instance.initialize(
    clientId:
        "1095073134659-p4scb9kfrt7bldjd8mk9d3gli1l9h621.apps.googleusercontent.com",
    serverClientId:
        "1095073134659-lbsnrjnm2o95sjjuel3t7bv55ccjt40u.apps.googleusercontent.com",
  );

  runApp(const ProviderScope(child: App()));
}
