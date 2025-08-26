# Credit to PointFree for Makefile inspiration. This makefile is heavily
# based on many of theirs.
#
# https://github.com/pointfreeco/

CONFIG = Debug

PLATFORM_IOS = iOS Simulator,id=$(call udid_for,iPhone)
PLATFORM_MACOS = macOS
PLATFORM_MAC_CATALYST = macOS,variant=Mac Catalyst
PLATFORM_TVOS = tvOS Simulator,id=$(call udid_for,TV)
PLATFORM_VISIONOS = visionOS Simulator,id=$(call udid_for,Vision)
PLATFORM_WATCHOS = watchOS Simulator,id=$(call udid_for,Watch)

PLATFORM = IOS
DESTINATION = platform="$(PLATFORM_$(PLATFORM))"

PLATFORM_ID = $(shell echo "$(DESTINATION)" | sed -E "s/.+,id=(.+)/\1/")

SCHEME = Money

WORKSPACE = Money.xcworkspace

XCODEBUILD_ARGUMENT = test

XCODEBUILD_FLAGS = \
	-configuration $(CONFIG) \
	-destination $(DESTINATION) \
	-scheme "$(SCHEME)" \
	-skipMacroValidation \
	-workspace $(WORKSPACE)

XCODEBUILD_COMMAND = xcodebuild $(XCODEBUILD_ARGUMENT) $(XCODEBUILD_FLAGS)

ifneq ($(strip $(shell which xcbeautify)),)
    XCODEBUILD = set -o pipefail && $(XCODEBUILD_COMMAND) | xcbeautify --quiet
else
	XCODEBUILD = $(XCODEBUILD_COMMAND)
endif

warm-simulator:
	@test "$(PLATFORM_ID)" != "" \
		&& xcrun simctl boot $(PLATFORM_ID) \
		&& open -a Simulator --args -CurrentDeviceUDID $(PLATFORM_ID) \
		|| exit 0

xcodebuild: warm-simulator
	$(XCODEBUILD)

xcodebuild-raw: warm-simulator
	$(XCODEBUILD_COMMAND)

development:
	brew install xcbeautify
	brew install swiftlint

lint:
	swiftlint lint

lint-fix:
	swiftlint lint --fix

.PHONY: xcodebuild lint

define udid_for
$(shell xcrun simctl list --json devices available '$(1)' | jq -r '[.devices|to_entries|sort_by(.key)|reverse|.[].value|select(length > 0)|.[0]][0].udid')
endef
