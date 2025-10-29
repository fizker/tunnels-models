public import Foundation
import FzkExtensions

/// A internally-configured Coder for encoding/decoding DTOs in the fashion that TunnelServer and TunnelClient expects.
///
/// It encapsulates `JSONEncoder` and `JSONDecoder` from `Foundation` and sets up the expected
/// encoding and decoding strategies.
public struct Coder {
	let encoder = JSONEncoder() ~ {
		$0.outputFormatting = [
			.prettyPrinted,
			.sortedKeys,
			.withoutEscapingSlashes,
		]
		$0.dateEncodingStrategy = .iso8601
		$0.dataEncodingStrategy = .base64
	}
	let decoder = JSONDecoder() ~ {
		$0.dateDecodingStrategy = .iso8601
		$0.dataDecodingStrategy = .base64
	}

	/// Creates a new ``Coder``.
	public init() {
	}

	/// Encodes the given `Encodable` as `JSON`.
	///
	/// - Parameter value: The object to encode.
	/// - Returns: The resulting `Data`.
	/// - Throws: The error that `JSONEncoder` might throw.
	public func encode(_ value: some Encodable) throws -> Data {
		return try encoder.encode(value)
	}

	/// Decodes the given JSON data into a value of the given type.
	///
	/// - Parameters:
	///   - type: The type that ``data`` should be decoded to.
	///   - data: The JSON payload to decode.
	/// - Returns: A decoded instance of `type`.
	/// - Throws: Any error thrown by `JSONDecoder`.
	public func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
		return try decoder.decode(T.self, from: data)
	}

	/// Decodes the given JSON data into a value of type `T`.
	///
	/// - Parameter data: The JSON payload to decode.
	/// - Returns: A decoded instance of `T`.
	/// - Throws: Any error thrown by `JSONDecoder`.
	public func decode<T: Decodable>(_ data: Data) throws -> T {
		return try decoder.decode(T.self, from: data)
	}
}
