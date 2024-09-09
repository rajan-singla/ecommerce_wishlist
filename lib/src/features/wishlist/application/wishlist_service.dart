import 'dart:math';

import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/wishlist/data/local/local_wishlist_respository.dart';
import 'package:ecommerce_app/src/features/wishlist/data/remote/remote_wishlist_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/mutable_wishlist.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wishlist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WishlistService {
  WishlistService(this.ref);
  final Ref ref;

  Future<Wishlist> _fetchWishlist() async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      final remoteRepo = ref.read(remoteWishlistRepositoryProvider);
      return remoteRepo.fetchWishlist(user.uid);
    } else {
      final localRepo = ref.read(localWishlistRepositoryProvider);
      return localRepo.fetchWishlist();
    }
  }

  Future<void> _setWishlist(Wishlist wishlist) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      await ref
          .read(remoteWishlistRepositoryProvider)
          .setWishlist(user.uid, wishlist);
    } else {
      await ref.read(localWishlistRepositoryProvider).setWishlist(wishlist);
    }
  }

  Future<void> setProductInWishlist(ProductID productId) async {
    final wishlist = await _fetchWishlist();
    final updated = wishlist.setProductInWishlist(productId);
    await _setWishlist(updated);
  }

  Future<void> removeProductFromWishlist(ProductID productId) async {
    final wishlist = await _fetchWishlist();
    final updated = wishlist.removeProductFromWishlist(productId);
    await _setWishlist(updated);
  }

  /// Function used to move the product from wishlist to shopping cart
  Future<void> moveWishlistItemToCartProvider(Product product) async {
    // Fetch the cart service provider
    final cartService = ref.read(cartServiceProvider);
    // Fetch cart provider to get the cart list
    final cartList = ref.read(cartProvider).value ?? const Cart();
    // Check if the wish listed item already present in the cart or not,
    // if not present add the item with quantity 1.
    final item = cartList.toItemsList().firstWhere(
        (item) => item.productId == product.id,
        orElse: () => Item(productId: product.id, quantity: 1));
    // if item already present in the cart set the quantity of the product accordingly
    final quantity = min(1, product.availableQuantity - item.quantity);
    // If quantity is 0 which means the item is out of stock
    if (quantity != 0) {
      // update the cartItem
      final updatedCartItem = Item(productId: product.id, quantity: quantity);
      await cartService.addItem(updatedCartItem);
      // Remove  the item from the wishlist after successfully moved item from the wishlist to cart
      await removeProductFromWishlist(product.id);
    } else {
      throw 'The product is out of stock.';
    }
  }
}

final wishlistServiceProvider = Provider<WishlistService>((ref) {
  return WishlistService(ref);
});

final wishlistProvider = StreamProvider<Wishlist>((ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user != null) {
    return ref.watch(remoteWishlistRepositoryProvider).watchWishlist(user.uid);
  } else {
    return ref.watch(localWishlistRepositoryProvider).watchWishlist();
  }
});

final wishlistItemsCountProvider = Provider<int>((ref) {
  return ref.watch(wishlistProvider).maybeMap(
        data: (data) => data.value.wishlistProductsList.length,
        orElse: () => 0,
      );
});
