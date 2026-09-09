// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'most_likely_to_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MostLikelyToConfig {

/// How many prompts are played before the scores are final.
 int get roundCount;/// Whether the host's own prompts join the bundled deck.
 bool get includeCustomPrompts;/// Which bundled deck to deal from.
 PromptLanguage get language;
/// Create a copy of MostLikelyToConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MostLikelyToConfigCopyWith<MostLikelyToConfig> get copyWith => _$MostLikelyToConfigCopyWithImpl<MostLikelyToConfig>(this as MostLikelyToConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MostLikelyToConfig&&(identical(other.roundCount, roundCount) || other.roundCount == roundCount)&&(identical(other.includeCustomPrompts, includeCustomPrompts) || other.includeCustomPrompts == includeCustomPrompts)&&(identical(other.language, language) || other.language == language));
}


@override
int get hashCode => Object.hash(runtimeType,roundCount,includeCustomPrompts,language);

@override
String toString() {
  return 'MostLikelyToConfig(roundCount: $roundCount, includeCustomPrompts: $includeCustomPrompts, language: $language)';
}


}

/// @nodoc
abstract mixin class $MostLikelyToConfigCopyWith<$Res>  {
  factory $MostLikelyToConfigCopyWith(MostLikelyToConfig value, $Res Function(MostLikelyToConfig) _then) = _$MostLikelyToConfigCopyWithImpl;
@useResult
$Res call({
 int roundCount, bool includeCustomPrompts, PromptLanguage language
});




}
/// @nodoc
class _$MostLikelyToConfigCopyWithImpl<$Res>
    implements $MostLikelyToConfigCopyWith<$Res> {
  _$MostLikelyToConfigCopyWithImpl(this._self, this._then);

  final MostLikelyToConfig _self;
  final $Res Function(MostLikelyToConfig) _then;

/// Create a copy of MostLikelyToConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? roundCount = null,Object? includeCustomPrompts = null,Object? language = null,}) {
  return _then(_self.copyWith(
roundCount: null == roundCount ? _self.roundCount : roundCount // ignore: cast_nullable_to_non_nullable
as int,includeCustomPrompts: null == includeCustomPrompts ? _self.includeCustomPrompts : includeCustomPrompts // ignore: cast_nullable_to_non_nullable
as bool,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as PromptLanguage,
  ));
}

}


/// Adds pattern-matching-related methods to [MostLikelyToConfig].
extension MostLikelyToConfigPatterns on MostLikelyToConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MostLikelyToConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MostLikelyToConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MostLikelyToConfig value)  $default,){
final _that = this;
switch (_that) {
case _MostLikelyToConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MostLikelyToConfig value)?  $default,){
final _that = this;
switch (_that) {
case _MostLikelyToConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int roundCount,  bool includeCustomPrompts,  PromptLanguage language)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MostLikelyToConfig() when $default != null:
return $default(_that.roundCount,_that.includeCustomPrompts,_that.language);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int roundCount,  bool includeCustomPrompts,  PromptLanguage language)  $default,) {final _that = this;
switch (_that) {
case _MostLikelyToConfig():
return $default(_that.roundCount,_that.includeCustomPrompts,_that.language);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int roundCount,  bool includeCustomPrompts,  PromptLanguage language)?  $default,) {final _that = this;
switch (_that) {
case _MostLikelyToConfig() when $default != null:
return $default(_that.roundCount,_that.includeCustomPrompts,_that.language);case _:
  return null;

}
}

}

/// @nodoc


class _MostLikelyToConfig extends MostLikelyToConfig {
  const _MostLikelyToConfig({this.roundCount = 10, this.includeCustomPrompts = true, this.language = PromptLanguage.english}): super._();
  

/// How many prompts are played before the scores are final.
@override@JsonKey() final  int roundCount;
/// Whether the host's own prompts join the bundled deck.
@override@JsonKey() final  bool includeCustomPrompts;
/// Which bundled deck to deal from.
@override@JsonKey() final  PromptLanguage language;

/// Create a copy of MostLikelyToConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MostLikelyToConfigCopyWith<_MostLikelyToConfig> get copyWith => __$MostLikelyToConfigCopyWithImpl<_MostLikelyToConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MostLikelyToConfig&&(identical(other.roundCount, roundCount) || other.roundCount == roundCount)&&(identical(other.includeCustomPrompts, includeCustomPrompts) || other.includeCustomPrompts == includeCustomPrompts)&&(identical(other.language, language) || other.language == language));
}


@override
int get hashCode => Object.hash(runtimeType,roundCount,includeCustomPrompts,language);

@override
String toString() {
  return 'MostLikelyToConfig(roundCount: $roundCount, includeCustomPrompts: $includeCustomPrompts, language: $language)';
}


}

/// @nodoc
abstract mixin class _$MostLikelyToConfigCopyWith<$Res> implements $MostLikelyToConfigCopyWith<$Res> {
  factory _$MostLikelyToConfigCopyWith(_MostLikelyToConfig value, $Res Function(_MostLikelyToConfig) _then) = __$MostLikelyToConfigCopyWithImpl;
@override @useResult
$Res call({
 int roundCount, bool includeCustomPrompts, PromptLanguage language
});




}
/// @nodoc
class __$MostLikelyToConfigCopyWithImpl<$Res>
    implements _$MostLikelyToConfigCopyWith<$Res> {
  __$MostLikelyToConfigCopyWithImpl(this._self, this._then);

  final _MostLikelyToConfig _self;
  final $Res Function(_MostLikelyToConfig) _then;

/// Create a copy of MostLikelyToConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? roundCount = null,Object? includeCustomPrompts = null,Object? language = null,}) {
  return _then(_MostLikelyToConfig(
roundCount: null == roundCount ? _self.roundCount : roundCount // ignore: cast_nullable_to_non_nullable
as int,includeCustomPrompts: null == includeCustomPrompts ? _self.includeCustomPrompts : includeCustomPrompts // ignore: cast_nullable_to_non_nullable
as bool,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as PromptLanguage,
  ));
}


}

// dart format on
