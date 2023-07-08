import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_settings/open_settings.dart';

import 'package:twit_clone/colors.dart';
import 'package:twit_clone/firebase_options.dart';
import 'package:twit_clone/repositories/auth_repo.dart';
import 'package:twit_clone/services/auth/bloc/auth_bloc.dart';
import 'package:twit_clone/services/internet_service/bloc/internet_bloc.dart';
import 'package:twit_clone/views/acc_view.dart';
import 'package:twit_clone/views/fav_view.dart';
import 'package:twit_clone/views/home_view.dart';
import 'package:twit_clone/views/landing_screen.dart';
import 'package:twit_clone/views/search_view.dart';
import 'package:twit_clone/widgets/glowing_action_button.dart';

//Todo
//add user details gathering screen and update users auth profile
//commit changes to firestore

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => AuthRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => InternetBloc(),
          ),
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context),
              context: context,
            ),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
            useMaterial3: true,
            textTheme: GoogleFonts.latoTextTheme(),
          ),
          home: state is AuthenticatedState
              ? const MyHomeScreen()
              : const LandingScreen(),
        );
      },
    );
  }
}

class MyHomeScreen extends StatefulWidget {
  static Route getRoute() => MaterialPageRoute(
        builder: (context) => const MyHomeScreen(),
      );
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  int index = 0;
  final ValueNotifier<int> pageIndex = ValueNotifier(0);
  final pages = const [
    HomeScreen(),
    SearchScreen(),
    FavScreen(),
    AccountScreen(),
  ];

  void _onNavigationItemSelected(index) {
    pageIndex.value = index;
  }

  void openInternetSettings() async {
    OpenSettings.openNetworkOperatorSetting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 100,
        title: const Text(
          'Post.it',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 30,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search_outlined), onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.person_outlined), onPressed: () {}),
        ],
      ),
      body: BlocBuilder<InternetBloc, InternetState>(
        builder: (context, state) {
          if (state is NotConnectedState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.wifi_off,
                    size: 60,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Internet is off please turn on clicking below button',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: openInternetSettings,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    child: const Text(
                      'turn on internet',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            );
          }

          return ValueListenableBuilder(
            valueListenable: pageIndex,
            builder: (context, value, child) {
              return pages[value];
            },
          );
        },
      ),
      bottomNavigationBar:
          _BottomNavBar(onItemSelected: _onNavigationItemSelected),
    );
  }
}

class _BottomNavBar extends StatefulWidget {
  const _BottomNavBar({
    Key? key,
    required this.onItemSelected,
  }) : super(key: key);
  final ValueChanged<int> onItemSelected;

  @override
  State<_BottomNavBar> createState() => __BottomNavBarState();
}

class __BottomNavBarState extends State<_BottomNavBar> {
  var selectedIndex = 0;

  void handleItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.onItemSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: secondaryAccent,
      elevation: 0,
      margin: const EdgeInsets.all(0),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavigationBarItem(
                lable: 'Home',
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                index: 0,
                isSelected: (selectedIndex == 0),
                onTap: handleItemSelected,
              ),
              _NavigationBarItem(
                lable: 'Search',
                icon: Icons.search_outlined,
                selectedIcon: Icons.search,
                index: 1,
                onTap: handleItemSelected,
                isSelected: (selectedIndex == 1),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GlowingActionButton(
                  color: Colors.black,
                  iconData: CupertinoIcons.add,
                  onPressed: () {},
                ),
              ),
              _NavigationBarItem(
                lable: 'Favourites',
                icon: Icons.favorite_outline,
                selectedIcon: Icons.favorite,
                index: 2,
                onTap: handleItemSelected,
                isSelected: (selectedIndex == 2),
              ),
              _NavigationBarItem(
                selectedIcon: Icons.person,
                lable: 'Profile',
                icon: Icons.person_outline,
                index: 3,
                onTap: handleItemSelected,
                isSelected: (selectedIndex == 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationBarItem extends StatelessWidget {
  const _NavigationBarItem({
    Key? key,
    required this.selectedIcon,
    required this.lable,
    required this.icon,
    required this.index,
    this.isSelected = false,
    required this.onTap,
  }) : super(key: key);
  final IconData selectedIcon;
  final String lable;
  final IconData icon;
  final int index;
  final bool isSelected;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap(index);
      },
      child: SizedBox(
        width: 70,
        height: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              size: 20,
              color: isSelected
                  ? const Color.fromARGB(255, 44, 43, 43)
                  : Colors.black,
            ),
            const SizedBox(height: 8),
            Text(
              lable,
              style: isSelected
                  ? const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    )
                  : const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
