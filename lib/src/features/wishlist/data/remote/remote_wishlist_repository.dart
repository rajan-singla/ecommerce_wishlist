import 'package:ecommerce_app/src/features/wishlist/data/remote/fake_remote_wishlist_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wishlist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class RemoteWishlistRepository {
  Future<Wishlist> fetchWishlist(String uid);

  Stream<Wishlist> watchWishlist(String uid);

  Future<void> setWishlist(String uid, Wishlist wishlist);
}

final remoteWishlistRepositoryProvider = Provider<RemoteWishlistRepository>((ref) => FakeRemoteWishlistRepository());
