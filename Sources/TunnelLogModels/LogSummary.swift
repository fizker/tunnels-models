public import Foundation
public import TunnelModels

public struct LogSummary: Codable, Identifiable, Sendable {
	public var id: Log.ID
	public var host: String
	public var path: String
	public var requestReceived: Date
	public var requestMethod: HTTPMethod
	public var response: Response?

	public init(id: Log.ID, host: String, path: String, requestReceived: Date, requestMethod: HTTPMethod) {
		self.id = id
		self.host = host
		self.path = path
		self.requestReceived = requestReceived
		self.requestMethod = requestMethod
	}

	public init(id: Log.ID, host: String, path: String, requestReceived: Date, requestMethod: HTTPMethod, responseSent: Date, responseStatus: HTTPStatus, responseTime: Double) {
		self.id = id
		self.host = host
		self.path = path
		self.requestReceived = requestReceived
		self.requestMethod = requestMethod
		self.response = .init(
			sent: responseSent,
			status: responseStatus,
			time: responseTime
		)
	}

	/// The response-part of a Log.
	///
	/// It exists to ensure that either all values are present, or none of the values.
	public struct Response: Codable, Sendable {
		public var sent: Date
		public var status: HTTPStatus
		/// The response time in milliseconds
		public var time: Double

		public init(sent: Date, status: HTTPStatus, time: Double) {
			self.sent = sent
			self.status = status
			self.time = time
		}
	}
}

extension LogSummary {
	public init(log: Log) {
		id = log.id
		host = log.request.host
		path = log.request.path
		requestReceived = log.requestReceived
		requestMethod = log.request.method
		response = log.response.map { .init(
			sent: $0.sent,
			status: $0.httpResponse.status,
			time: $0.time
		) }
	}
}
