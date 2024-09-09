import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/data/local/local_wishlist_respository.dart';
import 'package:ecommerce_app/src/features/wishlist/data/remote/remote_wishlist_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/mutable_wishlist.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wishlist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WishlistSyncService {
  WishlistSyncService(this.ref) {
    _init();
  }

  final Ref ref;

  void _init() {
    print('Wishlist sync service called');
    ref.listen(authStateChangesProvider, (previous, next) {
      final previousUser = previous?.value;
      final user = next.value;
      if (previousUser == null && user != null) {
        _moveItemsToRemoteWishlist(user.uid);
      }
    });
  }

  // fetch local wishlist
  // Check if the local wishlist is not empty then move to remoteWishlist
  // fetch remote wishlist
  // filter local wishlist items in remote wishlist, remove redundant values

  Future<void> _moveItemsToRemoteWishlist(String uid) async {
    try {
      // Fetching the localwishlist
      final localWishlistRepository = ref.read(localWishlistRepositoryProvider);
      final localWishlist = await localWishlistRepository.fetchWishlist();
      final localList = localWishlist.wishlistProductsList;
      // check if the wishlist is empty or not
      if (localList.isNotEmpty) {
        // fetching the remote wishlist 
        final remoteWishlistRepository =
            ref.read(remoteWishlistRepositoryProvider);
        final remoteWishlist =
            await remoteWishlistRepository.fetchWishlist(uid);
        List<String> remoteList = remoteWishlist.wishlistProductsList;
        // removing the item from localWishlist if already present in remoteWishlist
        localList.removeWhere((id) => remoteList.contains(id));
        // update the wishlist
        final updatedWishlist =
            remoteWishlist.setProductListInWishlist(localList);
        await remoteWishlistRepository.setWishlist(uid, updatedWishlist);
        await localWishlistRepository.setWishlist(const Wishlist());
      }
    } catch (e) {
      print('Errorrrrrrrrrrrr: $e');
    }
  }
}

final wishlistSyncServiceProvider = Provider((ref) => WishlistSyncService(ref));
