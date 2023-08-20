// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map<String, dynamic> json) => Activity(
      id: json['id'] as String?,
      name: json['name'] as String,
      duration: $enumDecode(_$ActivityDurationEnumMap, json['duration']),
      description: json['description'] as String,
      uid: json['uid'] as String,
      protected: json['protected'] as bool,
    );

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'duration': _$ActivityDurationEnumMap[instance.duration]!,
      'description': instance.description,
      'uid': instance.uid,
      'protected': instance.protected,
    };

const _$ActivityDurationEnumMap = {
  ActivityDuration.short: 'short',
  ActivityDuration.medium: 'medium',
  ActivityDuration.long: 'long',
};
