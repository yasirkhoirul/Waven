import 'package:equatable/equatable.dart';

class PackageEntity extends Equatable{
  final String id;
  final String tittle;
  final double price;
  final String bannerUrl;
  final String description;
  const PackageEntity({ required this.id, required this.tittle, required this.price, required this.bannerUrl, required this.description});
  
  @override
  List<Object?> get props => [id,tittle,price,bannerUrl,description];
}