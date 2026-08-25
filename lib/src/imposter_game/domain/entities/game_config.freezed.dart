// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GameConfig {

/// The word packs rounds draw their secret word from. When more than one
/// is selected, the word is chosen across all of them and the category
/// hint (if enabled) reflects the chosen word's own pack.
 List<WordPack> get packs;/// How many imposters are dealt in each round. Must satisfy
/// `1 <= imposterCount < playerCount`.
 int get imposterCount;/// What the imposter receives at reveal (nothing vs. a decoy word).
 ImposterMode get imposterMode;/// When true, imposters are told the chosen word's category as a hint.
 bool get categoryHintEnabled;/// When true, voting is a pass-and-play secret ballot (each player casts
/// privately, then the votes are tallied). When false, the group casts
/// one shared vote on the device.
 bool get secretVoting; Duration get discussionTime;/// Points awarded to each member of the winning side.
 int get civilianWinPoints; int get imposterWinPoints;
/// Create a copy of GameConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameConfigCopyWith<GameConfig> get copyWith => _$GameConfigCopyWithImpl<GameConfig>(this as GameConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameConfig&&const DeepCollectionEquality().equals(other.packs, packs)&&(identical(other.imposterCount, imposterCount) || other.imposterCount == imposterCount)&&(identical(other.imposterMode, imposterMode) || other.imposterMode == imposterMode)&&(identical(other.categoryHintEnabled, categoryHintEnabled) || other.categoryHintEnabled == categoryHintEnabled)&&(identical(other.secretVoting, secretVoting) || other.secretVoting == secretVoting)&&(identical(other.discussionTime, discussionTime) || other.discussionTime == discussionTime)&&(identical(other.civilianWinPoints, civilianWinPoints) || other.civilianWinPoints == civilianWinPoints)&&(identical(other.imposterWinPoints, imposterWinPoints) || other.imposterWinPoints == imposterWinPoints));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(packs),imposterCount,imposterMode,categoryHintEnabled,secretVoting,discussionTime,civilianWinPoints,imposterWinPoints);

@override
String toString() {
  return 'GameConfig(packs: $packs, imposterCount: $imposterCount, imposterMode: $imposterMode, categoryHintEnabled: $categoryHintEnabled, secretVoting: $secretVoting, discussionTime: $discussionTime, civilianWinPoints: $civilianWinPoints, imposterWinPoints: $imposterWinPoints)';
}


}

