import 'package:ecommerce_app/src/app.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_sync_service.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/local/sembast_cart_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/application/wishlist_sync_service.dart';
import 'package:ecommerce_app/src/features/wishlist/data/local/local_wishlist_respository.dart';
import 'package:ecommerce_app/src/features/wishlist/data/local/sembast_wishlist_repository.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore:depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // turn off the # in the URLs on the web
  usePathUrlStrategy();
  // * Register error handlers. For more info, see:
  // * https://docs.flutter.dev/testing/errors
  registerErrorHandlers();
  final localCartRepository = await SembastCartRepository.makeDefault();
  final localWishlistRepository = await SembastWishListRepository.makeDefault();
  // * Create ProviderContainer with any required overrides
  final container = ProviderContainer(
    overrides: [
      localCartRepositoryProvider.overrideWithValue(localCartRepository),
      localWishlistRepositoryProvider
          .overrideWithValue(localWishlistRepository),
    ],
  );
  // * Initialize CartSyncService to start the listener
  container.read(cartSyncServiceProvider);
  container.read(wishlistSyncServiceProvider);
  // * Entry point of the app
  runApp(UncontrolledProviderScope(
    container: container,
    child: const MyApp(),
  ));
}

void registerErrorHandlers() {
  // * Show some error UI if any uncaught exception happens
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint(details.toString());
  };
  // * Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    debugPrint(error.toString());
    return true;
  };
  // * Show some error UI when any widget in the app fails to build
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('An error occurred'.hardcoded),
      ),
      body: Center(child: Text(details.toString())),
    );
  };
}
