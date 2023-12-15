import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

Widget custompopup(_icon, _title,_ontap,_icon1,_title1, _ontap1) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: PopupMenuButton(
        // onSelected: _onselected,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          offset: Offset(0, 50),
          
          itemBuilder: (context) => [
                PopupMenuItem(
                  padding: EdgeInsets.only(right: 4),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          _icon,
                          size: 26,
                          color: Colors.grey[600]),
                        title: Text(
                          _title,
                          style: TextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                        ),
                        onTap: _ontap,
                      ),
                       ListTile(
                        leading: Icon(
                          _icon1,
                          size: 24,
                          color: Colors.red[600],),
                        title: Text(
                          _title1,
                          style: TextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.w600,
                            color: Colors.red[600]),
                        ),
                        onTap: _ontap1,
                      ),
                    ],
                  ),
                ),
              ]),
    );
  }
