// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'imposter_setup_preferences_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ImposterSetupPreferencesEntity {

 List<String> get playerNames; int get imposterCount; ImposterMode get imposterMode; bool get categoryHintEnabled; bool get secretVoting; int get discussionMinutes; int get civilianWinPoints; int get imposterWinPoints;// Ids of the last-chosen packs; some may no longer exist (e.g. a deleted
// custom pack), so consumers must fall back gracefully.
 List<String> get selectedPackIds;
/// Create a copy of ImposterSetupPreferencesEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImposterSetupPreferencesEntityCopyWith<ImposterSetupPreferencesEntity> get copyWith => _$ImposterSetupPreferencesEntityCopyWithImpl<ImposterSetupPreferencesEntity>(this as ImposterSetupPreferencesEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImposterSetupPreferencesEntity&&const DeepCollectionEquality().equals(other.playerNames, playerNames)&&(identical(other.imposterCount, imposterCount) || other.imposterCount == imposterCount)&&(identical(other.imposterMode, imposterMode) || other.imposterMode == imposterMode)&&(identical(other.categoryHintEnabled, categoryHintEnabled) || other.categoryHintEnabled == categoryHintEnabled)&&(identical(other.secretVoting, secretVoting) || other.secretVoting == secretVoting)&&(identical(other.discussionMinutes, discussionMinutes) || other.discussionMinutes == discussionMinutes)&&(identical(other.civilianWinPoints, civilianWinPoints) || other.civilianWinPoints == civilianWinPoints)&&(identical(other.imposterWinPoints, imposterWinPoints) || other.imposterWinPoints == imposterWinPoints)&&const DeepCollectionEquality().equals(other.selectedPackIds, selectedPackIds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(playerNames),imposterCount,imposterMode,categoryHintEnabled,secretVoting,discussionMinutes,civilianWinPoints,imposterWinPoints,const DeepCollectionEquality().hash(selectedPackIds));

@override
String toString() {
  return 'ImposterSetupPreferencesEntity(playerNames: $playerNames, imposterCount: $imposterCount, imposterMode: $imposterMode, categoryHintEnabled: $categoryHintEnabled, secretVoting: $secretVoting, discussionMinutes: $discussionMinutes, civilianWinPoints: $civilianWinPoints, imposterWinPoints: $imposterWinPoints, selectedPackIds: $selectedPackIds)';
}


}

