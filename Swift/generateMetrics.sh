xcodebuild -workspace Swift.xcworkspace -scheme Tests build-for-testing | xcpretty
rm Metrics/*
xcodebuild -workspace Swift.xcworkspace -scheme Tests test-without-building | python3 generateBadges.py
