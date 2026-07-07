import XCTest
@testable import Appspend

@MainActor
final class AppspendTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
        store.items = []
    }

    func testAddIncreasesCount() {
        let before = store.items.count
        store.add(AppspendItem())
        XCTAssertEqual(store.items.count, before + 1)
    }

    func testFreeLimitBlocksAdditionalAdds() {
        store.items = (0..<Store.freeLimit).map { _ in AppspendItem() }
        XCTAssertFalse(store.canAddMore)
        store.add(AppspendItem())
        XCTAssertEqual(store.items.count, Store.freeLimit)
    }

    func testProUnlocksBeyondLimit() {
        store.items = (0..<Store.freeLimit).map { _ in AppspendItem() }
        store.isPro = true
        XCTAssertTrue(store.canAddMore)
        store.add(AppspendItem())
        XCTAssertEqual(store.items.count, Store.freeLimit + 1)
    }

    func testDeleteAtOffsets() {
        store.items = [AppspendItem(), AppspendItem(), AppspendItem()]
        store.delete(at: IndexSet(integer: 1))
        XCTAssertEqual(store.items.count, 2)
    }

    func testDeleteSpecificItem() {
        let item = AppspendItem()
        store.items = [item]
        store.delete(item)
        XCTAssertTrue(store.items.isEmpty)
    }

    func testUpdateReplacesItem() {
        var item = AppspendItem()
        store.items = [item]
        item.createdAt = Date.distantPast
        store.update(item)
        XCTAssertEqual(store.items.first?.createdAt, Date.distantPast)
    }

    func testSeedDataNotEmpty() {
        XCTAssertFalse(Store.seedData().isEmpty)
    }

    func testSeedDataBelowFreeLimit() {
        XCTAssertLessThan(Store.seedData().count, Store.freeLimit)
    }
}