/// @nodoc
abstract mixin class $ImposterSetupPreferencesEntityCopyWith<$Res>  {
  factory $ImposterSetupPreferencesEntityCopyWith(ImposterSetupPreferencesEntity value, $Res Function(ImposterSetupPreferencesEntity) _then) = _$ImposterSetupPreferencesEntityCopyWithImpl;
@useResult
$Res call({
 List<String> playerNames, int imposterCount, ImposterMode imposterMode, bool categoryHintEnabled, bool secretVoting, int discussionMinutes, int civilianWinPoints, int imposterWinPoints, List<String> selectedPackIds
});




}
/// @nodoc
class _$ImposterSetupPreferencesEntityCopyWithImpl<$Res>
    implements $ImposterSetupPreferencesEntityCopyWith<$Res> {
  _$ImposterSetupPreferencesEntityCopyWithImpl(this._self, this._then);

  final ImposterSetupPreferencesEntity _self;
  final $Res Function(ImposterSetupPreferencesEntity) _then;

/// Create a copy of ImposterSetupPreferencesEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playerNames = null,Object? imposterCount = null,Object? imposterMode = null,Object? categoryHintEnabled = null,Object? secretVoting = null,Object? discussionMinutes = null,Object? civilianWinPoints = null,Object? imposterWinPoints = null,Object? selectedPackIds = null,}) {
  return _then(_self.copyWith(
playerNames: null == playerNames ? _self.playerNames : playerNames // ignore: cast_nullable_to_non_nullable
as List<String>,imposterCount: null == imposterCount ? _self.imposterCount : imposterCount // ignore: cast_nullable_to_non_nullable
as int,imposterMode: null == imposterMode ? _self.imposterMode : imposterMode // ignore: cast_nullable_to_non_nullable
as ImposterMode,categoryHintEnabled: null == categoryHintEnabled ? _self.categoryHintEnabled : categoryHintEnabled // ignore: cast_nullable_to_non_nullable
as bool,secretVoting: null == secretVoting ? _self.secretVoting : secretVoting // ignore: cast_nullable_to_non_nullable
as bool,discussionMinutes: null == discussionMinutes ? _self.discussionMinutes : discussionMinutes // ignore: cast_nullable_to_non_nullable
as int,civilianWinPoints: null == civilianWinPoints ? _self.civilianWinPoints : civilianWinPoints // ignore: cast_nullable_to_non_nullable
as int,imposterWinPoints: null == imposterWinPoints ? _self.imposterWinPoints : imposterWinPoints // ignore: cast_nullable_to_non_nullable
as int,selectedPackIds: null == selectedPackIds ? _self.selectedPackIds : selectedPackIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ImposterSetupPreferencesEntity].
extension ImposterSetupPreferencesEntityPatterns on ImposterSetupPreferencesEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImposterSetupPreferencesEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImposterSetupPreferencesEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImposterSetupPreferencesEntity value)  $default,){
final _that = this;
switch (_that) {
case _ImposterSetupPreferencesEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImposterSetupPreferencesEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ImposterSetupPreferencesEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> playerNames,  int imposterCount,  ImposterMode imposterMode,  bool categoryHintEnabled,  bool secretVoting,  int discussionMinutes,  int civilianWinPoints,  int imposterWinPoints,  List<String> selectedPackIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImposterSetupPreferencesEntity() when $default != null:
return $default(_that.playerNames,_that.imposterCount,_that.imposterMode,_that.categoryHintEnabled,_that.secretVoting,_that.discussionMinutes,_that.civilianWinPoints,_that.imposterWinPoints,_that.selectedPackIds);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> playerNames,  int imposterCount,  ImposterMode imposterMode,  bool categoryHintEnabled,  bool secretVoting,  int discussionMinutes,  int civilianWinPoints,  int imposterWinPoints,  List<String> selectedPackIds)  $default,) {final _that = this;
switch (_that) {
case _ImposterSetupPreferencesEntity():
return $default(_that.playerNames,_that.imposterCount,_that.imposterMode,_that.categoryHintEnabled,_that.secretVoting,_that.discussionMinutes,_that.civilianWinPoints,_that.imposterWinPoints,_that.selectedPackIds);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> playerNames,  int imposterCount,  ImposterMode imposterMode,  bool categoryHintEnabled,  bool secretVoting,  int discussionMinutes,  int civilianWinPoints,  int imposterWinPoints,  List<String> selectedPackIds)?  $default,) {final _that = this;
switch (_that) {
case _ImposterSetupPreferencesEntity() when $default != null:
return $default(_that.playerNames,_that.imposterCount,_that.imposterMode,_that.categoryHintEnabled,_that.secretVoting,_that.discussionMinutes,_that.civilianWinPoints,_that.imposterWinPoints,_that.selectedPackIds);case _:
  return null;

}
}

}

/// @nodoc


class _ImposterSetupPreferencesEntity implements ImposterSetupPreferencesEntity {
  const _ImposterSetupPreferencesEntity({final  List<String> playerNames = const <String>[], this.imposterCount = 1, this.imposterMode = ImposterMode.blank, this.categoryHintEnabled = false, this.secretVoting = false, this.discussionMinutes = 3, this.civilianWinPoints = 1, this.imposterWinPoints = 2, final  List<String> selectedPackIds = const <String>[]}): _playerNames = playerNames,_selectedPackIds = selectedPackIds;
  

 final  List<String> _playerNames;
@override@JsonKey() List<String> get playerNames {
  if (_playerNames is EqualUnmodifiableListView) return _playerNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_playerNames);
}

@override@JsonKey() final  int imposterCount;
@override@JsonKey() final  ImposterMode imposterMode;
@override@JsonKey() final  bool categoryHintEnabled;
@override@JsonKey() final  bool secretVoting;
@override@JsonKey() final  int discussionMinutes;
@override@JsonKey() final  int civilianWinPoints;
@override@JsonKey() final  int imposterWinPoints;
// Ids of the last-chosen packs; some may no longer exist (e.g. a deleted
// custom pack), so consumers must fall back gracefully.
 final  List<String> _selectedPackIds;
// Ids of the last-chosen packs; some may no longer exist (e.g. a deleted
// custom pack), so consumers must fall back gracefully.
@override@JsonKey() List<String> get selectedPackIds {
  if (_selectedPackIds is EqualUnmodifiableListView) return _selectedPackIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedPackIds);
}


/// Create a copy of ImposterSetupPreferencesEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImposterSetupPreferencesEntityCopyWith<_ImposterSetupPreferencesEntity> get copyWith => __$ImposterSetupPreferencesEntityCopyWithImpl<_ImposterSetupPreferencesEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImposterSetupPreferencesEntity&&const DeepCollectionEquality().equals(other._playerNames, _playerNames)&&(identical(other.imposterCount, imposterCount) || other.imposterCount == imposterCount)&&(identical(other.imposterMode, imposterMode) || other.imposterMode == imposterMode)&&(identical(other.categoryHintEnabled, categoryHintEnabled) || other.categoryHintEnabled == categoryHintEnabled)&&(identical(other.secretVoting, secretVoting) || other.secretVoting == secretVoting)&&(identical(other.discussionMinutes, discussionMinutes) || other.discussionMinutes == discussionMinutes)&&(identical(other.civilianWinPoints, civilianWinPoints) || other.civilianWinPoints == civilianWinPoints)&&(identical(other.imposterWinPoints, imposterWinPoints) || other.imposterWinPoints == imposterWinPoints)&&const DeepCollectionEquality().equals(other._selectedPackIds, _selectedPackIds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_playerNames),imposterCount,imposterMode,categoryHintEnabled,secretVoting,discussionMinutes,civilianWinPoints,imposterWinPoints,const DeepCollectionEquality().hash(_selectedPackIds));

@override
String toString() {
  return 'ImposterSetupPreferencesEntity(playerNames: $playerNames, imposterCount: $imposterCount, imposterMode: $imposterMode, categoryHintEnabled: $categoryHintEnabled, secretVoting: $secretVoting, discussionMinutes: $discussionMinutes, civilianWinPoints: $civilianWinPoints, imposterWinPoints: $imposterWinPoints, selectedPackIds: $selectedPackIds)';
}


}

/// @nodoc
abstract mixin class _$ImposterSetupPreferencesEntityCopyWith<$Res> implements $ImposterSetupPreferencesEntityCopyWith<$Res> {
  factory _$ImposterSetupPreferencesEntityCopyWith(_ImposterSetupPreferencesEntity value, $Res Function(_ImposterSetupPreferencesEntity) _then) = __$ImposterSetupPreferencesEntityCopyWithImpl;
@override @useResult
$Res call({
 List<String> playerNames, int imposterCount, ImposterMode imposterMode, bool categoryHintEnabled, bool secretVoting, int discussionMinutes, int civilianWinPoints, int imposterWinPoints, List<String> selectedPackIds
});




}
/// @nodoc
class __$ImposterSetupPreferencesEntityCopyWithImpl<$Res>
    implements _$ImposterSetupPreferencesEntityCopyWith<$Res> {
  __$ImposterSetupPreferencesEntityCopyWithImpl(this._self, this._then);

  final _ImposterSetupPreferencesEntity _self;
  final $Res Function(_ImposterSetupPreferencesEntity) _then;

/// Create a copy of ImposterSetupPreferencesEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playerNames = null,Object? imposterCount = null,Object? imposterMode = null,Object? categoryHintEnabled = null,Object? secretVoting = null,Object? discussionMinutes = null,Object? civilianWinPoints = null,Object? imposterWinPoints = null,Object? selectedPackIds = null,}) {
  return _then(_ImposterSetupPreferencesEntity(
playerNames: null == playerNames ? _self._playerNames : playerNames // ignore: cast_nullable_to_non_nullable
as List<String>,imposterCount: null == imposterCount ? _self.imposterCount : imposterCount // ignore: cast_nullable_to_non_nullable
as int,imposterMode: null == imposterMode ? _self.imposterMode : imposterMode // ignore: cast_nullable_to_non_nullable
as ImposterMode,categoryHintEnabled: null == categoryHintEnabled ? _self.categoryHintEnabled : categoryHintEnabled // ignore: cast_nullable_to_non_nullable
as bool,secretVoting: null == secretVoting ? _self.secretVoting : secretVoting // ignore: cast_nullable_to_non_nullable
as bool,discussionMinutes: null == discussionMinutes ? _self.discussionMinutes : discussionMinutes // ignore: cast_nullable_to_non_nullable
as int,civilianWinPoints: null == civilianWinPoints ? _self.civilianWinPoints : civilianWinPoints // ignore: cast_nullable_to_non_nullable
as int,imposterWinPoints: null == imposterWinPoints ? _self.imposterWinPoints : imposterWinPoints // ignore: cast_nullable_to_non_nullable
as int,selectedPackIds: null == selectedPackIds ? _self._selectedPackIds : selectedPackIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
