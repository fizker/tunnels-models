// swift-tools-version: 6.2

import PackageDescription

let upcomingFeatures: [SwiftSetting] = [
	.enableUpcomingFeature("ExistentialAny"),
	.enableExperimentalFeature("StrictConcurrency"),
	.enableExperimentalFeature("AccessLevelOnImport"),
	.enableUpcomingFeature("InternalImportsByDefault"),
	.enableUpcomingFeature("FullTypedThrows"),
]

let package = Package(
	name: "tunnels-models",
	platforms: [
		.iOS(.v15),
		.macOS(.v12),
		.tvOS(.v15),
		.watchOS(.v8),
	],
	products: [
		.library(
			name: "TunnelModels",
			targets: ["TunnelLogModels", "TunnelModels"],
		),
	],
	dependencies: [
		.package(url: "https://github.com/fizker/swift-extensions.git", from:"1.4.0"),
	],
	targets: [
		.target(
			name: "TunnelLogModels",
			dependencies: [
				"TunnelModels",
			],
			swiftSettings: upcomingFeatures,
		),
		.target(
			name: "TunnelModels",
			dependencies: [
				.product(name: "FzkExtensions", package: "swift-extensions"),
			],
			swiftSettings: upcomingFeatures,
		),
		.testTarget(
			name: "TunnelModelsTests",
			dependencies: ["TunnelModels"],
			swiftSettings: upcomingFeatures,
		),
		.testTarget(
			name: "TunnelLogModelsTests",
			dependencies: ["TunnelLogModels"],
			swiftSettings: upcomingFeatures,
		),
	],
)
