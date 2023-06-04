import 'package:flutter/material.dart';
import '../controller/homepage_controller.dart';
import 'package:encrypt_decrypt_app/core.dart';
import 'package:get/get.dart';

class HomepageView extends StatelessWidget {
  const HomepageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomepageController>(
      init: HomepageController(),
      builder: (controller) {
        controller.view = this;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Homepage"),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: const [],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {},
          ),
        );
      },
    );
  }
}
