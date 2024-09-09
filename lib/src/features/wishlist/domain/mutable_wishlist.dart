import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wishlist.dart';

extension MutableWishlist on Wishlist {
  Wishlist setProductInWishlist(ProductID productId) {
    final copy = List<ProductID>.from(wishlistProductsList);
    copy.add(productId);
    return Wishlist(copy.toSet().toList());
  }

  Wishlist setProductListInWishlist(List<ProductID> productListIds) {
    final copy = List<ProductID>.from(wishlistProductsList);
    copy.addAll(productListIds);
    return Wishlist(copy.toSet().toList());
  }

  Wishlist removeProductFromWishlist(ProductID productId) {
    final copy = List<ProductID>.from(wishlistProductsList);
    copy.remove(productId);
    return Wishlist(copy);
  }
}
