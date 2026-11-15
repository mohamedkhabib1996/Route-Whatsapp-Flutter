import 'package:material_ui/material_ui.dart';

import 'screens/chat_screen.dart';
import 'theme/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Assignment6App());
}

class Assignment6App extends StatelessWidget {
  const Assignment6App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatsApp UI - Assignment 6',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: AppColors.wallpaper,
        primaryColor: AppColors.green,
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.green,
          foregroundColor: AppColors.white,
        ),
      ),
      home: const ChatScreen(),
    );
  }
}
