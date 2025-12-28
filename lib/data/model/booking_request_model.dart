import 'package:json_annotation/json_annotation.dart';
import 'package:waven/domain/entity/customer.dart';
import 'package:waven/domain/entity/booking.dart';
import 'package:waven/domain/entity/additional_info.dart';

part 'booking_request_model.g.dart';

@JsonSerializable()
class BookingRequestModel {
  @JsonKey(name: 'customer_data')
  final CustomerData customerData;

  @JsonKey(name: 'booking_data')
  final BookingData bookingData;

  @JsonKey(name: 'additional_data')
  final AdditionalData additionalData;

  BookingRequestModel(this.customerData, this.bookingData, this.additionalData);

  factory BookingRequestModel.fromJson(Map<String, dynamic> json) =>
      _$BookingRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookingRequestModelToJson(this);
}

@JsonSerializable()
class CustomerData {
  @JsonKey(name: 'full_name')
  final String fullName;

  @JsonKey(name: 'whatsapp_number')
  final String whatsappNumber;

  final String instagram;

  CustomerData(this.fullName, this.whatsappNumber, this.instagram);

  factory CustomerData.fromJson(Map<String, dynamic> json) =>
      _$CustomerDataFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerDataToJson(this);

  Customer toEntity() {
    return Customer(fullName, whatsappNumber, instagram);
  }
}

@JsonSerializable()
class BookingData {
  @JsonKey(name: 'package_id')
  final String packageId;

  final String date;

  @JsonKey(name: 'start_time')
  final String startTime;

  @JsonKey(name: 'end_time')
  final String endTime;

  @JsonKey(name: 'payment_method')
  final String paymentMethod;

  @JsonKey(name: 'payment_type')
  final String paymentType;

  final int amount;

  @JsonKey(name: 'addon_ids')
  final List<String> addonIds;

  BookingData(
    this.packageId,
    this.date,
    this.startTime,
    this.endTime,
    this.paymentMethod,
    this.paymentType,
    this.amount,
    this.addonIds,
  );

  factory BookingData.fromJson(Map<String, dynamic> json) =>
      _$BookingDataFromJson(json);
  Map<String, dynamic> toJson() => _$BookingDataToJson(this);

  Booking toEntity() {
    return Booking(
      packageId,
      date,
      startTime,
      endTime,
      paymentMethod,
      paymentType,
      amount,
      addonIds,
    );
  }
}

@JsonSerializable()
class AdditionalData {
  @JsonKey(name: 'university_id')
  final String universityId;

  final String location;

  final String note;
  final String platform;

  AdditionalData(this.universityId, this.location, this.note, this.platform);

  factory AdditionalData.fromJson(Map<String, dynamic> json) =>
      _$AdditionalDataFromJson(json);
  Map<String, dynamic> toJson() => _$AdditionalDataToJson(this);

  AdditionalInfo toEntity() {
    return AdditionalInfo(universityId, location, note);
  }
}
