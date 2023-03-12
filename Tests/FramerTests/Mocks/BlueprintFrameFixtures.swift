import Framer

let redFrameStyle = BlueprintFrameStyle(
    lineWidth: 2, lineColor: .red, fillColor: .white, cornerRadius: 10, opacity: 1
)
let greenFrameStyle = BlueprintFrameStyle(
    lineWidth: 2, lineColor: .green, fillColor: .white, cornerRadius: 5, opacity: 0.75
)
let blueFrameStyle = BlueprintFrameStyle(
    lineWidth: 2, lineColor: .blue, fillColor: .white, cornerRadius: 2, opacity: 0.5
)

let redFrameContent = BlueprintFrameContent(
    contentType: .text(text: "Frame (red)", color: .red, font: .systemFont(ofSize: 20))
)
let greenFrameContent = BlueprintFrameContent(
    contentType: .text(text: "Frame (green)", color: .green, font: .systemFont(ofSize: 15))
)
let blueFrameContent = BlueprintFrameContent(
    contentType: .text(text: "Frame (blue)", color: .blue, font: .systemFont(ofSize: 10))
)
