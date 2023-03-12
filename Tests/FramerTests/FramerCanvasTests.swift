import XCTest
import Framing
import Framer

class FramerCanvasTests: XCTestCase {
    /// Must be recorded on iPhone 14 Pro Simulator, iOS 16.2.
    private let recordMode = false
    private let snapshotsFolderName = "_FramerCanvas_Snapshots_"

    func testSingleBlueprintWithOneTextFrame() throws {
        // Given
        let canvas = FramerCanvas.create(size: .init(width: 400, height: 400))

        var blueprint = Blueprint(
            id: "blueprint 1",
            contents: [
                .frame(
                    Frame(rect: canvas.bounds)
                        .inset(top: 10, left: 10, bottom: 10, right: 10)
                        .toBlueprintFrame(withStyle: redFrameStyle, content: redFrameContent)
                )
            ]
        )

        // When
        canvas.draw(blueprint: blueprint)

        // Then
        try compareWithSnapshot(image: canvas.image, imageFileSuffix: "-default")

        let textHorizontalAlignments: [(String, BlueprintFrame.Content.Alignment)] = [
            ("L", .leading),
            ("C", .center),
            ("T", .trailing),
        ]
        let textVerticalAlignments: [(String, BlueprintFrame.Content.Alignment)] = [
            ("L", .leading),
            ("C", .center),
            ("T", .trailing),
        ]

        for horizontalAlignment in textHorizontalAlignments {
            for verticalAlignment in textVerticalAlignments {
                // When
                blueprint.contents[0].mutateFrame { frame in
                    frame.content = .init(
                        contentType: .text(
                            text: "Custom alignment, h: \(horizontalAlignment.0), v: \(verticalAlignment.0)",
                            color: .red,
                            font: .systemFont(ofSize: 10)
                        ),
                        horizontalAlignment: horizontalAlignment.1,
                        verticalAlignment: verticalAlignment.1
                    )
                }
                canvas.draw(blueprint: blueprint)

                // Then
                try compareWithSnapshot(image: canvas.image, imageFileSuffix: "-textAlignment\(horizontalAlignment.0)\(verticalAlignment.0)")
            }
        }
    }

    func testDrawAnnotationsForSingleBlueprintWithOneFrame() throws {
        // Given
        let canvas = FramerCanvas.create(size: .init(width: 800, height: 400))

        var blueprint = Blueprint(
            id: "blueprint 1",
            contents: [
                .frame(
                    Frame(rect: canvas.bounds)
                        .inset(top: 100, left: 300, bottom: 100, right: 300)
                        .toBlueprintFrame(withStyle: redFrameStyle, content: redFrameContent)
                )
            ]
        )

        // When
        canvas.draw(blueprint: blueprint)

        // Then
        try compareWithSnapshot(image: canvas.image, imageFileSuffix: "-noAnnotations")

        let alignments: [(String, BlueprintFrame.Annotation.Style.Alignment)] = [
            ("L", .leading),
            ("C", .center),
            ("T", .trailing),
        ]
        let positions: [(String, BlueprintFrame.Annotation.Style.Position)] = [
            ("T", .top),
            ("B", .bottom),
            ("L", .left),
            ("R", .right),
        ]
        let sizes: [(String, BlueprintFrame.Annotation.Style.Size)] = [
            ("T", .tiny),
            ("S", .small),
            ("N", .normal),
            ("L", .large),
        ]

        for alignment in alignments {
            for position in positions {
                for size in sizes {
                    // When
                    blueprint.contents[0].mutateFrame { frame in
                        frame.annotation = .init(
                            text: "Annotation (size: \(size.0), position: \(position.0), alignment: \(alignment.0)",
                            style: .init(
                                size: size.1,
                                position: position.1,
                                alignment: alignment.1
                            )
                        )
                    }
                    canvas.draw(blueprint: blueprint)

                    // Then
                    try compareWithSnapshot(image: canvas.image, imageFileSuffix: "-annotation\(size.0)\(position.0)\(alignment.0)")
                }
            }
        }
    }

    func testDrawSingleBlueprintWithMultipleFrames() throws {
        // Given
        let canvas = FramerCanvas.create(size: .init(width: 400, height: 400))

        let container = Frame(rect: canvas.bounds)
            .inset(top: 40, left: 40, bottom: 40, right: 40)
        let frame1 = Frame(ofSize: .init(width: 200, height: 200))
            .putInside(container, alignTo: .topLeft)
        let frame2 = Frame(ofSize: .init(width: 200, height: 200))
            .putInside(container, alignTo: .topLeft)
            .offsetBy(x: 50, y: 50)
        let frame3 = Frame(ofSize: .init(width: 200, height: 200))
            .putInside(container, alignTo: .topLeft)
            .offsetBy(x: 100, y: 100)

        // When
        canvas.draw(
            blueprint: Blueprint(
                id: "blueprint 1",
                contents: [
                    .frame(frame1.toBlueprintFrame(withStyle: redFrameStyle, content: redFrameContent)),
                    .frame(frame2.toBlueprintFrame(withStyle: greenFrameStyle, content: greenFrameContent)),
                    .frame(frame3.toBlueprintFrame(withStyle: blueFrameStyle, content: blueFrameContent)),
                ]
            )
        )

        // Then
        try compareWithSnapshot(image: canvas.image)
    }

