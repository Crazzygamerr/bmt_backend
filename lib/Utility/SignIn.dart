import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class SignIn{

    FirebaseAuth auth = FirebaseAuth.instance;

    userAuth() async{

        auth.signInWithEmailAndPassword(
                email: "admin@bmt.com",
                password: "y9ueHp3q9L3Q5dxi"
        );

    }

}