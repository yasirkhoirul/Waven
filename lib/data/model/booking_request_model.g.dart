// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingRequestModel _$BookingRequestModelFromJson(Map<String, dynamic> json) =>
    BookingRequestModel(
      CustomerData.fromJson(json['customer_data'] as Map<String, dynamic>),
      BookingData.fromJson(json['booking_data'] as Map<String, dynamic>),
      AdditionalData.fromJson(json['additional_data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BookingRequestModelToJson(
  BookingRequestModel instance,
) => <String, dynamic>{
  'customer_data': instance.customerData,
  'booking_data': instance.bookingData,
  'additional_data': instance.additionalData,
};

CustomerData _$CustomerDataFromJson(Map<String, dynamic> json) => CustomerData(
  json['full_name'] as String,
  json['whatsapp_number'] as String,
  json['instagram'] as String,
);

Map<String, dynamic> _$CustomerDataToJson(CustomerData instance) =>
    <String, dynamic>{
      'full_name': instance.fullName,
      'whatsapp_number': instance.whatsappNumber,
      'instagram': instance.instagram,
    };

BookingData _$BookingDataFromJson(Map<String, dynamic> json) => BookingData(
  json['package_id'] as String,
  json['date'] as String,
  json['start_time'] as String,
  json['end_time'] as String,
  json['payment_method'] as String,
  json['payment_type'] as String,
  (json['amount'] as num).toInt(),
  (json['addon_ids'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$BookingDataToJson(BookingData instance) =>
    <String, dynamic>{
      'package_id': instance.packageId,
      'date': instance.date,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'payment_method': instance.paymentMethod,
      'payment_type': instance.paymentType,
      'amount': instance.amount,
      'addon_ids': instance.addonIds,
    };

AdditionalData _$AdditionalDataFromJson(Map<String, dynamic> json) =>
    AdditionalData(
      json['university_id'] as String,
      json['location'] as String,
      json['note'] as String,
    );

Map<String, dynamic> _$AdditionalDataToJson(AdditionalData instance) =>
    <String, dynamic>{
      'university_id': instance.universityId,
      'location': instance.location,
      'note': instance.note,
    };
