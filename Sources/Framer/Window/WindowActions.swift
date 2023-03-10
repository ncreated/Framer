import Foundation

internal enum WindowAction: Equatable {

    // MARK: - Actions from public APIs

    /// Draws given blueprint (or updates existing one).
    case draw(blueprint: Blueprint)

    /// Removes existing blueprint.
    case erase(blueprintID: Blueprint.ID)

    /// Removes all existing blueprints.
    case eraseAllBlueprints

    /// Adds a button that calls attached closure.
    case add(button: Button)

    case showBlueprints

    case hideBlueprints

    // MARK: - Types

    struct Button: Equatable {
        /// The title of a button.
        let title: String
        /// The closure to call when button is tapped.
        let action: () -> Void

        static func == (lhs: Button, rhs: Button) -> Bool {
            return lhs.title == rhs.title
        }
    }
}
