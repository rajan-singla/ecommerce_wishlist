import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/wishlist/application/wishlist_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WishlistScreenController extends StateNotifier<AsyncValue<void>> {
  WishlistScreenController(this.wishlistService) : super(const AsyncData(null));
  final WishlistService wishlistService;

  Future<void> setWishlist(String productId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => wishlistService.setProductInWishlist(productId));
  }

  Future<void> removeWishlistItem(String productId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => wishlistService.removeProductFromWishlist(productId));
  }

  Future<void> moveWishlistItemToCart(Product product) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => wishlistService.moveWishlistItemToCartProvider(product));
  }
}

final wishlistScreenControllerProvider =
    StateNotifierProvider<WishlistScreenController, AsyncValue<void>>((ref) {
  return WishlistScreenController(ref.read(wishlistServiceProvider));
});
