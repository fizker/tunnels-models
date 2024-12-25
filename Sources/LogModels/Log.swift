public import Foundation
public import TunnelModels

public enum BodyStorage: String, Codable, Sendable {
	/// The body, if present, is stored inside the HTTPRequest.
	case included
	/// The body is stored next to the JSON file.
	case separate
}

public struct Log: Codable, Identifiable, Sendable {
	public typealias ID = HTTPRequest.ID

	public var requestReceived: Date
	public var responseSent: Date
	/// The response time in milliseconds
	public var responseTime: Double
	public var id: ID { request.id }

	public var request: HTTPRequest
	public var requestBody: BodyStorage = .included
	public var response: HTTPResponse

	public init(requestReceived: Date, responseSent: Date, responseTime: Double, request: HTTPRequest, requestBody: BodyStorage = .included, response: HTTPResponse) {
		self.requestReceived = requestReceived
		self.responseSent = responseSent
		self.responseTime = responseTime
		self.request = request
		self.requestBody = requestBody
		self.response = response
	}
}
