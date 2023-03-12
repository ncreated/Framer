import Foundation
import UIKit
@testable import Framer

extension Blueprint: AnyMockable, RandomMockable {
    static func mockAny() -> Blueprint {
        return .mockWith()
    }

    static func mockRandom() -> Blueprint {
        return Blueprint(
            id: .mockRandom(),
            contents: .mockRandom()
        )
    }

    static func mockRandomWith(blueprintID: ID) -> Blueprint {
        var random: Blueprint = .mockRandom()
        random.id = blueprintID
        return random
    }

    static func mockRandomWith(id: String) -> Blueprint {
        return mockRandomWith(blueprintID: .init(stringLiteral: id))
    }

    static func mockWith(
        id: ID = .mockAny(),
        contents: [Content] = .mockAny()
    ) -> Blueprint {
        return Blueprint(id: id, contents: contents)
    }
}

extension Blueprint.ID: AnyMockable, RandomMockable {
    static func mockAny() -> Blueprint.ID {
        return .mockWith()
    }

    static func mockRandom() -> Blueprint.ID {
        return Blueprint.ID(
            stringLiteral: .mockRandom()
        )
    }

    static func mockWith(
        stringLiteral: String = .mockAny()
    ) -> Blueprint.ID {
        return Blueprint.ID(
            stringLiteral: stringLiteral
        )
    }
}

extension Blueprint.Content: AnyMockable, RandomMockable {
    static func mockAny() -> Blueprint.Content {
        return .frame(.mockAny())
    }

    static func mockRandom() -> Blueprint.Content {
        return .frame(.mockRandom())
    }
}

extension BlueprintFrame.Annotation: AnyMockable, RandomMockable {
    static func mockAny() -> BlueprintFrame.Annotation {
        return .mockWith()
    }

    static func mockRandom() -> BlueprintFrame.Annotation {
        return BlueprintFrame.Annotation(
            text: .mockRandom(),
            style: .mockRandom()
        )
    }

    static func mockWith(
        text: String = .mockAny(),
        style: BlueprintFrame.Annotation.Style = .mockAny()
    ) -> BlueprintFrame.Annotation {
        return BlueprintFrame.Annotation(
            text: text,
            style: style
        )
    }
}

extension BlueprintFrame.Annotation.Style: AnyMockable, RandomMockable {
    static func mockAny() -> BlueprintFrame.Annotation.Style {
        return .init()
    }

    static func mockRandom() -> BlueprintFrame.Annotation.Style {
        return .init(
            size: .mockRandom(),
            position: .mockRandom(),
            alignment: .mockRandom()
        )
    }
}

extension BlueprintFrame.Annotation.Style.Alignment: AnyMockable, RandomMockable {
    static func mockAny() -> BlueprintFrame.Annotation.Style.Alignment {
        return .leading
    }

    static func mockRandom() -> BlueprintFrame.Annotation.Style.Alignment {
        return [
            .leading,
            .center,
            .trailing
        ].randomElement()!
    }
}

extension BlueprintFrame.Annotation.Style.Position: AnyMockable, RandomMockable {
    static func mockAny() -> BlueprintFrame.Annotation.Style.Position {
        return .top
    }

    static func mockRandom() -> BlueprintFrame.Annotation.Style.Position {
        return [
            .top,
            .bottom,
            .left,
            .right
        ].randomElement()!
    }
}

extension BlueprintFrame.Annotation.Style.Size: AnyMockable, RandomMockable {
    static func mockAny() -> BlueprintFrame.Annotation.Style.Size {
        return .tiny
    }

    static func mockRandom() -> BlueprintFrame.Annotation.Style.Size {
        return [
            .tiny,
            .small,
            .normal,
            .large
        ].randomElement()!
    }
}

extension BlueprintFrame.Content: AnyMockable, RandomMockable {
    static func mockAny() -> BlueprintFrame.Content {
        return .mockWith()
    }

    static func mockRandom() -> BlueprintFrame.Content {
        return BlueprintFrame.Content(
            contentType: .mockRandom(),
            horizontalAlignment: .mockRandom(),
            verticalAlignment: .mockRandom()
        )
    }

    static func mockWith(
        contentType: ContentType = .mockAny(),
        horizontalAlignment: Alignment = .mockAny(),
        verticalAlignment: Alignment = .mockAny()
    ) -> BlueprintFrame.Content {
        return BlueprintFrame.Content(
            contentType: contentType,
            horizontalAlignment: horizontalAlignment,
            verticalAlignment: verticalAlignment
        )
    }
}

extension BlueprintFrame.Content.ContentType: AnyMockable, RandomMockable {
    static func mockAny() -> BlueprintFrame.Content.ContentType {
        return .text(text: .mockAny(), color: .mockAny(), font: .mockAny())
    }

    static func mockRandom() -> BlueprintFrame.Content.ContentType {
        return .text(text: .mockRandom(), color: .mockRandom(), font: .mockRandom())
    }
}

extension BlueprintFrame.Content.Alignment: AnyMockable, RandomMockable {
    static func mockAny() -> BlueprintFrame.Content.Alignment {
        return .center
    }

    static func mockRandom() -> BlueprintFrame.Content.Alignment {
        return [.leading, .center, .trailing].randomElement()!
    }
}

extension BlueprintFrame.Style: AnyMockable, RandomMockable {
    static func mockAny() -> BlueprintFrame.Style {
        return .mockWith()
    }

    static func mockRandom() -> BlueprintFrame.Style {
        return BlueprintFrame.Style(
            lineWidth: .mockRandom(),
            lineColor: .mockRandom(),
            fillColor: .mockRandom(),
            cornerRadius: .mockRandom(),
            opacity: .mockRandom()
        )
    }

    static func mockWith(
        lineWidth: CGFloat = .mockAny(),
        lineColor: UIColor = .mockAny(),
        fillColor: UIColor = .mockAny(),
        cornerRadius: CGFloat = .mockAny(),
        opacity: CGFloat = .mockAny()
    ) -> BlueprintFrame.Style {
        return BlueprintFrame.Style(
            lineWidth: lineWidth,
            lineColor: lineColor,
            fillColor: fillColor,
            cornerRadius: cornerRadius,
            opacity: opacity
        )
    }
}

extension BlueprintFrame: AnyMockable, RandomMockable {
    static func mockAny() -> BlueprintFrame {
        return .mockWith()
    }

    static func mockRandom() -> BlueprintFrame {
        return BlueprintFrame(
            x: .mockRandom(),
            y: .mockRandom(),
            width: .mockRandom(),
            height: .mockRandom(),
            style: .mockRandom(),
            content: .mockRandom(),
            annotation: .mockRandom()
        )
    }

    static func mockWith(
        x: CGFloat = .mockAny(),
        y: CGFloat = .mockAny(),
        width: CGFloat = .mockAny(),
        height: CGFloat = .mockAny(),
        style: BlueprintFrame.Style = .mockAny(),
        content: BlueprintFrame.Content? = .mockAny(),
        annotation: BlueprintFrame.Annotation? = .mockAny()
    ) -> BlueprintFrame {
        return BlueprintFrame(
            x: x,
            y: y,
            width: width,
            height: height,
            style: style,
            content: content,
            annotation: annotation
        )
    }
}
