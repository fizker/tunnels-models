import Testing
import Foundation
@testable import TunnelModels

struct HTTPHeadersTests {
	@Test
	func add__nameHasSameCasing__allValuesAreStored() async throws {
		var headers = HTTPHeaders()
		headers.add(value: "foo", for: "test")
		headers.add(value: "bar", for: "test")

		#expect(["foo", "bar"] == headers.headers(named: "test"))
	}

	@Test
	func add__nameHasDifferentCasing__allValuesAreStored() async throws {
		var headers = HTTPHeaders()
		headers.add(value: "foo", for: "test")
		headers.add(value: "bar", for: "Test")

		#expect(["foo", "bar"] == headers.headers(named: "test"))
	}

	@Test
	func firstHeaderNamed__queryHaveSameCasing__allValuesAreReturned() async throws {
		let headers = HTTPHeaders(["foo": ["bar", "baz"]])

		#expect("bar" == headers.firstHeader(named: "foo"))
	}

	@Test
	func firstHeaderNamed__queryHaveDifferentCasing__allValuesAreReturned() async throws {
		let headers = HTTPHeaders(["foo": ["bar", "baz"]])

		#expect("bar" == headers.firstHeader(named: "Foo"))
	}

	@Test
	func headersNamed__queryHaveSameCasing__allValuesAreReturned() async throws {
		let headers = HTTPHeaders(["foo": "bar"])

		#expect(["bar"] == headers.headers(named: "foo"))
	}

	@Test
	func headersNamed__queryHaveDifferentCasing__allValuesAreReturned() async throws {
		let headers = HTTPHeaders(["foo": "bar"])

		#expect(["bar"] == headers.headers(named: "Foo"))
	}

	@Test
	func map__multipleHeaders__allHeadersAreReported() async throws {
		let expected = [ "foo": ["bar", "baz"], "111": ["222"]]
		let headers = HTTPHeaders(expected)

		let actual: [String:[String]]

		actual = .init(uniqueKeysWithValues: headers.map { ($0, $1) })

		#expect(expected == actual)
	}

	@Test
	func removeValueForName__valueMatchesExactly_nameMatchesExactly_multipleValuesWithName__valueIsRemoved() async throws {
		var headers = HTTPHeaders([ "foo": ["bar", "baz"], "111": ["222"]])

		headers.remove(value: "bar", for: "foo")

		let values = headers.headers(named: "foo")
		#expect(values == ["baz"])
	}

	@Test
	func removeValueForName__valueMatchesExactly_nameHasDifferentCasing_multipleValuesWithName__valueIsRemoved() async throws {
		var headers = HTTPHeaders([ "foo": ["bar", "baz"], "111": ["222"]])

		headers.remove(value: "bar", for: "Foo")

		let values = headers.headers(named: "foo")
		#expect(values == ["baz"])
	}

	@Test
	func removeValueForName__valueHasDifferentCasing_nameMatchesExactly_multipleValuesWithName__valueIsKept() async throws {
		var headers = HTTPHeaders([ "foo": ["bar", "baz"], "111": ["222"]])

		headers.remove(value: "Bar", for: "foo")

		let values = headers.headers(named: "foo")
		#expect(values == ["bar", "baz"])
	}

	@Test
	func removeValueForName__valueHasDifferentCasing_nameHasDifferentCasing_multipleValuesWithName__valueIsKept() async throws {
		var headers = HTTPHeaders([ "foo": ["bar", "baz"], "111": ["222"]])

		headers.remove(value: "Bar", for: "Foo")

		let values = headers.headers(named: "foo")
		#expect(values == ["bar", "baz"])
	}

	@Test
	func removeAll__nameMatchesCase__allValuesAreRemoved() async throws {
		var headers = HTTPHeaders([ "foo": ["bar", "baz"], "111": ["222"]])

		headers.removeAll(named: "foo")

		let values = headers.headers(named: "foo")
		#expect(values == [])
	}

	@Test
	func removeAll__nameHasDifferentCase__allValuesAreRemoved() async throws {
		var headers = HTTPHeaders([ "foo": ["bar", "baz"], "111": ["222"]])

		headers.removeAll(named: "Foo")

		let values = headers.headers(named: "foo")
		#expect(values == [])
	}

	@Test
	func set__nameHasSameCasing__existingValueIsOverwritten() async throws {
		var headers = HTTPHeaders(["foo": "bar"])
		headers.set(value: "baz", for: "foo")

		#expect(headers.headers(named: "foo") == ["baz"])
	}

	@Test
	func set__nameHasDifferentCasing__existingValueIsOverwritten() async throws {
		var headers = HTTPHeaders(["foo": "bar"])
		headers.set(value: "baz", for: "Foo")

		#expect(headers.headers(named: "foo") == ["baz"])
	}

	@Test
	func encode__multipleHeadersAndValues__encodesAsExpected() async throws {
		let headers = HTTPHeaders(["foo": ["bar", "baz"], "111": ["222"]])

		let expected = """
		{
		  "values" : {
		    "111" : [
		      "222"
		    ],
		    "foo" : [
		      "bar",
		      "baz"
		    ]
		  }
		}
		"""

		let actual = try encode(headers)
		#expect(actual == expected)
	}

	@Test
	func decode__multipleHeadersAndValues__decodesAsExpected() async throws {
		let expected = HTTPHeaders(["foo": ["bar", "baz"], "111": ["222"]])

		let json = """
		{
		  "values" : {
		    "foo" : [
		      "bar",
		      "baz"
		    ],
		    "111" : [
		      "222"
		    ]
		  }
		}
		"""

		let actual = try decode(HTTPHeaders.self, from: json)
		#expect(actual.values == expected.values)
	}
}

func encode(_ value: some Encodable) throws -> String {
	let encoder = JSONEncoder()
	encoder.outputFormatting = [ .prettyPrinted, .sortedKeys ]

	let data = try encoder.encode(value)
	let json = String(data: data, encoding: .utf8)!
	return json
}

func decode<T: Decodable>(_ type: T.Type = T.self, from value: String) throws -> T {
	let decoder = JSONDecoder()

	let data = value.data(using: .utf8)!

	return try decoder.decode(type, from: data)
}
