import Framing

public extension Frame {
    /// Converts `Framing.Frame` to `Framer.BlueprintFrame` with given style.
    func toBlueprintFrame(
        withStyle style: BlueprintFrame.Style,
        content: BlueprintFrame.Content? = nil,
        annotation: BlueprintFrame.Annotation? = nil
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
