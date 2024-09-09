import 'package:ecommerce_app/src/features/wishlist/data/local/local_wishlist_respository.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wishlist.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

class SembastWishListRepository implements LocalWishlistRepository {
  SembastWishListRepository(this.db);
  final Database db;
  final store = StoreRef.main();

  static Future<Database> openDatabase() async {
    const fileName = 'default.db';
    if (kIsWeb) {
      return databaseFactoryWeb.openDatabase(fileName);
    } else {
      final appDocDir = await getApplicationDocumentsDirectory();
      return databaseFactoryIo.openDatabase('${appDocDir.path}/$fileName');
    }
  }

  static Future<SembastWishListRepository> makeDefault() async {
    return SembastWishListRepository(await openDatabase());
  }

  static const wishlistItemsKey = 'whishlistItems';

  @override
  Future<Wishlist> fetchWishlist() async {
    final wishlistJson =
        await store.record(wishlistItemsKey).get(db) as String?;
    if (wishlistJson != null) {
      return Wishlist.fromJson(wishlistJson);
    } else {
      return const Wishlist();
    }
  }

  @override
  Future<void> setWishlist(Wishlist wishlist) {
    return store.record(wishlistItemsKey).put(db, wishlist.toJson());
  }

  @override
  Stream<Wishlist> watchWishlist() {
    final record = store.record(wishlistItemsKey);
    return record.onSnapshot(db).map((snapshot) {
      if (snapshot != null) {
        return Wishlist.fromJson(snapshot.value as String);
      } else {
        return const Wishlist();
      }
    });
  }
}
