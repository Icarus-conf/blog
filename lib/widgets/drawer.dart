import 'package:blog/components/list_tile.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final Function()? onProfileTap;
  final Function()? onLogOutTap;
  const CustomDrawer({
    super.key,
    required this.onLogOutTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const DrawerHeader(
                  child: Icon(
                Icons.person,
                color: Colors.white,
                size: 50,
              )),
              MyListTile(
                icon: Icons.home,
                text: 'HOME',
                onTap: () => Navigator.pop(context),
              ),
              MyListTile(
                icon: Icons.person,
                text: 'Profile',
                onTap: onProfileTap,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: MyListTile(
              icon: Icons.logout,
              text: 'Logout',
              onTap: onLogOutTap,
            ),
          ),
        ],
      ),
    );
  }
}