/// @nodoc
abstract mixin class $GameConfigCopyWith<$Res>  {
  factory $GameConfigCopyWith(GameConfig value, $Res Function(GameConfig) _then) = _$GameConfigCopyWithImpl;
@useResult
$Res call({
 List<WordPack> packs, int imposterCount, ImposterMode imposterMode, bool categoryHintEnabled, bool secretVoting, Duration discussionTime, int civilianWinPoints, int imposterWinPoints
});




}
/// @nodoc
class _$GameConfigCopyWithImpl<$Res>
    implements $GameConfigCopyWith<$Res> {
  _$GameConfigCopyWithImpl(this._self, this._then);

  final GameConfig _self;
  final $Res Function(GameConfig) _then;

/// Create a copy of GameConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? packs = null,Object? imposterCount = null,Object? imposterMode = null,Object? categoryHintEnabled = null,Object? secretVoting = null,Object? discussionTime = null,Object? civilianWinPoints = null,Object? imposterWinPoints = null,}) {
  return _then(_self.copyWith(
packs: null == packs ? _self.packs : packs // ignore: cast_nullable_to_non_nullable
as List<WordPack>,imposterCount: null == imposterCount ? _self.imposterCount : imposterCount // ignore: cast_nullable_to_non_nullable
as int,imposterMode: null == imposterMode ? _self.imposterMode : imposterMode // ignore: cast_nullable_to_non_nullable
as ImposterMode,categoryHintEnabled: null == categoryHintEnabled ? _self.categoryHintEnabled : categoryHintEnabled // ignore: cast_nullable_to_non_nullable
as bool,secretVoting: null == secretVoting ? _self.secretVoting : secretVoting // ignore: cast_nullable_to_non_nullable
as bool,discussionTime: null == discussionTime ? _self.discussionTime : discussionTime // ignore: cast_nullable_to_non_nullable
as Duration,civilianWinPoints: null == civilianWinPoints ? _self.civilianWinPoints : civilianWinPoints // ignore: cast_nullable_to_non_nullable
as int,imposterWinPoints: null == imposterWinPoints ? _self.imposterWinPoints : imposterWinPoints // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [GameConfig].
extension GameConfigPatterns on GameConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameConfig value)  $default,){
final _that = this;
switch (_that) {
case _GameConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameConfig value)?  $default,){
final _that = this;
switch (_that) {
case _GameConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<WordPack> packs,  int imposterCount,  ImposterMode imposterMode,  bool categoryHintEnabled,  bool secretVoting,  Duration discussionTime,  int civilianWinPoints,  int imposterWinPoints)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameConfig() when $default != null:
return $default(_that.packs,_that.imposterCount,_that.imposterMode,_that.categoryHintEnabled,_that.secretVoting,_that.discussionTime,_that.civilianWinPoints,_that.imposterWinPoints);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<WordPack> packs,  int imposterCount,  ImposterMode imposterMode,  bool categoryHintEnabled,  bool secretVoting,  Duration discussionTime,  int civilianWinPoints,  int imposterWinPoints)  $default,) {final _that = this;
switch (_that) {
case _GameConfig():
return $default(_that.packs,_that.imposterCount,_that.imposterMode,_that.categoryHintEnabled,_that.secretVoting,_that.discussionTime,_that.civilianWinPoints,_that.imposterWinPoints);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<WordPack> packs,  int imposterCount,  ImposterMode imposterMode,  bool categoryHintEnabled,  bool secretVoting,  Duration discussionTime,  int civilianWinPoints,  int imposterWinPoints)?  $default,) {final _that = this;
switch (_that) {
case _GameConfig() when $default != null:
return $default(_that.packs,_that.imposterCount,_that.imposterMode,_that.categoryHintEnabled,_that.secretVoting,_that.discussionTime,_that.civilianWinPoints,_that.imposterWinPoints);case _:
  return null;

}
}

}

/// @nodoc


class _GameConfig extends GameConfig {
  const _GameConfig({required final  List<WordPack> packs, this.imposterCount = 1, this.imposterMode = ImposterMode.blank, this.categoryHintEnabled = false, this.secretVoting = false, this.discussionTime = const Duration(minutes: 3), this.civilianWinPoints = 1, this.imposterWinPoints = 2}): _packs = packs,super._();
  

/// The word packs rounds draw their secret word from. When more than one
/// is selected, the word is chosen across all of them and the category
/// hint (if enabled) reflects the chosen word's own pack.
 final  List<WordPack> _packs;
/// The word packs rounds draw their secret word from. When more than one
/// is selected, the word is chosen across all of them and the category
/// hint (if enabled) reflects the chosen word's own pack.
@override List<WordPack> get packs {
  if (_packs is EqualUnmodifiableListView) return _packs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_packs);
}

/// How many imposters are dealt in each round. Must satisfy
/// `1 <= imposterCount < playerCount`.
@override@JsonKey() final  int imposterCount;
/// What the imposter receives at reveal (nothing vs. a decoy word).
@override@JsonKey() final  ImposterMode imposterMode;
/// When true, imposters are told the chosen word's category as a hint.
@override@JsonKey() final  bool categoryHintEnabled;
/// When true, voting is a pass-and-play secret ballot (each player casts
/// privately, then the votes are tallied). When false, the group casts
/// one shared vote on the device.
@override@JsonKey() final  bool secretVoting;
@override@JsonKey() final  Duration discussionTime;
/// Points awarded to each member of the winning side.
@override@JsonKey() final  int civilianWinPoints;
@override@JsonKey() final  int imposterWinPoints;

