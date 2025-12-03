part of 'tokenauth_cubit.dart';

@immutable
class TokenauthState {
  final String? tokens;
  final String message;
  const TokenauthState({this.tokens, this.message = ''});

  TokenauthState copywith(String? data, String message) {
    return TokenauthState(tokens: data ?? tokens, message: message);
  }
}
