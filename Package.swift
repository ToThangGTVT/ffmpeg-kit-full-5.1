// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let release = "full.v5.1"

let frameworks = ["ffmpegkit": "d6e9e8db595c0a4ee1c6ca7f5d13b7f2c53c2c6c8dc5eee838b5aef096b2fc9f", "libavcodec": "52738e8ea3ee66a9ed49d6ea11546b8b2264bac4a1c4699676121c4a7d49f065", "libavdevice": "57a76f5bd2762215a9373e439aea97d03edc1cc533d6df665536e84e693e4296", "libavfilter": "e9e64d1b946e5b1ea016a77616d03ac191d6f03245e550d9d9b94351b594b4ed", "libavformat": "b9358d979ab73b5aa977b7572c9518091f96ec67352ff24910cbd09179226863", "libavutil": "7643c31cd1fad2b3bc44f4016667b3bdc12291409963ec25db517a2a76540cbb", "libswresample": "64bf0b738807f6620f59722fea1b03f417003377a09f3e1f72fed471b60ff58c", "libswscale": "8f6fc4e83c4ee163d95943f1c483c654f8bf7ee16b9847679006fba3e7ff8afb"]

func xcframework(_ package: Dictionary<String, String>.Element) -> Target {
    let url = "https://github.com/ToThangGTVT/ffmpeg-kit-full-5.1/releases/download/\(release)/\(package.key).xcframework.zip"
    return .binaryTarget(name: package.key, url: url, checksum: package.value)
}

let linkerSettings: [LinkerSetting] = [
    .linkedFramework("AudioToolbox", .when(platforms: [.macOS, .iOS, .macCatalyst, .tvOS])),
    .linkedFramework("AVFoundation", .when(platforms: [.macOS, .iOS, .macCatalyst])),
    .linkedFramework("CoreMedia", .when(platforms: [.macOS])),
    .linkedFramework("OpenGL", .when(platforms: [.macOS])),
    .linkedFramework("VideoToolbox", .when(platforms: [.macOS, .iOS, .macCatalyst, .tvOS])),
    .linkedLibrary("z"),
    .linkedLibrary("lzma"),
    .linkedLibrary("bz2"),
    .linkedLibrary("iconv")
]

let libAVFrameworks = frameworks.filter({ $0.key != "ffmpegkit" })

let package = Package(
    name: "ffmpeg-kit-spm",
    platforms: [.iOS(.v12), .macOS(.v10_15), .tvOS(.v11), .watchOS(.v7)],
    products: [
        .library(
            name: "FFmpeg-Kit",
            type: .dynamic,
            targets: ["FFmpeg-Kit", "ffmpegkit"]),
        .library(
            name: "FFmpeg",
            type: .dynamic,
            targets: ["FFmpeg"] + libAVFrameworks.map { $0.key }),
    ] + libAVFrameworks.map { .library(name: $0.key, targets: [$0.key]) },
    dependencies: [],
    targets: [
        .target(
            name: "FFmpeg-Kit",
            dependencies: frameworks.map { .byName(name: $0.key) },
            linkerSettings: linkerSettings),
        .target(
            name: "FFmpeg",
            dependencies: libAVFrameworks.map { .byName(name: $0.key) },
            linkerSettings: linkerSettings),
    ] + frameworks.map { xcframework($0) }
)
