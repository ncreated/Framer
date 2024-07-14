import Foundation
import UIKit

public struct Blueprint: Equatable {
    public struct ID: ExpressibleByStringLiteral, Hashable, Equatable {
        internal let value: String

        public init(stringLiteral value: String) {
            self.value = value
        }
    }

    public enum Content: Equatable {
        case frame(BlueprintFrame)
        case line(BlueprintLine)
        // TODO: case path(BlueprintPath)
    }

    public var id: ID
    public var contents: [Content]

    public init(
        id: ID = .init(stringLiteral: UUID().uuidString),
        contents: [Content]
    ) {
        self.id = id
        self.contents = contents
    }
}

public struct BlueprintFrame: Equatable {
    public var x: CGFloat
    public var y: CGFloat
    public var width: CGFloat
    public var height: CGFloat
    public var style: Style
    public var content: Content?
    public var annotation: Annotation?

    public init(
        x: CGFloat = 0,
        y: CGFloat = 0,
        width: CGFloat = 0,
        height: CGFloat = 0,
        style: Style = .init(),
        content: Content? = nil,
        annotation: Annotation? = nil
    ) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.style = style
        self.content = content
        self.annotation = annotation
    }

    public struct Style: Equatable {
        public var lineWidth: CGFloat
        public var lineColor: UIColor
        public var fillColor: UIColor
        public var cornerRadius: CGFloat
        public var opacity: CGFloat

        public init(
            lineWidth: CGFloat = 1,
            lineColor: UIColor = .black,
            fillColor: UIColor = .clear,
            cornerRadius: CGFloat = 0,
            opacity: CGFloat = 0.75
        ) {
            self.lineWidth = lineWidth
            self.lineColor = lineColor
            self.fillColor = fillColor
            self.cornerRadius = cornerRadius
            self.opacity = opacity
        }
    }

    public struct Content: Equatable {
        public enum ContentType: Equatable {
            case text(text: String, color: UIColor, font: UIFont)
            case image(image: UIImage)
        }

        public var contentType: ContentType
        public var horizontalAlignment: Alignment
        public var verticalAlignment: Alignment

        public enum Alignment: Equatable {
            case leading
            case center
            case trailing
        }

        public init(
            contentType: ContentType,
            horizontalAlignment: Alignment = .leading,
            verticalAlignment: Alignment = .leading
        ) {
            self.contentType = contentType
            self.horizontalAlignment = horizontalAlignment
            self.verticalAlignment = verticalAlignment
        }
    }

    public struct Annotation: Equatable {
        public var text: String
        public var style: Style

        public init(
            text: String,
            style: Style = .init()
        ) {
            self.text = text
            self.style = style
        }

        public struct Style: Equatable {
            public var size: Size
            public var position: Position
            public var alignment: Alignment

            public enum Size: CGFloat {
                case tiny = 6
                case small = 8
                case normal = 12
                case large = 16
            }

            public enum Position: Equatable {
                case top
                case bottom
                case left
                case right
            }

            public enum Alignment: Equatable {
                case leading
                case center
                case trailing
            }

            public init(
                size: Size = .normal,
                position: Position = .top,
                alignment: Alignment = .leading
            ) {
                self.size = size
                self.position = position
                self.alignment = alignment
            }
        }
    }
}

public struct BlueprintLine: Equatable {
    public var from: CGPoint
    public var to: CGPoint
    public var style: Style

    public init(
        from: CGPoint,
        to: CGPoint,
        style: BlueprintLine.Style
    ) {
        self.from = from
        self.to = to
        self.style = style
    }

    public struct Style: Equatable {
        public var lineWidth: CGFloat
        public var lineColor: UIColor
        public var opacity: CGFloat

        public init(
            lineWidth: CGFloat = 1,
            lineColor: UIColor = .black,
            opacity: CGFloat = 0.75
        ) {
            self.lineWidth = lineWidth
            self.lineColor = lineColor
            self.opacity = opacity
        }
    }
}
