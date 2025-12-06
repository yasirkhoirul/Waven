import 'package:equatable/equatable.dart';

class Addons extends Equatable{
  final String id;
  final String tittle;
  final double price;
  const Addons(this.id, this.tittle, this.price,);
  
  @override
  List<Object?> get props => [id,tittle,price];
}