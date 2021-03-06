import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class Fence extends Equatable {
  final String? id;
  final Color color;
  final String IDUser;
  final String name;
  final bool isDelete;
  final List<dynamic> latitude;
  final List<dynamic> longitude;
  final double latitudeCenter;
  final double longitudeCenter;
  final double zoom;
  final List<dynamic> ? pets;

  const Fence(
      {this.id,
      required this.IDUser,
      required this.color,
      required this.name,
        required this.isDelete,
      required this.latitude,
      required this.longitude,
        required this.latitudeCenter,
        required this.longitudeCenter,
        required this.zoom,
      this.pets});

  @override
  // TODO: implement props
  List<Object> get props => [
        {id},
        IDUser,
        color,
        name,
        latitude,
    isDelete,
        longitude,
    longitudeCenter,
    latitudeCenter,
    zoom,
    {pets},
      ];

  List<LatLng> getLatLng() {
    List<LatLng> polyline = [];
    int m = 0, n = 0;
    while(latitude.length > m) {
      while(longitude.length > n)
      {
        polyline.add(LatLng(latitude[m], longitude[n]));
        m++;
        n++;
      }
    }
    polyline.add(LatLng(latitude[0], longitude[0]));
    print(polyline);
    return polyline;
  }

  static Fence fromSnapshot(DocumentSnapshot snap) {
    Fence fence = Fence(
        id: snap.id,
        IDUser: snap['IDUser'],
        color: Color(int.parse(snap['Color'].toString())).withOpacity(1),
        name: snap['Name'],
        longitude: snap['Longitude'],
        isDelete: snap['IsDelete'],
        latitude: snap['Latitude'],
    latitudeCenter: snap['LatitudeCenter'],
    longitudeCenter: snap['LongitudeCenter'],
    zoom: snap['Zoom'],
    pets: snap['Pets']);
    return fence;
  }

  Map<String, dynamic> toMap(String Owner, List<dynamic> Pet) {
    return {
      'IDUser': Owner,
      'Name': name,
      'Color': color.value,
      'IsDelete': isDelete,
      'Latitude': latitude,
      'Longitude': longitude,
      'LatitudeCenter': latitudeCenter,
      'LongitudeCenter': longitudeCenter,
      'Zoom': zoom,
      'Pets':  FieldValue.arrayUnion([...Pet]),
    };
  }
}
