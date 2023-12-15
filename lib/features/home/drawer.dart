import '/features/Teams/teams.dart';
import '/features/about/about.dart';
import '/features/about/team_scorer.dart';
import '/features/home/theme_controller.dart';
import '/features/login_singup/login_page.dart';
import '/features/my%20matches/create_match.dart';
import '/features/my%20matches/my%20matches.dart';
import '/features/my%20matches/virtual_coin.dart';
import '/features/user%20profile/user_profile.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get_storage/get_storage.dart';

import '../../constants.dart';

// Widget customdrawertile(title, leading, onpressed) {
//   return ListTile(
//     onTap: onpressed,
//     title: Text(title),
//     leading: Icon(
//       leading,
//       size: 25.0,
//       color: Colors.teal,
//     ),
//   );
// }

class customdrawertile extends StatelessWidget {
  final String title;
  final IconData leading;
  final VoidCallback onpressed;
  customdrawertile(this.title, this.leading, this.onpressed);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onpressed,
      title: Text(title),
      leading: Icon(
        leading,
        size: 25.0,
        color: Colors.teal,
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  final bool isloggedin;
  final String username, useremail, profilepic;
  final VoidCallback logoutfunc;
  MyDrawer(
      {super.key,
      required this.isloggedin,
      required this.username,
      required this.useremail,
      required this.profilepic,
      required this.logoutfunc});
  final match_info_box = GetStorage('Match_Info');
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20.0),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    color1,
                    color2,
                  ],
                ),
              ),
              accountName: Text(username),
              accountEmail: Text(useremail),
              currentAccountPicture: CircleAvatar(
                foregroundImage:
                    CachedNetworkImageProvider(profilepic.toString()),
                backgroundColor: Colors.teal,
                child: Icon(
                  CupertinoIcons.profile_circled,
                  size: 80.0,
                  color: Colors.white,
                ),
              ),
              currentAccountPictureSize: Size.square(80.0),
            ),
          ),
          // GetBuilder<ThemeController>(builder: (controller) {
          //   return SwitchListTile(
          //     title: Text('Dark Mode'),
          //     value: controller.isDarkMode,
          //     onChanged: (value) {
          //       print(value);
          //       print(controller.isDarkMode);
          //       controller.isDarkMode = value;
          //       controller.update();

          //       controller.changeTheme();
          //     },
          //   );
          // }),
          customdrawertile(
            'Profile',
            Icons.account_circle_rounded,
            () {
              isloggedin
                  ? Get.to(() => UserProfile())
                  : Get.to(() => LoginPage());
            },
          ),
          customdrawertile(
            'My Matches',
            Icons.today,
            () {
              isloggedin ? Get.to(() => Matches()) : Get.to(() => LoginPage());
            },
          ),
          customdrawertile(
            'My Teams',
            Icons.group,
            () {
              isloggedin
                  ? Get.to(
                      () => Teams(),
                      transition: Transition.rightToLeft,
                    )
                  : Get.to(() => LoginPage());
            },
          ),
          customdrawertile(
            'Start Match',
            Icons.arrow_right,
            () {
              match_info_box.erase();
              isloggedin
                  ? Get.to(() => CreateMatch(),
                      transition: Transition.rightToLeft,
                      arguments: {
                          // 'team_name1' : '',
                          'team_name': '',
                          'team_logo': '',
                          'team_location': '',
                          'team_id': '',
                          'team_short_name': '',
                        })
                  : Get.to(() => LoginPage());
            },
          ),
          customdrawertile(
            'Virtual Toss',
            Icons.flip,
            () {
              Get.to(() => const VirtualCoin());
            },
          ),
          isloggedin
              ? customdrawertile(
                  'Logout',
                  Icons.power_settings_new,
                  () {
                    logoutfunc();
                  },
                )
              : customdrawertile(
                  'Login',
                  Icons.power_settings_new,
                  () {
                    Get.to(() => LoginPage());
                  },
                ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // customdrawertile(
                //   'Team',
                //   Icons.group,
                //   () {
                //     Get.to(() => Team_scorer());
                //   },
                // ),
                customdrawertile(
                  'About',
                  Icons.info_outline,
                  () {
                    Get.to(() => Aboutus());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget MyDrawer(isloggedin, username, useremail, profilepic, [logout_func]) {
//   final match_info_box = GetStorage('Match_Info');
//   return 
//   Drawer(
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Container(
//           child: UserAccountsDrawerHeader(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.vertical(
//                 bottom: Radius.circular(20.0),
//               ),
//               color: Colors.teal,
//             ),
//             accountName: Text(username),
//             accountEmail: Text(useremail),
//             currentAccountPicture: CircleAvatar(
//               foregroundImage:
//                   CachedNetworkImageProvider(profilepic.toString()),
//               backgroundColor: Colors.teal,
//               child: Icon(
//                 CupertinoIcons.profile_circled,
//                 size: 80.0,
//                 color: Colors.white,
//               ),
//             ),
//             currentAccountPictureSize: Size.square(80.0),
//           ),
//         ),
//         // GetBuilder<ThemeController>(builder: (controller) {
//         //   return SwitchListTile(
//         //     title: Text('Dark Mode'),
//         //     value: controller.isDarkMode,
//         //     onChanged: (value) {
//         //       print(value);
//         //       print(controller.isDarkMode);
//         //       controller.isDarkMode = value;
//         //       controller.update();

//         //       controller.changeTheme();
//         //     },
//         //   );
//         // }),
//         customdrawertile(
//           'Profile',
//           Icons.account_circle_rounded,
//           () {
//             isloggedin
//                 ? Get.to(() => UserProfile())
//                 : Get.to(() => LoginPage());
//           },
//         ),
//         customdrawertile(
//           'My Matches',
//           Icons.today,
//           () {
//             isloggedin ? Get.to(() => Matches()) : Get.to(() => LoginPage());
//           },
//         ),
//         customdrawertile(
//           'My Teams',
//           Icons.group,
//           () {
//             isloggedin
//                 ? Get.to(
//                     () => Teams(),
//                     transition: Transition.rightToLeft,
//                   )
//                 : Get.to(() => LoginPage());
//           },
//         ),
//         customdrawertile(
//           'Start Match',
//           Icons.arrow_right,
//           () {
//             match_info_box.erase();
//             isloggedin
//                 ? Get.to(() => CreateMatch(),
//                     transition: Transition.rightToLeft,
//                     arguments: {
//                         // 'team_name1' : '',
//                         'team_name': '',
//                         'team_logo': '',
//                         'team_location': '',
//                         'team_id': '',
//                         'team_short_name': '',
//                       })
//                 : Get.to(() => LoginPage());
//           },
//         ),
//         customdrawertile(
//           'Virtual Toss',
//           Icons.flip,
//           () {
//             Get.to(() => const VirtualCoin());
//           },
//         ),
//         isloggedin
//             ? customdrawertile(
//                 'Logout',
//                 Icons.power_settings_new,
//                 () {
//                   logout_func();
//                 },
//               )
//             : customdrawertile(
//                 'Login',
//                 Icons.power_settings_new,
//                 () {
//                   Get.to(() => LoginPage());
//                 },
//               ),
//         Expanded(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               customdrawertile(
//                 'Team',
//                 Icons.group,
//                 () {
//                   Get.to(() => Team_scorer());
//                 },
//               ),
//               customdrawertile(
//                 'About',
//                 Icons.info_outline,
//                 () {
//                   Get.to(() => Aboutus());
//                 },
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );

// }
