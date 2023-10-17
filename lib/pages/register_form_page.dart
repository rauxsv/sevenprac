import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sevenprac/generated/locale_keys.g.dart';

import '../model/user.dart';
import 'user_info_page.dart';

class RegisterFormPage extends StatefulWidget {
  const RegisterFormPage({super.key});

  @override
  State<RegisterFormPage> createState() => _RegisterFormPageState();
}

class _RegisterFormPageState extends State<RegisterFormPage> {
  bool _hidePass = true;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _storyController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  final List<String> _countries = [LocaleKeys.russia.tr(), LocaleKeys.ukraine.tr(), LocaleKeys.germany.tr(), LocaleKeys.france.tr()];
  String _selectedCountry = LocaleKeys.russia.tr();

  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passFocus = FocusNode();


  
  User newUser = User();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _storyController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(LocaleKeys.register_form.tr()),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              focusNode: _nameFocus,
              autofocus: true,
              onFieldSubmitted: (_) {
                _fieldFocusChange(context, _nameFocus, _phoneFocus);
              },
              controller: _nameController,
              decoration: InputDecoration(
                labelText: LocaleKeys.full_name.tr(),
                hintText: LocaleKeys.what_do_people_call_you.tr(),
                prefixIcon: const Icon(Icons.person),
                suffixIcon: GestureDetector(
                  onTap: () {
                    _nameController.clear();
                  },
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
              ),
              validator: validateName,
              onSaved: (value) => newUser.name = value!,
            ),
            const SizedBox(height: 10),
            TextFormField(
              focusNode: _phoneFocus,
              onFieldSubmitted: (_) {
                _fieldFocusChange(context, _phoneFocus, _passFocus);
              },
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: LocaleKeys.phone_number.tr(),
                hintText: LocaleKeys.where_can_we_reach_you.tr(),
                helperText: LocaleKeys.enter_phone_format.tr(),
                prefixIcon: const Icon(Icons.call),
                suffixIcon: GestureDetector(
                  onLongPress: () {
                    _phoneController.clear();
                  },
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                // FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter(RegExp(r'^[()\d -]{1,15}$'),
                    allow: true),
              ],
              validator: (value) => validatePhoneNumber(value!)
                  ? null
                  : LocaleKeys.phone_number_format_hint.tr(),
              onSaved: (value) => newUser.phone = value!,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: LocaleKeys.email_address.tr(),
                hintText: LocaleKeys.enter_email_address.tr(),
                icon: Icon(Icons.mail),
              ),
              keyboardType: TextInputType.emailAddress,
              // validator: _validateEmail,
              onSaved: (value) => newUser.email = value!,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.map),
                  labelText: LocaleKeys.country.tr()),
              items: _countries.map((country) {
                return DropdownMenuItem(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
              onChanged: (country) {
                setState(() {
                  _selectedCountry = country as String;
                  newUser.country = country;
                });
              },
              value: _selectedCountry,
              // validator: (val) {
              //   return val == null ? 'Please select a country' : null;
              // },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _storyController,
              decoration: InputDecoration(
                labelText: LocaleKeys.life_story.tr(),
                hintText: LocaleKeys.tell_us_about_yourself.tr(),
                helperText: LocaleKeys.keep_it_short.tr(),
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              inputFormatters: [
                LengthLimitingTextInputFormatter(100),
              ],
              onSaved: (value) => newUser.story = value!,
            ),
            const SizedBox(height: 10),
            TextFormField(
              focusNode: _passFocus,
              controller: _passController,
              obscureText: _hidePass,
              maxLength: 8,
              decoration: InputDecoration(
                labelText: LocaleKeys.password.tr(),
                hintText: LocaleKeys.enter_password.tr(),
                suffixIcon: IconButton(
                  icon:
                      Icon(_hidePass ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _hidePass = !_hidePass;
                    });
                  },
                ),
                icon: const Icon(Icons.security),
              ),
              validator: _validatePassword,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _confirmPassController,
              obscureText: _hidePass,
              maxLength: 8,
              decoration: InputDecoration(
                labelText: LocaleKeys.confirm_password.tr(),
                hintText: LocaleKeys.confirm_password_hint.tr(),
                icon: Icon(Icons.border_color),
              ),
              validator: _validatePassword,
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                textStyle: const TextStyle(color: Colors.white),
              ),
              child: Text(LocaleKeys.hello.tr()),
              //color: Colors.green,
            ),
            ElevatedButton(
              onPressed: ()async{
                await context.setLocale(Locale('ru'));
              },
              child: const Text('RU'),
              //color: Colors.green,
            ),
            ElevatedButton(
              onPressed: ()async{
                await context.setLocale(Locale('kk'));
              },
              child: const Text('KZ'),
              //color: Colors.green,
            ),
            ElevatedButton(
              onPressed: ()async{
                await context.setLocale(Locale('en'));
              },
              child: const Text('EN'),
              //color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _showDialog(name: _nameController.text);
      log('${LocaleKeys.name.tr()} ${_nameController.text}');
      log('${LocaleKeys.phone.tr()} ${_phoneController.text}');
      log('${LocaleKeys.email.tr()} ${_emailController.text}');
      log('${LocaleKeys.country.tr()} $_selectedCountry');
      log('${LocaleKeys.life_story.tr()} ${_storyController.text}');
  } else {
      _showMessage(message: LocaleKeys.form_not_valid.tr());
    }
  }

  String? validateName(String? value) {
    final nameExp = RegExp(r'^[A-Za-zА-Яа-яЁё ]+$');
    if (value == null) {
      return LocaleKeys.name_required.tr();
    } else if (!nameExp.hasMatch(value)) {
      return LocaleKeys.enter_alphabetical_characters.tr();
    } else {
      return null;
    }
  }

  bool validatePhoneNumber(String input) {
    final phoneExp = RegExp(r'^\(\d\d\d\)\d\d\d\-\d\d\d\d$');
    return phoneExp.hasMatch(input);
  }

  String? validateEmail(String? value) {
    if (value == null) {
      return LocaleKeys.email_empty.tr();
    } else if (!_emailController.text.contains('@')) {
      return LocaleKeys.invalid_email.tr();
    } else {
      return null;
    }
  }

  String? _validatePassword(String? value) {
    if (_passController.text.length != 8) {
      return LocaleKeys.eight_character_required.tr();
    } else if (_confirmPassController.text != _passController.text) {
      return LocaleKeys.password_mismatch.tr();
    } else {
      return null;
    }
  }

  void _showMessage({required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.red,
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18.0,
          ),
        ),
      ),
    );
    // До Flutter 2.0
    // _scaffoldKey.currentState.showSnackBar(
    //   SnackBar(
    //     duration: Duration(seconds: 5),
    //     backgroundColor: Colors.red,
    //     content: Text(
    //       message,
    //       style: TextStyle(
    //         color: Colors.black,
    //         fontWeight: FontWeight.w600,
    //         fontSize: 18.0,
    //       ),
    //     ),
    //   ),
    // );
  }

  void _showDialog({required String name}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            LocaleKeys.registration_successful.tr(),
            style: TextStyle(
              color: Colors.green,
            ),
          ),
          content: Text(
            '$name ${LocaleKeys.verified_register_form.tr()}',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18.0,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserInfoPage(
                      userInfo: newUser,
                    ),
                  ),
                );
              },
              child: Text(
                LocaleKeys.verified.tr(),
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
