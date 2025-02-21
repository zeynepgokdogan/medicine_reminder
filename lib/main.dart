// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_reminder/core/auth/auth_page.dart';
import 'package:medicine_reminder/core/service/firebase_messaging_service.dart';
import 'package:medicine_reminder/core/service/reminder_service.dart';
import 'package:medicine_reminder/core/theme/colors.dart';
import 'package:medicine_reminder/feature/medicine/viewmodel/medicine_viewmodel.dart';
import 'package:medicine_reminder/feature/profilepage/viewmodel/profile_viewmodel.dart';
import 'package:medicine_reminder/feature/register/viewmodel/register_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:workmanager/workmanager.dart';
import 'package:timezone/data/latest_all.dart' as tz; 
import 'firebase_options.dart';

void callbackDispatcher() {
  print("🚀 WorkManager CALLBACK ÇALIŞTI!");
  tz.initializeTimeZones();

  Workmanager().executeTask((task, inputData) async {
    print("✅ WorkManager görevi BAŞLADI: $task");

    String? userId = inputData?['userId'];

    if (userId == null) {
      print("❌ WorkManager için kullanıcı ID'si bulunamadı. FirebaseAuth kontrol ediliyor...");

      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        userId = user.uid;
        print("📌 FirebaseAuth üzerinden Kullanıcı ID bulundu: $userId");
      } else {
        print("❌ FirebaseAuth ile de kullanıcı bulunamadı!");
        return Future.value(false);
      }
    }

    print("📌 Kullanıcı ID: $userId, İlaç Hatırlatma Bildirimi Gönderilecek...");

    try {
      print("🔎 ReminderService çağırılıyor...");
      await ReminderService().sendMedicineReminders(userId);
      print("✔ WorkManager görevi başarıyla tamamlandı.");
      return Future.value(true);
    } catch (e, stacktrace) {
      print("🚨 WorkManager Görevi HATA ALDI: $e");
      print(stacktrace);
      return Future.value(false);
    }
  });
}


Future<void> registerBackgroundTask() async {
  final User? user = FirebaseAuth.instance.currentUser;
  
  if (user == null) {
    print("❌ Oturum açmış kullanıcı bulunamadı, WorkManager kaydedilemedi.");
    return;
  }

  final userId = user.uid; // Firebase Authentication'dan User ID al
  print("📝 WorkManager Görev Kaydı Yapılıyor. Kullanıcı ID: $userId");

  await Workmanager().registerPeriodicTask(
    "medicineReminderTask",
    "medicineReminderTask",
    frequency: const Duration(minutes: 15),
    initialDelay: const Duration(seconds: 5), // Daha hızlı başlasın diye
    inputData: {'userId': userId}, // WorkManager’a doğru ID gönder
  );
}



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
  if (!Firebase.apps.any((app) => app.name == '[DEFAULT]')) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  await initializeDateFormatting('tr_TR', null);
  Intl.defaultLocale = 'tr_TR';

  final FirebaseMessagingService firebaseMessagingService = FirebaseMessagingService();
  await firebaseMessagingService.requestPermission();
  firebaseMessagingService.listenToMessages();

  print("🚀 WorkManager Başlatılıyor...");
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  await registerBackgroundTask();

  runApp(ScreenUtilInit(
    designSize: const Size(360, 690),
    minTextAdapt: true,
    builder: (context, child) {
      return const MyApp(); 
    },
  ));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewmodel()),
        ChangeNotifierProvider(create: (_) => MedicineViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.grey,
          scaffoldBackgroundColor: AppColors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          textTheme: const TextTheme(),
        ),
        home: const AuthPage(),
      ),
    );
  }
}
