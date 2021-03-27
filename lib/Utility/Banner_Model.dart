
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BannerModel{

    String documentId;
    int id;
    String title;
    String description;
    String comments;
    String date;
    String city;
    String link;
    String color;
    var color1,color2;

    List<String> colorOptions = [
        "orange",
        "amber",
        "red",
        "cyan",
        "lightBlue",
        "blue",
        "indigo",
        "purple",
        "teal",
        "lightGreen",
        "green"
    ];

    BannerModel(this.documentId, this.id, this.title, this.description, this.comments, this.date, this.city, this.link, this.color){
        setColor();
    }
    
    static fromFirestore(DocumentSnapshot documentSnapshot){
        return new BannerModel(
                documentSnapshot.id,
                documentSnapshot.data()['id'],
                documentSnapshot.data()['title'],
                documentSnapshot.data()['description'],
                documentSnapshot.data()['comments'],
                documentSnapshot.data()['date'],
                documentSnapshot.data()['city'],
                documentSnapshot.data()['link'],
                documentSnapshot.data()['color']
        );
    }
    
    Map<String,dynamic> mapFromModel() {
        Map<String,dynamic> x = new Map();

        x['documentId'] = this.documentId;
        x['id'] = this.id;
        x['title'] = this.title;
        x['description'] = this.description;
        x['comments'] = this.comments;
        x['date'] = this.date;
        x['city'] = this.city;
        x['link'] = this.link;
        x['color'] = this.color;

        return x;
    }

    BannerModel copy(BannerModel model){
        BannerModel copyModel = new BannerModel(
                model.documentId,
                model.id,
                model.title,
                model.description,
                model.comments,
                model.date,
                model.city,
                model.link,
                model.color
        );
        return copyModel;
    }

    List<Color> getColor(String s){
        switch(s){

            case "0":
            case "orange":
                return <Color>[
                Colors.orange,
                Colors.orangeAccent,
                ];

            case "3":
            case "amber":
                return <Color>[
                Colors.amber,
                Colors.amberAccent,
                ];

            case "1":
            case "red":
                return <Color>[
                Colors.red,
                Colors.pink,
                ];

            case "10":
            case "cyan":
                return <Color>[
                Colors.cyan,
                Colors.cyanAccent,
                ];

            case "8":
            case "lightBlue":
                return <Color>[
                Colors.lightBlue,
                Colors.lightBlueAccent,
                ];

            case "2":
            case "blue":
                return <Color>[
                Colors.blueAccent,
                Colors.lightBlueAccent,
                ];

            case "5":
            case "indigo":
                return <Color>[
                Colors.indigo,
                Colors.indigoAccent,
                ];

            case "4":
            case "purple":
                return <Color>[
                Colors.deepPurple,
                Colors.deepPurpleAccent,
                ];

            case "7":
            case "teal":
                return <Color>[
                Colors.teal,
                Colors.tealAccent,
                ];

            case "9":
            case "lightGreen":
                return <Color>[
                Colors.lightGreen,
                Colors.lightGreenAccent,
                ];

            case "6":
            case "green":
                return <Color>[
                Colors.green,
                Colors.lightGreenAccent,
                ];

        }
    }

    setColor(){
        switch(color){

            case "0":
            case "orange":
                color1 = Colors.orange;
                color2 = Colors.orangeAccent;
                break;

            case "3":
            case "amber":
                color1 = Colors.amber;
                color2 = Colors.amberAccent;
                break;

            case "1":
            case "red":
                color1 = Colors.red;
                color2 = Colors.pink;
                break;

            case "10":
            case "cyan":
                color1 = Colors.cyan;
                color2 = Colors.cyanAccent;
                break;

            case "8":
            case "lightBlue":
                color1 = Colors.lightBlue;
                color2 = Colors.lightBlueAccent;
                break;

            case "2":
            case "blue":
                color1 = Colors.blueAccent;
                color2 = Colors.lightBlueAccent;
                break;

            case "5":
            case "indigo":
                color1 = Colors.indigo;
                color2 = Colors.indigoAccent;
                break;

            case "4":
            case "purple":
                color1 = Colors.deepPurple;
                color2 = Colors.deepPurpleAccent;
                break;

            case "7":
            case "teal":
                color1 = Colors.teal;
                color2 = Colors.tealAccent;
                break;

            case "9":
            case "lightGreen":
                color1 = Colors.lightGreen;
                color2 = Colors.lightGreenAccent;
                break;

            case "6":
            case "green":
                color1 = Colors.green;
                color2 = Colors.lightGreenAccent;
                break;

        }
    }

}