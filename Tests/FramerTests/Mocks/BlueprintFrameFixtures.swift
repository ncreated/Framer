import Framer

let redFrameStyle = BlueprintFrame.Style(
    lineWidth: 2, lineColor: .red, fillColor: .white, cornerRadius: 10, opacity: 1
)
let greenFrameStyle = BlueprintFrame.Style(
    lineWidth: 2, lineColor: .green, fillColor: .white, cornerRadius: 5, opacity: 0.75
)
let blueFrameStyle = BlueprintFrame.Style(
    lineWidth: 2, lineColor: .blue, fillColor: .white, cornerRadius: 2, opacity: 0.5
)

let redFrameContent = BlueprintFrame.Content(
    contentType: .text(text: "Frame (red)", color: .red, font: .systemFont(ofSize: 20))
)
let greenFrameContent = BlueprintFrame.Content(
    contentType: .text(text: "Frame (green)", color: .green, font: .systemFont(ofSize: 15))
)
let blueFrameContent = BlueprintFrame.Content(
    contentType: .text(text: "Frame (blue)", color: .blue, font: .systemFont(ofSize: 10))
)
