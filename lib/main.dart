import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trendycart_of_seller/features/dashboard/homeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://gwzvpnetxlpqpjsemttw.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd3enZwbmV0eGxwcXBqc2VtdHR3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE1NDMyNDMsImV4cCI6MjA0NzExOTI0M30.M_gXPVEvhH0z69l1VxMt7VwuybOZqQ2gAAnHC1ZMBn0',
  );

  runApp(const DashboardApp());
}

class DashboardApp extends StatelessWidget {
  const DashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ProviderScope(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Home(),
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                elevation: 0,
              ),
              useMaterial3: true,
            ),
            builder: (context, widget) {
              return MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(1.0)),
                child: widget!,
              );
            },
          ),
        );
      },
    );
  }
}
