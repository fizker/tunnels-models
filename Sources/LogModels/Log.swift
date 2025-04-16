public import Foundation
public import TunnelModels

public enum BodyStorage: Codable, Sendable {
	/// The body, if present, is stored inside the HTTPRequest.
	case included
	/// The body is stored next to the JSON file.
	case separate(filename: String)
}

public struct Log: Codable, Identifiable, Sendable {
	public typealias ID = HTTPRequest.ID

	public var id: ID { request.id }

	public var requestReceived: Date
	public var request: HTTPRequest
	public var requestBody: BodyStorage = .included

	public var response: Response?

	public init(request: HTTPRequest, requestReceived: Date = .now) {
		self.request = request
		self.requestReceived = requestReceived
	}

	public mutating func set(response: HTTPResponse) {
		self.response = .init(
			sent: .now,
			time: requestReceived.timeIntervalSinceNow * -1000,
			httpResponse: response,
			body: .included
		)
	}

	/// The response-part of a Log.
	///
	/// It exists to ensure that either all values are present, or none of the values.
	public struct Response: Codable, Sendable {
		public var sent: Date
		/// The response time in milliseconds
		public var time: Double
		public var httpResponse: HTTPResponse
		public var body: BodyStorage = .included
	}
}
