import 'package:waven/data/model/detailportomodel.dart';

class DetailPackageEntity {
  final String id;
  final String title;
  final double price;
  final String bannerUrl;
  final String description;
  final List<Benefits> benefits;
  DetailPackageEntity({required this.id, required this.title, required this.price, required this.bannerUrl, required this.description, required this.benefits});
}