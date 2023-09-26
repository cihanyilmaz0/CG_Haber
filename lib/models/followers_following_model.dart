import 'package:flutter/material.dart';

class FollowersModel extends StatelessWidget {
  final String lenght;
  final String follow;
  final Function() onTap;


  FollowersModel(this.lenght, this.follow, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        margin: EdgeInsets.all(6),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(lenght),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(follow),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
