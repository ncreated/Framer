import UIKit
import Framing

internal struct CanvasRenderer {
    private let renderer: UIGraphicsImageRenderer

    init(size: CGSize) {
        let format = UIGraphicsImageRendererFormat()
        self.renderer = UIGraphicsImageRenderer(size: size, format: format)
    }

    func render(state: CanvasState) -> UIImage {
        return renderer.image { context in
            state.blueprints.forEach { blueprint in
                // First, draw each content:
                blueprint.contents.forEach { content in
                    switch content {
                    case .frame(let frame): draw(blueprintFrame: frame, in: context)
                    case .line(let line):   draw(blueprintLine: line, in: context)
                    }
                }

                // Then, draw annotations:
                drawAnnotations(for: blueprint, in: context)
            }
        }
    }

    // MARK: - Drawing `BlueprintFrame`

    private func draw(blueprintFrame: BlueprintFrame, in context: UIGraphicsImageRendererContext) {
        let rect = rect(from: blueprintFrame)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: blueprintFrame.style.cornerRadius)

        context.cgContext.setAlpha(blueprintFrame.style.opacity)

        // Fill:
        context.cgContext.setFillColor(blueprintFrame.style.fillColor.cgColor)
        context.cgContext.addPath(path.cgPath)
        context.cgContext.fillPath()

        // Stroke:
        context.cgContext.setLineWidth(blueprintFrame.style.lineWidth)
        context.cgContext.setStrokeColor(blueprintFrame.style.lineColor.cgColor)
        context.cgContext.addPath(path.cgPath)
        context.cgContext.strokePath()

