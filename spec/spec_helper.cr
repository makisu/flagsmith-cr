require "spec"
require "webmock"
Spec.before_each &->WebMock.reset
Spec.before_each { Flagsmith.api_key = "test" }
require "../src/flagsmith"
