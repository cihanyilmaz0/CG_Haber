import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haber/compenents/my_textfield.dart';
import 'package:haber/models/search_model.dart';
import 'package:haber/screens/userdetail_screen.dart';
import 'package:haber/services/auth_service.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _controller = TextEditingController();
  FocusNode ? focusNode = FocusNode();
  @override
  void initState() {
    focusNode?.requestFocus();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    focusNode?.unfocus();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MySearchField(
                _controller,
                focusNode,
              (value) {
                  setState(() {

                  });
              },
            ),
            SearchModel(_controller.text)
          ],
        ),
      ),
    );
  }
}