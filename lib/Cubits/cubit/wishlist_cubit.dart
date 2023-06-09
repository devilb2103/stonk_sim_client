import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:stonk_sim_client/account_vars.dart';
import 'package:stonk_sim_client/local_storage.dart';
import 'package:stonk_sim_client/network_vars.dart';
part 'wishlist_state.dart';

final IO.Socket socket = IO.io(
    address,
    IO.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .build());

class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit() : super(const WishlistInitialState());

  void updateWishlist() {
    emit(const WishlistRefreshingState());
    emit(const WishlistInitialState());
  }

  void addTicker(String ticker) {
    socket.emit("addTicker", {
      "tickers": [ticker.toString().toUpperCase()]
    });
  }

  void remTicker(String ticker) {
    socket.emit("remTicker", {"tickers": ticker.toString().toUpperCase()});
    wishList.remove(ticker);
    purchases.remove(ticker);
    tickerNames.remove(ticker);
    saveAppData();
    updateWishlist();
  }
}
