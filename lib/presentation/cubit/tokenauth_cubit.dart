import 'package:bloc/bloc.dart';
import 'package:logger/web.dart';
import 'package:meta/meta.dart';
import 'package:waven/domain/usecase/get_token.dart';
import 'package:waven/domain/usecase/post_logout.dart';

part 'tokenauth_state.dart';

class TokenauthCubit extends Cubit<TokenauthState> {
  final GetToken getToken;
  final PostLogout postLogout;
  TokenauthCubit(this.getToken, {required this.postLogout}) : super(TokenauthState());

  void getTokens()async{
    final data = await getToken.execute();
    Logger().i(data);
    emit(TokenauthState().copywith(data,''));
  }

  void onLogout()async{
    try {
      Logger().d("logout dipanggil");
      final postlogout = await postLogout.execute();

      Logger().d("logout $postlogout");
      await getToken.execute();
      emit(TokenauthState().copywith(null,''));
      
    } catch (e) {
      emit(TokenauthState().copywith(null, "eror"));
    }
  }
}
