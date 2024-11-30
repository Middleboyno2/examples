
import 'package:caccu_app/presentation/Screen/Bill/billViewModel.dart';
import 'package:caccu_app/presentation/Screen/Home/HomeViewModel.dart';
import 'package:caccu_app/presentation/Screen/Account/Login.dart';
import 'package:caccu_app/presentation/Screen/Account/UserViewModel.dart';
import 'package:caccu_app/presentation/Screen/addTransacion/addTransactionViewModel.dart';
import 'package:caccu_app/presentation/Screen/monthlyWallet/monthlyWalletViewModel.dart';
import 'package:caccu_app/presentation/Screen/navigator.dart';
import 'package:caccu_app/presentation/Screen/transaction/TransactionViewModel.dart';
import 'package:caccu_app/presentation/Screen/Wallet/walletViewModel.dart';
import 'package:caccu_app/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await FirebaseApi().initNotification();
  // Initialize Flutter Local Notifications
  await initializeNotifications();

  await Hive.initFlutter();
  await Hive.openBox('userBox');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => MonthlyWalletViewModel()),
        ChangeNotifierProvider(create: (_) => WalletViewModel()),
        ChangeNotifierProvider(create: (_) => AddTransactionViewModel()),
        ChangeNotifierProvider(create: (_) => BillViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? isLoggedIn;
  // NotificationService notificationService

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    bool status = await Provider.of<UserViewModel>(context, listen: false).checkUserLoginStatus();
    setState(() {
      isLoggedIn = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      // Hiển thị màn hình chờ khi kiểm tra trạng thái đăng nhập
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightMode,
          darkTheme: darkMode,
          home: const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
      );
    }

    // Hiển thị màn hình tương ứng dựa trên trạng thái đăng nhập
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      darkTheme: darkMode,
      home: isLoggedIn! ? const NavScreen() : const LoginScreen(),
    );
  }
}

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  // Initialization settings for Android
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  // Request notification permissions for Android 13+
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  // Initialize the plugin
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await setupNotificationChannels();
}


Future<void> setupNotificationChannels() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'default_channel', // id
    'Default Notifications', // title
    description: 'This channel is used for default notifications.', // description
    importance: Importance.max,
  );

  // Initialize notification plugin
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

