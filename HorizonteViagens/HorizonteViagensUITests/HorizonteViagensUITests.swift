import XCTest

final class HorizonteViagensUITests: XCTestCase {
    @MainActor
    func testDetalhesEReservaIlustrativa() {
        let app = XCUIApplication()
        app.launch()
        let titulo = app.staticTexts["Dias de sol em Noronha"].firstMatch
        XCTAssertTrue(titulo.waitForExistence(timeout: 10))
        titulo.tap()
        let reservar = app.buttons["reservarPacote"]
        XCTAssertTrue(reservar.waitForExistence(timeout: 5))
        reservar.tap()
        XCTAssertTrue(app.alerts["Vamos imaginar essa viagem?"].waitForExistence(timeout: 5))
        app.buttons["Entendi"].tap()
    }
}
