import 'package:ecommerce_app/src/features/wishlist/application/wishlist_service.dart';
import 'package:ecommerce_app/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Shopping cart icon with items count badge
class WishlistIcon extends ConsumerWidget {
  const WishlistIcon({super.key});

  // * Keys for testing using find.byKey()
  static const wishlistIconKey = Key('wishlist-icon');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistCount = ref.watch(wishlistItemsCountProvider);
    final isCountEmpty = wishlistCount < 1;
    return Stack(
      children: [
        Center(
          child: IconButton(
            key: wishlistIconKey,
            icon: const Icon(
              Icons.favorite,
            ),
            onPressed: () => context.goNamed(AppRoute.wishlist.name),
          ),
        ),
        if (!isCountEmpty)
          Positioned(
            top: Sizes.p4,
            right: Sizes.p4,
            child: ShoppingWishlistIconBadge(itemsCount: wishlistCount),
          ),
      ],
    );
  }
}

/// Icon badge showing the items count
class ShoppingWishlistIconBadge extends StatelessWidget {
  const ShoppingWishlistIconBadge({super.key, required this.itemsCount});
  final int itemsCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Sizes.p16,
      height: Sizes.p16,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: Text(
          '$itemsCount',
          textAlign: TextAlign.center,
          // * Force text scale factor to 1.0 irrespective of the device's
          // * textScaleFactor. This is to prevent the text from growing bigger
          // * than the available space.
          textScaler: const TextScaler.linear(1.0),
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
