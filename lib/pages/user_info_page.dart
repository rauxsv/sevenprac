import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sevenprac/generated/locale_keys.g.dart';

import '../model/user.dart';

class UserInfoPage extends StatelessWidget {

  final User userInfo;
  const UserInfoPage({Key? key, required this.userInfo}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.user_info.tr()),
        centerTitle: true,
      ),
      body: Card(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                userInfo.name,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(userInfo.story),
              leading: const Icon(
                Icons.person,
                color: Colors.black,
              ),
              trailing: Text(userInfo.country),
            ),
            ListTile(
              title: Text(
                userInfo.phone,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              leading: const Icon(
                Icons.phone,
                color: Colors.black,
              ),
            ),
            ListTile(
              title: Text(
                userInfo.email.isEmpty ? LocaleKeys.not_specified.tr() : userInfo.email,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              leading: const Icon(
                Icons.mail,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}