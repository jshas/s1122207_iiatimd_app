// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map<String, dynamic> json) => Activity(
      id: json['id'] as String,
      title: json['title'] as String,
      duration: $enumDecode(_$ActivityDurationEnumMap, json['duration']),
      description: json['description'] as String,
    );

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'duration': _$ActivityDurationEnumMap[instance.duration]!,
      'description': instance.description,
    };

const _$ActivityDurationEnumMap = {
  ActivityDuration.short: 'short',
  ActivityDuration.medium: 'medium',
  ActivityDuration.long: 'long',
};
