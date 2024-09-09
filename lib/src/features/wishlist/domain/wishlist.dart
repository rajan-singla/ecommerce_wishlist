// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:ecommerce_app/src/features/products/domain/product.dart';

class Wishlist {
  const Wishlist([this.wishlistProductsList = const []]);

  final List<ProductID> wishlistProductsList;

  // Convert a Wishlist object to a Map
  Map<String, dynamic> toMap() {
    return {
      'wishlistProductsList': wishlistProductsList,
    };
  }

  // Create a Wishlist object from a Map
  factory Wishlist.fromMap(Map<String, dynamic> map) {
    return Wishlist(
      List<String>.from(map['wishlistProductsList'] ?? []),
    );
  }

  // Convert a Wishlist object to a JSON string
  String toJson() => json.encode(toMap());

  // Create a Wishlist object from a JSON string
  factory Wishlist.fromJson(String source) => Wishlist.fromMap(json.decode(source));
}