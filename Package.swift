// swift-tools-version: 6.0

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
	products: [
		.library(
			name: "TunnelModels",
			targets: ["LogModels", "TunnelModels"]
		),
	],
	targets: [
		.target(
			name: "LogModels",
			dependencies: [
				"TunnelModels"
			],
			swiftSettings: upcomingFeatures
		),
		.target(
			name: "TunnelModels",
			swiftSettings: upcomingFeatures
		),
		.testTarget(
			name: "TunnelModelsTests",
			dependencies: ["TunnelModels"],
			swiftSettings: upcomingFeatures
		),
		.testTarget(
			name: "LogModelsTests",
			dependencies: ["LogModels"],
			swiftSettings: upcomingFeatures
		),
	]
)
