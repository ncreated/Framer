# Framer

Framer is a lightweight and easy-to-use overlay window that lets you draw geometry and text on top of your iOS app.

## Annotate SwiftUI view frames

Whether you're a designer looking to quickly prototype your ideas or a developer who needs to add visual annotations to your app, Framer makes it easy to create and customize overlays that fit your needs.

```swift
import SwiftUI
import Framer

FramerWindow.install(startHidden: false)

VStack(alignment: .leading, spacing: 20) {
    Text("Framer")
        .font(.system(size: 40, weight: .bold))
        .foregroundColor(Color("EB455F"))
        .frameIt("Title")
    Text("What is Framer?")
        .font(.headline)
        .frameIt("Headline")
    Text("Framer is a basic canvas for drawing \"blueprints\" on." +
         "It can be rendered to standalone image or displayed in overlay window.")
        .font(.body)
        .frameIt("Body")
    HStack {
        Spacer()
        .frameIt("Spacer")
        Image(systemName: "photo.artframe")
            .resizable(resizingMode: .stretch)
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: 40, maxHeight: 40)
            .foregroundColor(Color("2B3467"))
    }
}
.frameIt(
    "VStack",
     frameStyle: .init(lineColor: .blue),
     annotationStyle: .init(position: .bottom, alignment: .center)
)
```
