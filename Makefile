install:
		yarn install
lint:
	yarn lint
unit-test:
		yarn test:unit
e2e-test:
		yarn test:e2e --headless
test: unit-test e2e-test
run:
	yarn serve
