import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt_decrypt_app/module/shared/show_info_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:encrypt_decrypt_app/state_util.dart';
import '../view/register_view.dart';

class RegisterController extends State<RegisterView> implements MvcController {
  static late RegisterController instance;
  late RegisterView view;

  @override
  void initState() {
    instance = this;
    super.initState();
  }

  @override
  void dispose() => super.dispose();

  @override
  Widget build(BuildContext context) => widget.build(context, this);

  String? email;
  String? password;

  doRegister() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      showInfoDialog("Register Success!");
      Get.back();
    } on Exception catch (err) {
      showInfoDialog("Register failed!");
    }
  }
}
