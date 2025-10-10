.PHONY: swift-format
swift-format:
	@echo "Running Swift format..."
	@swift-format format --configuration .swift-format -p --in-place -r .