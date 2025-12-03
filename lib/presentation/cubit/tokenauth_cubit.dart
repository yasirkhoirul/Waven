import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:waven/domain/usecase/get_token.dart';

part 'tokenauth_state.dart';

class TokenauthCubit extends Cubit<TokenauthState> {
  final GetToken getToken;
  TokenauthCubit(this.getToken) : super(TokenauthState());

  void getTokens()async{
    final data = await getToken.execute();
    emit(TokenauthState().copywith(data,''));
  }

  void logOut()async{
    try {
      final data = await getToken.executeRemoveToken();
      emit(TokenauthState().copywith(null,data));
    } catch (e) {
      emit(TokenauthState().copywith(null,e.toString()));
    }
  }

}