    func testDrawBlueprintWithMultilineTextFrame() throws {
        // Given
        let canvas = FramerCanvas.create(size: .init(width: 400, height: 400))

        let container = Frame(rect: canvas.bounds)
            .inset(top: 40, left: 40, bottom: 40, right: 40)
        let frame = Frame(ofSize: .init(width: 200, height: 200))
            .putInside(container, alignTo: .topLeft)

        let blueprintFrame = frame.toBlueprintFrame(
            withStyle: .init(
                lineWidth: 1,
                lineColor: .black,
                fillColor: .white
            ),
            content: .init(
                contentType: .text(
                    text: """
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
                    """,
                    color: .purple,
                    font: .systemFont(ofSize: 8)
                ),
                horizontalAlignment: .center,
                verticalAlignment: .center
            )
        )

        // When
        canvas.draw(blueprint: Blueprint(contents: [.frame(blueprintFrame)]))

        // Then
        try compareWithSnapshot(image: canvas.image)
    }

    func testDrawBlueprintWithMultipleImageFrames() throws {
        guard #available(iOS 13.0, *) else { return }

        // Given
        let canvas = FramerCanvas.create(size: .init(width: 100, height: 100))

        let container = Frame(rect: canvas.bounds)
            .inset(top: 10, left: 10, bottom: 10, right: 10)

        let symbolNamesWithAlignments: [(String, BlueprintFrame.Content.Alignment, BlueprintFrame.Content.Alignment)] = [
            // (symbol name, horizontal alignment, vertical alignment)
            ("arrow.up", .center, .leading),
            ("arrow.up.left", .leading, .leading),
            ("arrow.up.right", .trailing, .leading),
            ("arrow.down", .center, .trailing),
            ("arrow.down.left", .leading, .trailing),
            ("arrow.down.right", .trailing, .trailing),
            ("arrow.left", .leading, .center),
            ("arrow.right", .trailing, .center),
            ("circle.hexagongrid.circle", .center, .center),
        ]

        let blueprint = Blueprint(
            contents: symbolNamesWithAlignments.map { symbolName, horizontalAlignment, verticalAlignment in
                return .frame(
                    container
                        .toBlueprintFrame(
                            withStyle: .init(),
                            content: .init(
                                contentType: .image(image: UIImage(systemName: symbolName)!.withTintColor(.yellow)),
                                horizontalAlignment: horizontalAlignment,
                                verticalAlignment: verticalAlignment
                            )
                        )
                )
            }
        )

        // When
        canvas.draw(blueprint: blueprint)

        // Then
        try compareWithSnapshot(image: canvas.image)
    }

    func testEraseBlueprints() throws {
        // Given
        let canvas = FramerCanvas.create(size: .init(width: 400, height: 400))

        let container = Frame(rect: FramerWindow.current.bounds)
            .inset(top: 40, left: 40, bottom: 40, right: 40)
        let frame1 = Frame(ofSize: .init(width: 200, height: 200))
            .putInside(container, alignTo: .topLeft)
        let frame2 = Frame(ofSize: .init(width: 200, height: 200))
            .putInside(container, alignTo: .topLeft)
            .offsetBy(x: 50, y: 50)
        let frame3 = Frame(ofSize: .init(width: 200, height: 200))
            .putInside(container, alignTo: .topLeft)
            .offsetBy(x: 100, y: 100)

        canvas.draw(
            blueprint: Blueprint(
                id: "blueprint 1",
                contents: [
                    .frame(frame1.toBlueprintFrame(withStyle: redFrameStyle, content: redFrameContent)),
                ]
            )
        )

        canvas.draw(
            blueprint: Blueprint(
                id: "blueprint 2",
                contents: [
                    .frame(frame2.toBlueprintFrame(withStyle: greenFrameStyle, content: greenFrameContent)),
                ]
            )
        )

        canvas.draw(
            blueprint: Blueprint(
                id: "blueprint 3",
                contents: [
                    .frame(frame3.toBlueprintFrame(withStyle: blueFrameStyle, content: blueFrameContent)),
                ]
            )
        )

        // When
        canvas.erase(blueprintID: "blueprint 2")

        // Then
        try compareWithSnapshot(image: canvas.image, imageFileSuffix: "-erase2")

        // When
        canvas.eraseAllBlueprints()

        // Then
        try compareWithSnapshot(image: canvas.image, imageFileSuffix: "-eraseAll")
    }

    // MARK: - Snapshoting

    private func compareWithSnapshot(
        image: UIImage,
        imageFileSuffix: String = "",
        file: StaticString = #filePath,
        function: StaticString = #function,
        line: UInt = #line
    ) throws {
        try compare(
            image: image,
            referenceImage: .inFolder(
                named: snapshotsFolderName,
                imageFileSuffix: imageFileSuffix,
                file: file,
                function: function
            ),
            record: recordMode,
            file: file,
            line: line
        )
    }
}

// MARK: - Convenience

internal extension Blueprint.Content {
    mutating func mutateFrame(_ mutation: (inout BlueprintFrame) -> Void) {
        switch self {
        case .frame(var value):
            mutation(&value)
            self = .frame(value)
        }
    }
}