        // Content:
        drawContent(for: blueprintFrame, in: context)
    }

    private func drawContent(for blueprintFrame: BlueprintFrame, in context: UIGraphicsImageRendererContext) {
        guard let content = blueprintFrame.content else {
            return
        }

        switch content.contentType {
        case let .text(text, color, font):
            let rect = rect(from: blueprintFrame)
            let paragraphStyle = NSMutableParagraphStyle()

            switch content.horizontalAlignment {
            case .leading:  paragraphStyle.alignment = .left
            case .center:   paragraphStyle.alignment = .center
            case .trailing: paragraphStyle.alignment = .right
            }

            let textAttributes: [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: color,
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
            ]

            let attributedText = NSAttributedString(string: text, attributes: textAttributes)

            let options: NSStringDrawingOptions = [.usesLineFragmentOrigin]
            let bb = attributedText.boundingRect(with: rect.size, options: options, context: nil)
            let textRect: CGRect
            switch content.verticalAlignment {
            case .leading:
                textRect = .init(x: rect.minX, y: rect.minY, width: rect.width, height: bb.height)
            case .center:
                textRect = .init(x: rect.minX, y: rect.minY + (rect.height - bb.height) / 2, width: rect.width, height: bb.height)
            case .trailing:
                textRect = .init(x: rect.minX, y: rect.maxY - bb.height, width: rect.width, height: bb.height)
            }

            attributedText.draw(in: textRect)

        case let .image(image):
            let containerFrame = Frame(rect: rect(from: blueprintFrame))
            let imageFrame = Frame(ofSize: image.size)
                .putInside(containerFrame, alignTo: frameInsideAlignment(from: content.horizontalAlignment, content.verticalAlignment))

            image.draw(in: imageFrame.rect)
        }
    }

    private func drawAnnotations(for blueprint: Blueprint, in context: UIGraphicsImageRendererContext) {
        // Tracks already drawn annotations in this renderer pass. This is to find eventual collisions
        // and mark colliding annotation with red stroke:
        var drawnAnnotationFrames: [Frame] = []

        blueprint.contents
            .compactMap { $0.frameAndAnnotation }
            .forEach { blueprintFrame, annotation in
            let annotatedFrame = Frame(rect: rect(from: blueprintFrame))
            let (backgroundColor, foregroundColor) = annotationColors(for: blueprintFrame.style)

            let textAttributes: [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: annotation.style.size.rawValue),
                NSAttributedString.Key.foregroundColor: foregroundColor
            ]

            var annotationFrame = Frame(ofSize: annotation.text.size(withAttributes: textAttributes))
            annotationFrame = adjust(
                position: annotation.style.position,
                alignment: annotation.style.alignment,
                of: annotationFrame,
                for: annotatedFrame
            )

            context.cgContext.setFillColor(backgroundColor.cgColor)
            context.cgContext.fill(annotationFrame.rect)

            annotation.text.draw(in: annotationFrame.rect, withAttributes: textAttributes)

            // Mark collisions:
            let collides = drawnAnnotationFrames.contains(where: { $0.rect.intersects(annotationFrame.rect) })

            if collides {
                context.cgContext.setLineWidth(2)
                context.cgContext.setStrokeColor(UIColor.red.cgColor)
                context.cgContext.stroke(annotationFrame.rect)
            }

            drawnAnnotationFrames.append(annotationFrame)
        }
    }

    // MARK: - Drawing `BlueprintLine`

    private func draw(blueprintLine: BlueprintLine, in context: UIGraphicsImageRendererContext) {
        context.cgContext.setLineWidth(blueprintLine.style.lineWidth)
        context.cgContext.setStrokeColor(blueprintLine.style.lineColor.cgColor)
        context.cgContext.setAlpha(blueprintLine.style.opacity)
        context.cgContext.move(to: blueprintLine.from)
        context.cgContext.addLine(to: blueprintLine.to)
        context.cgContext.strokePath()
    }

    // MARK: - Helpers

    private func rect(from blueprintFrame: BlueprintFrame) -> CGRect {
        return CGRect(
            x: blueprintFrame.x,
            y: blueprintFrame.y,
            width: blueprintFrame.width,
            height: blueprintFrame.height
        )
    }

    private func annotationColors(for style: BlueprintFrame.Style) -> (background: UIColor, foreground: UIColor) {
        if style.fillColor.alpha > 0.1 {
            return (style.fillColor, style.fillColor.contrast(by: 100))
        } else if style.lineColor.alpha > 0.1 {
            return (style.lineColor, style.lineColor.contrast(by: 100))
        } else {
            return (UIColor.lightGray, UIColor.gray)
        }
    }

    private func adjust(
        position: BlueprintFrame.Annotation.Style.Position,
        alignment: BlueprintFrame.Annotation.Style.Alignment,
        of annotationFrame: Frame,
        for annotatedFrame: Frame
    ) -> Frame {
        switch position {
        case .top:
            return annotationFrame.putAbove(annotatedFrame, alignTo: frameHorizontalAlignment(from: alignment))
        case .bottom:
            return annotationFrame.putBelow(annotatedFrame, alignTo: frameHorizontalAlignment(from: alignment))
        case .left:
            return annotationFrame.putOnLeft(of: annotatedFrame, alignTo: frameVerticalAlignment(from: alignment))
        case .right:
            return annotationFrame.putOnRight(of: annotatedFrame, alignTo: frameVerticalAlignment(from: alignment))
        }
    }

    private func frameHorizontalAlignment(from annotationAlignment: BlueprintFrame.Annotation.Style.Alignment) -> Frame.HorizontalAlignment {
        switch annotationAlignment {
        case .leading:  return .left
        case .center:   return .center
        case .trailing: return .right
        }
    }

    private func frameVerticalAlignment(from annotationAlignment: BlueprintFrame.Annotation.Style.Alignment) -> Frame.VerticalAlignment {
        switch annotationAlignment {
        case .leading:  return .top
        case .center:   return .middle
        case .trailing: return .bottom
        }
    }

    private func frameInsideAlignment(from horizontalAlignment: BlueprintFrame.Content.Alignment, _ verticalAlignment: BlueprintFrame.Content.Alignment) -> Frame.InsideAlignment {
        switch (horizontalAlignment, verticalAlignment) {
        case (.leading, .leading):      return .topLeft
        case (.leading, .center):       return .middleLeft
        case (.leading, .trailing):     return .bottomLeft
        case (.center, .leading):       return .topCenter
        case (.center, .center):        return .middleCenter
        case (.center, .trailing):      return .bottomCenter
        case (.trailing, .leading):     return .topRight
        case (.trailing, .center):      return .middleRight
        case (.trailing, .trailing):    return .bottomRight
        }
    }
}

// MARK: - Convenience

private extension Blueprint.Content {
    var frameAndAnnotation: (BlueprintFrame, BlueprintFrame.Annotation)? {
        switch self {
        case .frame(let frame):
            return frame.annotation.map { (frame, $0) }
        default:
            return nil
        }
    }
}
