// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'truth_or_dare_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TruthOrDareConfig {

/// Full rounds to play — every player gets one turn per round.
 int get roundCount; TruthOrDareLevel get level;/// Whether the host's own truths and dares join the bundled decks.
 bool get includeCustomPrompts;/// Which bundled decks to deal from.
 PromptLanguage get language;
/// Create a copy of TruthOrDareConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TruthOrDareConfigCopyWith<TruthOrDareConfig> get copyWith => _$TruthOrDareConfigCopyWithImpl<TruthOrDareConfig>(this as TruthOrDareConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TruthOrDareConfig&&(identical(other.roundCount, roundCount) || other.roundCount == roundCount)&&(identical(other.level, level) || other.level == level)&&(identical(other.includeCustomPrompts, includeCustomPrompts) || other.includeCustomPrompts == includeCustomPrompts)&&(identical(other.language, language) || other.language == language));
}


@override
int get hashCode => Object.hash(runtimeType,roundCount,level,includeCustomPrompts,language);

@override
String toString() {
  return 'TruthOrDareConfig(roundCount: $roundCount, level: $level, includeCustomPrompts: $includeCustomPrompts, language: $language)';
}


}

/// @nodoc
abstract mixin class $TruthOrDareConfigCopyWith<$Res>  {
  factory $TruthOrDareConfigCopyWith(TruthOrDareConfig value, $Res Function(TruthOrDareConfig) _then) = _$TruthOrDareConfigCopyWithImpl;
@useResult
$Res call({
 int roundCount, TruthOrDareLevel level, bool includeCustomPrompts, PromptLanguage language
});




}
/// @nodoc
class _$TruthOrDareConfigCopyWithImpl<$Res>
    implements $TruthOrDareConfigCopyWith<$Res> {
  _$TruthOrDareConfigCopyWithImpl(this._self, this._then);

  final TruthOrDareConfig _self;
  final $Res Function(TruthOrDareConfig) _then;

/// Create a copy of TruthOrDareConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? roundCount = null,Object? level = null,Object? includeCustomPrompts = null,Object? language = null,}) {
  return _then(_self.copyWith(
roundCount: null == roundCount ? _self.roundCount : roundCount // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as TruthOrDareLevel,includeCustomPrompts: null == includeCustomPrompts ? _self.includeCustomPrompts : includeCustomPrompts // ignore: cast_nullable_to_non_nullable
as bool,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as PromptLanguage,
  ));
}

}


/// Adds pattern-matching-related methods to [TruthOrDareConfig].
extension TruthOrDareConfigPatterns on TruthOrDareConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TruthOrDareConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TruthOrDareConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TruthOrDareConfig value)  $default,){
final _that = this;
switch (_that) {
case _TruthOrDareConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TruthOrDareConfig value)?  $default,){
final _that = this;
switch (_that) {
case _TruthOrDareConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int roundCount,  TruthOrDareLevel level,  bool includeCustomPrompts,  PromptLanguage language)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TruthOrDareConfig() when $default != null:
return $default(_that.roundCount,_that.level,_that.includeCustomPrompts,_that.language);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int roundCount,  TruthOrDareLevel level,  bool includeCustomPrompts,  PromptLanguage language)  $default,) {final _that = this;
switch (_that) {
case _TruthOrDareConfig():
return $default(_that.roundCount,_that.level,_that.includeCustomPrompts,_that.language);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int roundCount,  TruthOrDareLevel level,  bool includeCustomPrompts,  PromptLanguage language)?  $default,) {final _that = this;
switch (_that) {
case _TruthOrDareConfig() when $default != null:
return $default(_that.roundCount,_that.level,_that.includeCustomPrompts,_that.language);case _:
  return null;

}
}

}

/// @nodoc


class _TruthOrDareConfig extends TruthOrDareConfig {
  const _TruthOrDareConfig({this.roundCount = 3, this.level = TruthOrDareLevel.mild, this.includeCustomPrompts = true, this.language = PromptLanguage.english}): super._();
  

/// Full rounds to play — every player gets one turn per round.
@override@JsonKey() final  int roundCount;
@override@JsonKey() final  TruthOrDareLevel level;
/// Whether the host's own truths and dares join the bundled decks.
@override@JsonKey() final  bool includeCustomPrompts;
/// Which bundled decks to deal from.
@override@JsonKey() final  PromptLanguage language;

/// Create a copy of TruthOrDareConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TruthOrDareConfigCopyWith<_TruthOrDareConfig> get copyWith => __$TruthOrDareConfigCopyWithImpl<_TruthOrDareConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TruthOrDareConfig&&(identical(other.roundCount, roundCount) || other.roundCount == roundCount)&&(identical(other.level, level) || other.level == level)&&(identical(other.includeCustomPrompts, includeCustomPrompts) || other.includeCustomPrompts == includeCustomPrompts)&&(identical(other.language, language) || other.language == language));
}


@override
int get hashCode => Object.hash(runtimeType,roundCount,level,includeCustomPrompts,language);

@override
String toString() {
  return 'TruthOrDareConfig(roundCount: $roundCount, level: $level, includeCustomPrompts: $includeCustomPrompts, language: $language)';
}


}

/// @nodoc
abstract mixin class _$TruthOrDareConfigCopyWith<$Res> implements $TruthOrDareConfigCopyWith<$Res> {
  factory _$TruthOrDareConfigCopyWith(_TruthOrDareConfig value, $Res Function(_TruthOrDareConfig) _then) = __$TruthOrDareConfigCopyWithImpl;
@override @useResult
$Res call({
 int roundCount, TruthOrDareLevel level, bool includeCustomPrompts, PromptLanguage language
});




}
/// @nodoc
class __$TruthOrDareConfigCopyWithImpl<$Res>
    implements _$TruthOrDareConfigCopyWith<$Res> {
  __$TruthOrDareConfigCopyWithImpl(this._self, this._then);

  final _TruthOrDareConfig _self;
  final $Res Function(_TruthOrDareConfig) _then;

/// Create a copy of TruthOrDareConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? roundCount = null,Object? level = null,Object? includeCustomPrompts = null,Object? language = null,}) {
  return _then(_TruthOrDareConfig(
roundCount: null == roundCount ? _self.roundCount : roundCount // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as TruthOrDareLevel,includeCustomPrompts: null == includeCustomPrompts ? _self.includeCustomPrompts : includeCustomPrompts // ignore: cast_nullable_to_non_nullable
as bool,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as PromptLanguage,
  ));
}


}

// dart format on
