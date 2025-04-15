public import Foundation
public import TunnelModels

public struct LogSummary: Codable, Identifiable, Sendable {
	public var id: Log.ID
	public var host: String
	public var path: String
	public var requestReceived: Date
	public var requestMethod: HTTPMethod
	public var responseSent: Date?
	public var responseStatus: HTTPStatus?
	/// The response time in milliseconds
	public var responseTime: Double?

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
		self.responseSent = responseSent
		self.responseStatus = responseStatus
		self.responseTime = responseTime
	}
}

extension LogSummary {
	public init(log: Log) {
		id = log.id
		host = log.request.host
		path = log.request.path
		requestReceived = log.requestReceived
		requestMethod = log.request.method
		responseSent = log.responseSent
		responseStatus = log.response?.status
		responseTime = log.responseTime
	}
}
