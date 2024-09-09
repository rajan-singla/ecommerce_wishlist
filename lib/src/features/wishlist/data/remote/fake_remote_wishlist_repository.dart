import 'package:ecommerce_app/src/features/wishlist/data/remote/remote_wishlist_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wishlist.dart';
import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';

class FakeRemoteWishlistRepository implements RemoteWishlistRepository {
  FakeRemoteWishlistRepository({this.addDelay = true});
  final bool addDelay;

  /// An InMemoryStore containing the shopping Wishlist data for all users, where:
  /// key: uid of the user
  /// value: Wishlist of that user
  final _wishlist = InMemoryStore<Map<String, Wishlist>>({});

  @override
  Future<Wishlist> fetchWishlist(String uid) {
    return Future.value(_wishlist.value[uid] ?? const Wishlist());
  }

  @override
  Stream<Wishlist> watchWishlist(String uid) {
    return _wishlist.stream
        .map((wishlistData) => wishlistData[uid] ?? const Wishlist());
  }

  @override
  Future<void> setWishlist(String uid, Wishlist wishlist) async {
    await delay(addDelay);
    // First, get the current carts data for all users
    final wishlists = _wishlist.value;
    // Then, set the Wishlist for the given uid
    wishlists[uid] = wishlist;
    // Finally, update the carts data (will emit a new value)
    _wishlist.value = wishlists;
  }
}
