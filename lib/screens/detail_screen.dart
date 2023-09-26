import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haber/compenents/my_button.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

class DetailScreen extends StatefulWidget {
  final String url;


  DetailScreen(this.url);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late WebViewController controller;
  @override
  void initState() {
    super.initState();
    controller= WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CG Haber",style: GoogleFonts.oswald()),
        centerTitle: true,
        toolbarHeight: 65,
        leading: MyIconButton(
          icon: Icon(Icons.arrow_back_ios_sharp),
          onTap: () {
            Get.back();
          },
        ),
        actions: [
          MyIconButton(
            icon: Icon(Icons.refresh),
            onTap: () {
              controller.reload();
            },
          )
        ],
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
