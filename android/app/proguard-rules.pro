# Custom R8/ProGuard rules for release builds.
#
# Nothing is needed here yet: all of the app's logic is Dart, compiled to
# native code by the Dart AOT compiler — R8 never touches it. R8 only
# processes this project's Kotlin/Java code (just MainActivity) and each
# plugin's native Android glue, which already ships its own consumer
# ProGuard rules bundled in its AAR (Flutter's federated-plugin convention).
#
# If a release build ever crashes only after enabling minification (and not
# in a --debug/--profile run), it's almost certainly a missing keep rule for
# a specific plugin's native class — add it here, referencing that plugin's
# own documentation.
