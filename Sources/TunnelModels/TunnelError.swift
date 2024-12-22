/// Represents errors that might cause a Client connected to be rejected.
public enum TunnelError: Error, Codable, Sendable {
	/// The requested tunnel was already bound to another client.
	case alreadyBound(host: String)
}
