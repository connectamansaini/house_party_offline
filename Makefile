# -------------------------
# Flutter Makefile (Fast, Cross-Platform)
# -------------------------

# Clean project and fetch dependencies
clean:
	@echo "\033[1;36mCleaning project...\033[0m"
	flutter clean
	@echo "Fetching dependencies..."
	flutter pub get

# Clean + build_runner
clean-build:
	@echo "\033[1;36mClean + Code Generation...\033[0m"
	flutter clean && \
	flutter pub get && \
	dart run build_runner build --delete-conflicting-outputs

# Web builds
web-dev:
	@echo "\033[1;36mBuilding Web (DEV)...\033[0m"
	flutter build web --release \
		--target=lib/main_development.dart \
		--dart-define-from-file=.env.dev

web-stage:
	@echo "\033[1;36mBuilding Web (STAGE)...\033[0m"
	flutter build web --release \
		--target=lib/main_staging.dart \
		--dart-define-from-file=.env.stage

web-prod:
	@echo "\033[1;36mBuilding Web (PROD)...\033[0m"
	flutter build web --release \
		--target=lib/main_production.dart \
		--dart-define-from-file=.env.prod

# Android builds (AAB)
android-dev:
	@echo "\033[1;36mBuilding Android AppBundle (DEV)...\033[0m"
	flutter build appbundle \
		--target=lib/main_development.dart \
		--dart-define-from-file=.env.dev

android-stage:
	@echo "\033[1;36mBuilding Android AppBundle (STAGE)...\033[0m"
	flutter build appbundle \
		--target=lib/main_staging.dart \
		--dart-define-from-file=.env.stage

android-prod:
	@echo "\033[1;36mBuilding Android AppBundle (PROD)...\033[0m"
	flutter build appbundle \
		--target=lib/main_production.dart \
		--dart-define-from-file=.env.prod

# Help
help:
	@echo ""
	@echo "Available Commands:"
	@echo "  make clean           - Clean project + pub get"
	@echo "  make clean-build     - Clean + pub get + build_runner"
	@echo "  make web-dev         - Build Web (development)"
	@echo "  make web-stage       - Build Web (staging)"
	@echo "  make web-prod        - Build Web (production)"
	@echo "  make android-dev     - Build Android AAB (development)"
	@echo "  make android-stage   - Build Android AAB (staging)"
	@echo "  make android-prod    - Build Android AAB (production)"
	@echo ""
