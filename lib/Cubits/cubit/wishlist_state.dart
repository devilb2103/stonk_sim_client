part of 'wishlist_cubit.dart';

@immutable
abstract class WishlistState {
  const WishlistState();
}

class WishlistInitialState extends WishlistState {
  const WishlistInitialState();
}

class WishlistRefreshingState extends WishlistState {
  const WishlistRefreshingState();
}
