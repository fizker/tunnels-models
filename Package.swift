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
