import 'package:json_annotation/json_annotation.dart';
import 'package:waven/domain/entity/detail_package.dart';
part 'detailportomodel.g.dart';

@JsonSerializable()
class DetailPortoModel {
  final String message;
  final DataDetailPortoModel data;
  DetailPortoModel(this.message, this.data);
  factory DetailPortoModel.fromJson(Map<String, dynamic> json) =>
      _$DetailPortoModelFromJson(json);

  DetailPackageEntity toEntity(DataDetailPortoModel data) {
    return DetailPackageEntity(
      id: data.id,
      title: data.title,
      price: data.price,
      bannerUrl: data.banner_url,
      description: data.description,
      benefits: data.benefits,
    );
  }
}

@JsonSerializable()
class DataDetailPortoModel {
  final String id;
  final String title;
  final double price;
  final String banner_url;
  final String description;
  final List<Benefits> benefits;
  DataDetailPortoModel({
    required this.id,
    required this.title,
    required this.price,
    required this.banner_url,
    required this.description,
    required this.benefits,
  });
  factory DataDetailPortoModel.fromJson(Map<String, dynamic> json) =>
      _$DataDetailPortoModelFromJson(json);
}

@JsonSerializable()
class Benefits {
  final String id;
  final String description;
  final String type;
  Benefits({required this.id, required this.description, required this.type});

  factory Benefits.fromJson(Map<String, dynamic> json) =>
      _$BenefitsFromJson(json);
}
