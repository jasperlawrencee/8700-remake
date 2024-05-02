import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const jPrimaryColor = Color.fromRGBO(224, 22, 61, 1);
const jSecondaryColor = Colors.white;
const jTertiaryColor = Color.fromRGBO(35, 31, 32, 1);

const defaultPadding = 16.0;

const h1 = 32.0;
const h2 = 24.0;
const h3 = 18.72;
const h4 = 16.0;
const h5 = 13.28;
const h6 = 10.72;
const p = 16.0;
const small = 13.28;
const pre = 16.0;
const code = 16.0;
const blockquote = 16.0;

final FirebaseFirestore db = FirebaseFirestore.instance;
const String jbMenuCollection = 'jollibee-menu';
