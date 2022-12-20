import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/home/group_screen_folder/group_home_screen.dart';
import 'package:medical_app/home/group_screen_folder/verification_group_screen.dart';
import 'package:medical_app/home/person_home_screen.dart';
import 'package:medical_app/home/profile_page/profile_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class HomeScreenMainLogin extends StatefulWidget {
  final String? keyLogin;
  final String? keyCode;
  // final bool? checkGroupOrPersonal;
  const HomeScreenMainLogin(
      {Key? key,
      // required this.checkGroupOrPersonal,
      required this.keyLogin,
      this.keyCode = ""})
      : super(key: key);

  @override
  _HomeScreenMainLoginState createState() => _HomeScreenMainLoginState();
}

class _HomeScreenMainLoginState extends State<HomeScreenMainLogin>
    with WidgetsBindingObserver {
  late String keyLogin;
  late String keyCode;
  // int indexGroupOrPerson = 1;
  // late bool _checkGroupOrPersonal;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    keyLogin = this.widget.keyLogin!;
    keyCode = this.widget.keyCode!;
    _controller = PersistentTabController(initialIndex: 1);
  }

  @override
  void dispose() {
    // TODO: implement dispose

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // switch (state) {
    //   case AppLifecycleState.paused:
    //     indexGroupOrPerson == 0
    //         ? await Manager(key: keyLogin).upSeverListInfo()
    //         : Manager(key: keyLogin).keyCodeGroup != '******'
    //             ? await Manager(key: keyLogin).upServerListInfoFireStore()
    //             : null;
    //     break;
    //   default:
    //     break;
    // }
  }

  late PersistentTabController _controller;

  List<Widget> _buildScreens() {
    return [
      Home(keyLogin: keyLogin),
      keyCode == ""
          ? VerificationGroupScreen(keyLogin: keyLogin)
          : GroupScreen(
              keyLogin: keyLogin,
              keyCode: keyCode,
            ),
      ProfileScreen(
        keylogin: keyLogin,
      )
      // HistoryPateintScreen(
      //     checkGroupOrPersonal: keyCode != "" ? true : false,
      //     manager: Manager(key: keyLogin)),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.person),
        title: ("Cá Nhân"),
        activeColorPrimary: Color.fromARGB(255, 15, 127, 239),
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.group),
        title: ("Nhóm"),
        activeColorPrimary: Color.fromARGB(255, 7, 226, 47),
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.person_crop_circle),
        title: ("Hồ sơ"),
        activeColorPrimary: Color.fromARGB(255, 244, 120, 26),
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.amber[100],
        child: PersistentTabView(
          context,
          // onItemSelected: (value) async {
          //   print("object : $value ");
          //   if (value.toInt() == 0) {
          //     indexGroupOrPerson = 0;
          //     await Manager(key: keyLogin).readDataRealTimeDBManager();
          //   } else {
          //     if (Manager(key: keyLogin).keyCodeGroup != "******") {
          //       indexGroupOrPerson = 1;
          //       await Manager(key: keyLogin).readDataFireStoreDBManager();
          //     }
          //   }
          // },
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          confineInSafeArea: true,
          backgroundColor: Colors.white, // Default is Colors.white.
          handleAndroidBackButtonPress: true, // Default is true.
          resizeToAvoidBottomInset:
              true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
          stateManagement: true, // Default is true.
          hideNavigationBarWhenKeyboardShows:
              true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(10.0),
            colorBehindNavBar: Color.fromARGB(255, 223, 130, 130),
          ),
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.all,
          itemAnimationProperties: ItemAnimationProperties(
            // Navigation Bar's items animation properties.
            duration: Duration(milliseconds: 200),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: ScreenTransitionAnimation(
            // Screen transition animation on change of selected tab.
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
          navBarStyle: NavBarStyle
              .style3, // Choose the nav bar style with this property.
        ),
      ),
    );
  }
}