/// Create a copy of GameConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameConfigCopyWith<_GameConfig> get copyWith => __$GameConfigCopyWithImpl<_GameConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameConfig&&const DeepCollectionEquality().equals(other._packs, _packs)&&(identical(other.imposterCount, imposterCount) || other.imposterCount == imposterCount)&&(identical(other.imposterMode, imposterMode) || other.imposterMode == imposterMode)&&(identical(other.categoryHintEnabled, categoryHintEnabled) || other.categoryHintEnabled == categoryHintEnabled)&&(identical(other.secretVoting, secretVoting) || other.secretVoting == secretVoting)&&(identical(other.discussionTime, discussionTime) || other.discussionTime == discussionTime)&&(identical(other.civilianWinPoints, civilianWinPoints) || other.civilianWinPoints == civilianWinPoints)&&(identical(other.imposterWinPoints, imposterWinPoints) || other.imposterWinPoints == imposterWinPoints));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_packs),imposterCount,imposterMode,categoryHintEnabled,secretVoting,discussionTime,civilianWinPoints,imposterWinPoints);

@override
String toString() {
  return 'GameConfig(packs: $packs, imposterCount: $imposterCount, imposterMode: $imposterMode, categoryHintEnabled: $categoryHintEnabled, secretVoting: $secretVoting, discussionTime: $discussionTime, civilianWinPoints: $civilianWinPoints, imposterWinPoints: $imposterWinPoints)';
}


}

/// @nodoc
abstract mixin class _$GameConfigCopyWith<$Res> implements $GameConfigCopyWith<$Res> {
  factory _$GameConfigCopyWith(_GameConfig value, $Res Function(_GameConfig) _then) = __$GameConfigCopyWithImpl;
@override @useResult
$Res call({
 List<WordPack> packs, int imposterCount, ImposterMode imposterMode, bool categoryHintEnabled, bool secretVoting, Duration discussionTime, int civilianWinPoints, int imposterWinPoints
});




}
/// @nodoc
class __$GameConfigCopyWithImpl<$Res>
    implements _$GameConfigCopyWith<$Res> {
  __$GameConfigCopyWithImpl(this._self, this._then);

  final _GameConfig _self;
  final $Res Function(_GameConfig) _then;

/// Create a copy of GameConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? packs = null,Object? imposterCount = null,Object? imposterMode = null,Object? categoryHintEnabled = null,Object? secretVoting = null,Object? discussionTime = null,Object? civilianWinPoints = null,Object? imposterWinPoints = null,}) {
  return _then(_GameConfig(
packs: null == packs ? _self._packs : packs // ignore: cast_nullable_to_non_nullable
as List<WordPack>,imposterCount: null == imposterCount ? _self.imposterCount : imposterCount // ignore: cast_nullable_to_non_nullable
as int,imposterMode: null == imposterMode ? _self.imposterMode : imposterMode // ignore: cast_nullable_to_non_nullable
as ImposterMode,categoryHintEnabled: null == categoryHintEnabled ? _self.categoryHintEnabled : categoryHintEnabled // ignore: cast_nullable_to_non_nullable
as bool,secretVoting: null == secretVoting ? _self.secretVoting : secretVoting // ignore: cast_nullable_to_non_nullable
as bool,discussionTime: null == discussionTime ? _self.discussionTime : discussionTime // ignore: cast_nullable_to_non_nullable
as Duration,civilianWinPoints: null == civilianWinPoints ? _self.civilianWinPoints : civilianWinPoints // ignore: cast_nullable_to_non_nullable
as int,imposterWinPoints: null == imposterWinPoints ? _self.imposterWinPoints : imposterWinPoints // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
