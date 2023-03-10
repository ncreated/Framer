import XCTest
@testable import Framer

class WindowStateTests: XCTestCase {
    private let reducer = WindowStateReducer()

    func testDrawingNewBlueprint() {
        // Given
        var state: WindowState = .mockRandom()
        state.blueprints = []

        // When
        let blueprint: Blueprint = .mockRandom()
        let newState = reducer.reduce(currentState: state, on: .draw(blueprint: blueprint))

        // Then
        XCTAssertEqual(newState.blueprints.count, 1)
        XCTAssertEqual(newState.blueprints[0].blueprint, blueprint)
        XCTAssertTrue(newState.blueprints[0].isVisible, "New blueprint should be visible by default")
    }

    func testUpdatingExistingBlueprint() {
        // Given
        var state: WindowState = .mockRandom()
        state.blueprints = [
            .init(blueprint: .mockRandomWith(id: "1"), isVisible: .mockRandom()),
            .init(blueprint: .mockRandomWith(id: "2"), isVisible: .mockRandom()),
            .init(blueprint: .mockRandomWith(id: "3"), isVisible: .mockRandom()),
        ]

        // When
        let blueprint: Blueprint = .mockRandomWith(id: "2")
        let newState = reducer.reduce(currentState: state, on: .draw(blueprint: blueprint))

        // Then
        XCTAssertEqual(newState.blueprints.count, 3)
        XCTAssertEqual(newState.blueprints[0], state.blueprints[0])
        XCTAssertEqual(newState.blueprints[1].blueprint, blueprint)
        XCTAssertEqual(newState.blueprints[1].isVisible, state.blueprints[1].isVisible)
        XCTAssertEqual(newState.blueprints[2], state.blueprints[2])
    }

    func testErasingBlueprint() {
        // Given
        var state: WindowState = .mockRandom()
        state.blueprints = [
            .init(blueprint: .mockRandomWith(id: "1"), isVisible: .mockRandom()),
            .init(blueprint: .mockRandomWith(id: "2"), isVisible: .mockRandom()),
            .init(blueprint: .mockRandomWith(id: "3"), isVisible: .mockRandom()),
        ]

        // When
        let newState = reducer.reduce(currentState: state, on: .erase(blueprintID: "2"))

        // Then
        XCTAssertEqual(newState.blueprints.count, 2)
        XCTAssertEqual(newState.blueprints[0], state.blueprints[0])
        XCTAssertEqual(newState.blueprints[1], state.blueprints[2])
    }

    func testErasingAllBlueprints() {
        // Given
        var state: WindowState = .mockRandom()
        state.blueprints = [
            .init(blueprint: .mockRandomWith(id: "1"), isVisible: .mockRandom()),
            .init(blueprint: .mockRandomWith(id: "2"), isVisible: .mockRandom()),
            .init(blueprint: .mockRandomWith(id: "3"), isVisible: .mockRandom()),
        ]

        // When
        let newState = reducer.reduce(currentState: state, on: .eraseAllBlueprints)

        // Then
        XCTAssertTrue(newState.blueprints.isEmpty)
    }

    func testAddingButton() {
        let button1Action = expectation(description: "Called button1's action")
        let button2Action = expectation(description: "Called button2's action")

        // Given
        var state: WindowState = .mockRandom()
        state.buttons = []

        // When
        let button1Title: String = .mockRandom()
        var newState = reducer.reduce(currentState: state, on: .add(button: .init(title: button1Title, action: button1Action.fulfill)))

        let button2Title: String = .mockRandom()
        newState = reducer.reduce(currentState: newState, on: .add(button: .init(title: button2Title, action: button2Action.fulfill)))

        // Then
        XCTAssertEqual(newState.buttons.count, 2)
        XCTAssertEqual(newState.buttons[0].title, button1Title)
        XCTAssertEqual(newState.buttons[1].title, button2Title)
        newState.buttons[0].action()
        newState.buttons[1].action()
        wait(for: [button1Action, button2Action], timeout: 1, enforceOrder: true)
    }

    func testShowingBlueprints() {
        // Given
        var state: WindowState = .mockRandom()
        state.isShowingBlueprints = false
        state.blueprints = .mockRandom()

        // When
        let newState = reducer.reduce(currentState: state, on: .showBlueprints)

        // Then
        XCTAssertTrue(newState.isShowingBlueprints)
    }

    func testHidingBlueprints() {
        // Given
        var state: WindowState = .mockRandom()
        state.isShowingBlueprints = true
        state.blueprints = .mockRandom()

        // When
        let newState = reducer.reduce(currentState: state, on: .hideBlueprints)

        // Then
        XCTAssertFalse(newState.isShowingBlueprints)
    }
}
