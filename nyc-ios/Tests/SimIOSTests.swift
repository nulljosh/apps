import XCTest
@testable import TimesSquareSimIOS

@MainActor
final class SimIOSTests: XCTestCase {

    // MARK: - ColonistModel

    func testColonistInitialValues() {
        let c = ColonistModel(id: UUID(), name: "Test", col: 5, row: 5)
        XCTAssertEqual(c.hunger, 100)
        XCTAssertEqual(c.oxygen, 100)
        XCTAssertEqual(c.stress, 0)
        XCTAssertEqual(c.sleep, 100)
        XCTAssertEqual(c.health, 100)
        XCTAssertEqual(c.job, .idle)
        XCTAssertEqual(c.state, .healthy)
        XCTAssertEqual(c.weapon, .fists)
        XCTAssertEqual(c.level, 1)
        XCTAssertEqual(c.xp, 0)
        XCTAssertFalse(c.isDead)
        XCTAssertFalse(c.jobOverride)
    }

    func testColonistTakeDamage() {
        var c = ColonistModel(id: UUID(), name: "Test", col: 0, row: 0)
        c.takeDamage(30)
        XCTAssertEqual(c.health, 70)
        XCTAssertNotEqual(c.state, .dead)
    }

    func testColonistTakeDamageKills() {
        var c = ColonistModel(id: UUID(), name: "Test", col: 0, row: 0)
        c.takeDamage(150)
        XCTAssertEqual(c.health, 0)
        XCTAssertEqual(c.state, .dead)
    }

    func testColonistTakeDamageExactlyZero() {
        var c = ColonistModel(id: UUID(), name: "Test", col: 0, row: 0)
        c.takeDamage(100)
        XCTAssertEqual(c.health, 0)
        XCTAssertEqual(c.state, .dead)
    }

    func testColonistUpdateStateHungry() {
        var c = ColonistModel(id: UUID(), name: "Test", col: 0, row: 0)
        c.hunger = 15
        c.updateState()
        XCTAssertEqual(c.state, .hungry)
    }

    func testColonistUpdateStateSuffocating() {
        var c = ColonistModel(id: UUID(), name: "Test", col: 0, row: 0)
        c.oxygen = 15
        c.updateState()
        XCTAssertEqual(c.state, .suffocating)
    }

    func testColonistUpdateStateExhausted() {
        var c = ColonistModel(id: UUID(), name: "Test", col: 0, row: 0)
        c.sleep = 15
        c.updateState()
        XCTAssertEqual(c.state, .exhausted)
    }

    func testColonistUpdateStateDeadFromZeroHunger() {
        var c = ColonistModel(id: UUID(), name: "Test", col: 0, row: 0)
        c.hunger = 0
        c.updateState()
        XCTAssertEqual(c.state, .dead)
    }

    func testColonistUpdateStateDeadFromZeroOxygen() {
        var c = ColonistModel(id: UUID(), name: "Test", col: 0, row: 0)
        c.oxygen = 0
        c.updateState()
        XCTAssertEqual(c.state, .dead)
    }

    func testColonistUpdateStateDeadFromZeroSleep() {
        var c = ColonistModel(id: UUID(), name: "Test", col: 0, row: 0)
        c.sleep = 0
        c.updateState()
        XCTAssertEqual(c.state, .dead)
    }

    func testColonistUpdateStateDeadFromZeroHealth() {
        var c = ColonistModel(id: UUID(), name: "Test", col: 0, row: 0)
        c.health = 0
        c.updateState()
        XCTAssertEqual(c.state, .dead)
    }

    func testColonistUpdateStateStaysDead() {
        var c = ColonistModel(id: UUID(), name: "Test", col: 0, row: 0)
        c.state = .dead
        c.hunger = 100
        c.oxygen = 100
        c.sleep = 100
        c.health = 100
        c.updateState()
        XCTAssertEqual(c.state, .dead)
    }

    func testColonistUpdateStateHealthyWhenAllGood() {
        var c = ColonistModel(id: UUID(), name: "Test", col: 0, row: 0)
        c.hunger = 50
        c.oxygen = 50
        c.sleep = 50
        c.updateState()
        XCTAssertEqual(c.state, .healthy)
    }

    func testColonistUpdateStatePriorityHungerOverOxygen() {
        var c = ColonistModel(id: UUID(), name: "Test", col: 0, row: 0)
        c.hunger = 10
        c.oxygen = 10
        c.updateState()
        XCTAssertEqual(c.state, .hungry)
    }

    func testColonistGrantXPBasic() {
        var c = ColonistModel(id: UUID(), name: "Test", col: 0, row: 0)
        c.trait = .scavenger
        c.grantXP(50)
        XCTAssertEqual(c.xp, 50)
        XCTAssertEqual(c.level, 1)
    }

    func testColonistGrantXPLevelUp() {
        var c = ColonistModel(id: UUID(), name: "Test", col: 0, row: 0)
        c.trait = .scavenger
        let oldLevel = c.level
        c.grantXP(c.xpForNextLevel)
        XCTAssertEqual(c.level, oldLevel + 1)
        XCTAssertEqual(c.xp, 0)
    }

    func testColonistGrantXPMultipleLevelUps() {
        var c = ColonistModel(id: UUID(), name: "Test", col: 0, row: 0)
        c.trait = .scavenger
        c.grantXP(500)
        XCTAssertGreaterThan(c.level, 1)
    }

    func testColonistHustlerTraitXPBoost() {
        var c = ColonistModel(id: UUID(), name: "Test", col: 0, row: 0)
        c.trait = .hustler
        c.grantXP(100)
        XCTAssertEqual(c.xp, 20)
        XCTAssertEqual(c.level, 2)
    }

    func testColonistMovementSpeedScalesWithAgi() {
        var c = ColonistModel(id: UUID(), name: "Test", col: 0, row: 0)
        c.stats = ColonistStats(str: 5, int: 5, agi: 5, end: 5, cha: 5)
        XCTAssertEqual(c.movementSpeed, 1.5, accuracy: 0.001)
        c.stats.agi = 10
        XCTAssertEqual(c.movementSpeed, 2.0, accuracy: 0.001)
    }

    func testColonistHungerDecayScalesWithEnd() {
        var c = ColonistModel(id: UUID(), name: "Test", col: 0, row: 0)
        c.stats = ColonistStats(str: 5, int: 5, agi: 5, end: 10, cha: 5)
        XCTAssertEqual(c.hungerDecayMultiplier, 0.5, accuracy: 0.001)
    }

    func testColonistBuildDiscountScalesWithInt() {
        var c = ColonistModel(id: UUID(), name: "Test", col: 0, row: 0)
        c.stats = ColonistStats(str: 5, int: 10, agi: 5, end: 5, cha: 5)
        XCTAssertEqual(c.buildDiscount, 0.2, accuracy: 0.001)
    }

    func testColonistPathAdvance() {
        var c = ColonistModel(id: UUID(), name: "Test", col: 0, row: 0)
        c.pathCols = [1, 2, 3]
        c.pathRows = [1, 2, 3]
        c.pathIndex = 0
        XCTAssertTrue(c.hasPath)
        c.advancePath()
        XCTAssertEqual(c.pathIndex, 1)
    }

    func testColonistPathAdvanceBeyondEnd() {
        var c = ColonistModel(id: UUID(), name: "Test", col: 0, row: 0)
        c.pathCols = [1]
        c.pathRows = [1]
        c.pathIndex = 0
        c.advancePath()
        c.advancePath()
        XCTAssertEqual(c.pathIndex, 1)
    }

    func testColonistHasPathWhenEmpty() {
        let c = ColonistModel(id: UUID(), name: "Test", col: 0, row: 0)
        XCTAssertFalse(c.hasPath)
    }

    func testColonistLowestNeed() {
        var c = ColonistModel(id: UUID(), name: "Test", col: 0, row: 0)
        c.hunger = 30
        c.oxygen = 50
        c.sleep = 40
        XCTAssertEqual(c.lowestNeed, 30)
    }

    // MARK: - ColonistStats

    func testColonistStatsRandom() {
        let stats = ColonistStats.random()
        XCTAssertGreaterThanOrEqual(stats.str, 1)
        XCTAssertLessThanOrEqual(stats.str, 10)
    }

    func testColonistStatsBoostRandomCapsAtTen() {
        var stats = ColonistStats(str: 10, int: 10, agi: 10, end: 10, cha: 10)
        stats.boostRandom()
        XCTAssertLessThanOrEqual(stats.str, 10)
    }

    // MARK: - WeaponType

    func testWeaponDamagePositive() {
        for weapon in WeaponType.allCases {
            XCTAssertGreaterThan(weapon.damage, 0)
        }
    }

    func testWeaponRangePositive() {
        for weapon in WeaponType.allCases {
            XCTAssertGreaterThan(weapon.range, 0)
        }
    }

    // MARK: - ColonyDirective

    func testDirectiveCorrespondingJob() {
        XCTAssertEqual(ColonyDirective.idle.correspondingJob, .idle)
        XCTAssertEqual(ColonyDirective.gather.correspondingJob, .gather)
        XCTAssertEqual(ColonyDirective.build.correspondingJob, .build)
        XCTAssertEqual(ColonyDirective.patrol.correspondingJob, .patrol)
    }

    // MARK: - ResourceModel

    func testResourceHarvest() {
        var r = ResourceModel(id: UUID(), type: .food, col: 0, row: 0, remaining: 10, maxAmount: 10, respawnTicks: 60)
        let taken = r.harvest(amount: 3)
        XCTAssertEqual(taken, 3)
        XCTAssertEqual(r.remaining, 7)
    }

    func testResourceHarvestMoreThanRemaining() {
        var r = ResourceModel(id: UUID(), type: .food, col: 0, row: 0, remaining: 2, maxAmount: 10, respawnTicks: 60)
        let taken = r.harvest(amount: 5)
        XCTAssertEqual(taken, 2)
        XCTAssertEqual(r.remaining, 0)
    }

    func testResourceHarvestDepleted() {
        var r = ResourceModel(id: UUID(), type: .food, col: 0, row: 0, remaining: 0, maxAmount: 10, respawnTicks: 60)
        let taken = r.harvest(amount: 1)
        XCTAssertEqual(taken, 0)
    }

    func testResourceRespawnTick() {
        var r = ResourceModel(id: UUID(), type: .food, col: 0, row: 0, remaining: 0, maxAmount: 10, respawnTicks: 5)
        for _ in 0..<4 { r.tickRespawn() }
        XCTAssertTrue(r.isDepleted)
        r.tickRespawn()
        XCTAssertFalse(r.isDepleted)
        XCTAssertEqual(r.remaining, 10)
    }

    func testResourceRespawnTickNotDepleted() {
        var r = ResourceModel(id: UUID(), type: .food, col: 0, row: 0, remaining: 5, maxAmount: 10, respawnTicks: 5)
        r.tickRespawn()
        XCTAssertEqual(r.remaining, 5)
    }

    func testResourceIsDepletedFlag() {
        var r = ResourceModel(id: UUID(), type: .food, col: 0, row: 0, remaining: 1, maxAmount: 10, respawnTicks: 60)
        XCTAssertFalse(r.isDepleted)
        _ = r.harvest()
        XCTAssertTrue(r.isDepleted)
    }

    // MARK: - BuildingType

    func testBuildingTypeCosts() {
        for type in BuildingType.allCases {
            XCTAssertFalse(type.cost.isEmpty)
        }
    }

    func testBuildingTypeTileSize() {
        XCTAssertEqual(BuildingType.shelter.tileSize.w, 2)
        XCTAssertEqual(BuildingType.shelter.tileSize.h, 2)
        XCTAssertEqual(BuildingType.foodStall.tileSize.w, 1)
        XCTAssertEqual(BuildingType.foodStall.tileSize.h, 1)
    }

    func testBuildingTypeDisplayNames() {
        for type in BuildingType.allCases {
            XCTAssertFalse(type.displayName.isEmpty)
        }
    }

    // MARK: - TileType

    func testTileTypeWalkability() {
        XCTAssertTrue(TileType.road.isWalkable)
        XCTAssertTrue(TileType.sidewalk.isWalkable)
        XCTAssertTrue(TileType.subway.isWalkable)
        XCTAssertFalse(TileType.building.isWalkable)
        XCTAssertFalse(TileType.billboard.isWalkable)
        XCTAssertFalse(TileType.sewer.isWalkable)
        XCTAssertFalse(TileType.empty.isWalkable)
    }

    func testTileTypeResourceYield() {
        XCTAssertEqual(TileType.subway.resourceYield, .cash)
        XCTAssertEqual(TileType.sewer.resourceYield, .materials)
        XCTAssertNil(TileType.road.resourceYield)
    }

    // MARK: - ResourceType

    func testResourceTypeSymbols() {
        XCTAssertEqual(ResourceType.food.symbol, "F")
        XCTAssertEqual(ResourceType.cash.symbol, "$")
    }

    // MARK: - GameState

    func testGameStateInitialResources() {
        let gs = GameState()
        XCTAssertEqual(gs.resources[.food], 20)
        XCTAssertEqual(gs.resources[.power], 10)
        XCTAssertEqual(gs.resources[.materials], 30)
        XCTAssertEqual(gs.resources[.oxygen], 50)
        XCTAssertEqual(gs.resources[.cash], 25)
    }

    func testGameStateLog() {
        let gs = GameState()
        gs.log("Hello")
        gs.log("World")
        XCTAssertEqual(gs.gameLog.count, 2)
    }

    func testGameStateLogCapsAt50() {
        let gs = GameState()
        for i in 0..<60 { gs.log("Message \(i)") }
        XCTAssertEqual(gs.gameLog.count, 50)
    }

    func testGameStateSelectedColonist() {
        let gs = GameState()
        let id = UUID()
        gs.colonists = [ColonistModel(id: id, name: "Test", col: 0, row: 0)]
        gs.selectedColonistId = id
        XCTAssertEqual(gs.selectedColonist?.name, "Test")
    }

    func testGameStateSelectedColonistNil() {
        let gs = GameState()
        XCTAssertNil(gs.selectedColonist)
    }

    func testGameStateDefaultValues() {
        let gs = GameState()
        XCTAssertFalse(gs.isPaused)
        XCTAssertEqual(gs.currentTick, 0)
        XCTAssertEqual(gs.inputMode, .normal)
        XCTAssertNil(gs.tutorialStep)
    }

    // MARK: - TimeSystem

    func testTimeSystemTicksWhenUnpaused() {
        let ts = TimeSystem()
        let gs = GameState()
        _ = ts.update(deltaTime: 1.5, gameState: gs)
        XCTAssertEqual(gs.currentTick, 1)
    }

    func testTimeSystemDoesNotTickWhenPaused() {
        let ts = TimeSystem()
        let gs = GameState()
        gs.isPaused = true
        _ = ts.update(deltaTime: 1.5, gameState: gs)
        XCTAssertEqual(gs.currentTick, 0)
    }

    func testTimeSystemAccumulates() {
        let ts = TimeSystem()
        let gs = GameState()
        let r1 = ts.update(deltaTime: 0.5, gameState: gs)
        XCTAssertFalse(r1)
        let r2 = ts.update(deltaTime: 0.6, gameState: gs)
        XCTAssertTrue(r2)
        XCTAssertEqual(gs.currentTick, 1)
    }

    func testTimeSystemNightCycle() {
        let ts = TimeSystem()
        let gs = GameState()
        for _ in 0..<200 { _ = ts.update(deltaTime: 1.0, gameState: gs) }
        XCTAssertEqual(gs.currentHour, 20)
        XCTAssertTrue(gs.isNight)
    }

    // MARK: - NeedsSystem

    func testNeedsSystemDecay() {
        let gs = GameState()
        gs.currentTick = 200
        gs.colonists = [ColonistModel(id: UUID(), name: "Test", col: 0, row: 0)]
        let needs = NeedsSystem()
        let initialHunger = gs.colonists[0].hunger
        for _ in 0..<10 { needs.tick(gameState: gs) }
        XCTAssertLessThan(gs.colonists[0].hunger, initialHunger)
    }

    func testNeedsSystemDeath() {
        let gs = GameState()
        gs.currentTick = 200
        gs.colonists = [ColonistModel(id: UUID(), name: "Doomed", col: 0, row: 0)]
        gs.colonists[0].hunger = 1
        let needs = NeedsSystem()
        for _ in 0..<10 { needs.tick(gameState: gs) }
        XCTAssertEqual(gs.colonists[0].state, .dead)
    }

    func testGracePeriodNoDecay() {
        let gs = GameState()
        gs.currentTick = 50
        var c = ColonistModel(id: UUID(), name: "Test", col: 0, row: 0)
        c.stats = ColonistStats(str: 5, int: 5, agi: 5, end: 5, cha: 5)
        gs.colonists = [c]
        let needs = NeedsSystem()
        let initialHunger = gs.colonists[0].hunger
        needs.tick(gameState: gs)
        XCTAssertEqual(gs.colonists[0].hunger, initialHunger)
    }

    func testShelterReducesStress() {
        let gs = GameState()
        gs.currentTick = 200
        var c = ColonistModel(id: UUID(), name: "Test", col: 5, row: 5)
        c.stress = 50
        gs.colonists = [c]
        gs.buildings = [BuildingModel(id: UUID(), type: .shelter, col: 5, row: 5)]
        let needs = NeedsSystem()
        needs.tick(gameState: gs)
        XCTAssertLessThan(gs.colonists[0].stress, 50)
    }

    func testFoodStallRestoresHunger() {
        let gs = GameState()
        gs.currentTick = 200
        var c = ColonistModel(id: UUID(), name: "Test", col: 5, row: 5)
        c.hunger = 50
        gs.colonists = [c]
        gs.buildings = [BuildingModel(id: UUID(), type: .foodStall, col: 5, row: 5)]
        gs.resources[.food] = 10
        let needs = NeedsSystem()
        needs.tick(gameState: gs)
        XCTAssertGreaterThan(gs.colonists[0].hunger, 50)
    }

    func testGeneratorProducesPower() {
        let gs = GameState()
        gs.currentTick = 200
        gs.colonists = [ColonistModel(id: UUID(), name: "Test", col: 5, row: 5)]
        gs.buildings = [BuildingModel(id: UUID(), type: .generator, col: 5, row: 5)]
        let initialPower = gs.resources[.power] ?? 0
        let needs = NeedsSystem()
        needs.tick(gameState: gs)
        XCTAssertGreaterThan(gs.resources[.power]!, initialPower)
    }

    func testDeadColonistSkipped() {
        let gs = GameState()
        gs.currentTick = 200
        var c = ColonistModel(id: UUID(), name: "Dead", col: 0, row: 0)
        c.state = .dead
        c.hunger = 100
        gs.colonists = [c]
        let needs = NeedsSystem()
        needs.tick(gameState: gs)
        XCTAssertEqual(gs.colonists[0].hunger, 100)
    }

    func testTraitInsomniac() {
        let gs = GameState()
        gs.currentTick = 200
        var c1 = ColonistModel(id: UUID(), name: "Insomniac", col: 0, row: 0)
        c1.trait = .insomniac
        c1.stats = ColonistStats(str: 5, int: 5, agi: 5, end: 0, cha: 0)
        var c2 = ColonistModel(id: UUID(), name: "Normal", col: 100, row: 100)
        c2.trait = .scavenger
        c2.stats = ColonistStats(str: 5, int: 5, agi: 5, end: 0, cha: 0)
        gs.colonists = [c1, c2]
        let needs = NeedsSystem()
        needs.tick(gameState: gs)
        XCTAssertGreaterThan(gs.colonists[0].sleep, gs.colonists[1].sleep)
    }

    // MARK: - BuildSystem

    func testBuildSystemRejectsNonWalkable() {
        let grid = Array(repeating: Array(repeating: TileType.building, count: 10), count: 10)
        let tm = TileMap(grid: grid)
        let gs = GameState()
        gs.resources = [.materials: 100, .cash: 100, .power: 100]
        let bs = BuildSystem()
        XCTAssertFalse(bs.canPlace(type: .shelter, col: 0, row: 0, tileMap: tm, gameState: gs))
    }

    func testBuildSystemAcceptsWalkable() {
        let grid = Array(repeating: Array(repeating: TileType.sidewalk, count: 10), count: 10)
        let tm = TileMap(grid: grid)
        let gs = GameState()
        gs.resources = [.materials: 100, .cash: 100, .power: 100]
        let bs = BuildSystem()
        XCTAssertTrue(bs.canPlace(type: .foodStall, col: 2, row: 2, tileMap: tm, gameState: gs))
    }

    func testCanPlaceInsufficientResources() {
        let grid = Array(repeating: Array(repeating: TileType.sidewalk, count: 10), count: 10)
        let tm = TileMap(grid: grid)
        let gs = GameState()
        gs.resources = [.materials: 0]
        let bs = BuildSystem()
        XCTAssertFalse(bs.canPlace(type: .shelter, col: 0, row: 0, tileMap: tm, gameState: gs))
    }

    func testPlaceDeductsResources() {
        let grid = Array(repeating: Array(repeating: TileType.sidewalk, count: 10), count: 10)
        let tm = TileMap(grid: grid)
        let gs = GameState()
        gs.resources = [.materials: 100, .cash: 100, .power: 100]
        let bs = BuildSystem()
        let pf = Pathfinder(columns: 10, rows: 10)
        pf.buildGraph(grid: grid)
        let initialMaterials = gs.resources[.materials]!
        _ = bs.place(type: .shelter, col: 2, row: 2, tileMap: tm, gameState: gs, pathfinder: pf)
        XCTAssertEqual(gs.resources[.materials]!, initialMaterials - BuildingType.shelter.cost[.materials]!)
    }

    func testPlaceAddsToGameState() {
        let grid = Array(repeating: Array(repeating: TileType.sidewalk, count: 10), count: 10)
        let tm = TileMap(grid: grid)
        let gs = GameState()
        gs.resources = [.materials: 100, .cash: 100, .power: 100]
        let bs = BuildSystem()
        let pf = Pathfinder(columns: 10, rows: 10)
        pf.buildGraph(grid: grid)
        _ = bs.place(type: .foodStall, col: 3, row: 3, tileMap: tm, gameState: gs, pathfinder: pf)
        XCTAssertEqual(gs.buildings.count, 1)
        XCTAssertEqual(gs.buildings[0].type, .foodStall)
    }

    func testDemolishRemovesFromGameState() {
        let grid = Array(repeating: Array(repeating: TileType.sidewalk, count: 10), count: 10)
        let tm = TileMap(grid: grid)
        let gs = GameState()
        gs.resources = [.materials: 100, .cash: 100, .power: 100]
        let bs = BuildSystem()
        let pf = Pathfinder(columns: 10, rows: 10)
        pf.buildGraph(grid: grid)
        let model = bs.place(type: .foodStall, col: 3, row: 3, tileMap: tm, gameState: gs, pathfinder: pf)!
        bs.demolish(id: model.id, tileMap: tm, gameState: gs, pathfinder: pf)
        XCTAssertTrue(gs.buildings.isEmpty)
    }

    func testDemolishNonexistentId() {
        let grid = Array(repeating: Array(repeating: TileType.sidewalk, count: 10), count: 10)
        let tm = TileMap(grid: grid)
        let gs = GameState()
        let bs = BuildSystem()
        let pf = Pathfinder(columns: 10, rows: 10)
        pf.buildGraph(grid: grid)
        bs.demolish(id: UUID(), tileMap: tm, gameState: gs, pathfinder: pf)
    }

    // MARK: - ResourceSystem

    func testResourceSystemConsumeFailsWhenEmpty() {
        let gs = GameState()
        gs.resources = [.food: 0]
        let rs = ResourceSystem()
        XCTAssertFalse(rs.consume(gameState: gs, type: .food, amount: 1))
    }

    func testResourceSystemConsumeSucceeds() {
        let gs = GameState()
        gs.resources = [.food: 10]
        let rs = ResourceSystem()
        XCTAssertTrue(rs.consume(gameState: gs, type: .food, amount: 5))
        XCTAssertEqual(gs.resources[.food], 5)
    }

    func testGathererHarvestsNearbyResource() {
        let grid = Array(repeating: Array(repeating: TileType.sidewalk, count: 10), count: 10)
        let tm = TileMap(grid: grid)
        let gs = GameState()
        gs.resources = [.food: 0, .power: 0, .materials: 0, .oxygen: 0, .cash: 0]
        var c = ColonistModel(id: UUID(), name: "Gatherer", col: 5, row: 5)
        c.job = .gather
        gs.colonists = [c]
        gs.resourceNodes = [ResourceModel(id: UUID(), type: .food, col: 5, row: 5, remaining: 10, maxAmount: 10, respawnTicks: 60)]
        let rs = ResourceSystem()
        rs.tick(gameState: gs, tileMap: tm)
        XCTAssertEqual(gs.resources[.food], 1)
    }

    func testDeadGathererDoesNotHarvest() {
        let grid = Array(repeating: Array(repeating: TileType.sidewalk, count: 10), count: 10)
        let tm = TileMap(grid: grid)
        let gs = GameState()
        gs.resources = [.food: 0]
        var c = ColonistModel(id: UUID(), name: "Dead", col: 5, row: 5)
        c.job = .gather
        c.state = .dead
        gs.colonists = [c]
        gs.resourceNodes = [ResourceModel(id: UUID(), type: .food, col: 5, row: 5, remaining: 10, maxAmount: 10, respawnTicks: 60)]
        let rs = ResourceSystem()
        rs.tick(gameState: gs, tileMap: tm)
        XCTAssertEqual(gs.resources[.food], 0)
    }

    // MARK: - JobSystem

    func testJobSystemAssignAndClear() {
        let gs = GameState()
        gs.colonists = [ColonistModel(id: UUID(), name: "Worker", col: 0, row: 0)]
        let grid = Array(repeating: Array(repeating: TileType.sidewalk, count: 10), count: 10)
        let pf = Pathfinder(columns: 10, rows: 10)
        pf.buildGraph(grid: grid)
        let js = JobSystem()
        js.assignJob(colonistIndex: 0, job: .gather, destCol: 5, destRow: 5, gameState: gs, pathfinder: pf)
        XCTAssertEqual(gs.colonists[0].job, .gather)
        js.clearJob(colonistIndex: 0, gameState: gs)
        XCTAssertEqual(gs.colonists[0].job, .idle)
        XCTAssertTrue(gs.colonists[0].pathCols.isEmpty)
    }

    func testAssignJobOutOfBounds() {
        let gs = GameState()
        let grid = Array(repeating: Array(repeating: TileType.sidewalk, count: 10), count: 10)
        let pf = Pathfinder(columns: 10, rows: 10)
        pf.buildGraph(grid: grid)
        let js = JobSystem()
        js.assignJob(colonistIndex: 99, job: .gather, destCol: 5, destRow: 5, gameState: gs, pathfinder: pf)
    }

    func testClearJobOutOfBounds() {
        let gs = GameState()
        let js = JobSystem()
        js.clearJob(colonistIndex: 99, gameState: gs)
    }

    // MARK: - TileMap

    func testTileMapTileAt() {
        let grid = [[TileType.road, .sidewalk], [.building, .empty]]
        let tm = TileMap(grid: grid)
        XCTAssertEqual(tm.tileAt(col: 0, row: 0), .road)
        XCTAssertEqual(tm.tileAt(col: 1, row: 1), .empty)
    }

    func testTileMapTileAtOutOfBounds() {
        let grid = [[TileType.road]]
        let tm = TileMap(grid: grid)
        XCTAssertNil(tm.tileAt(col: -1, row: 0))
        XCTAssertNil(tm.tileAt(col: 5, row: 0))
    }

    func testTileMapSetTile() {
        let grid = [[TileType.sidewalk, .sidewalk], [.sidewalk, .sidewalk]]
        let tm = TileMap(grid: grid)
        tm.setTile(.building, col: 0, row: 0)
        XCTAssertEqual(tm.tileAt(col: 0, row: 0), .building)
    }

    func testTileMapWorldPosition() {
        let grid = [[TileType.sidewalk]]
        let tm = TileMap(grid: grid)
        let pos = tm.worldPosition(col: 3, row: 5)
        XCTAssertEqual(pos.x, 3 * 32 + 16, accuracy: 0.001)
        XCTAssertEqual(pos.y, 5 * 32 + 16, accuracy: 0.001)
    }

    func testTileMapTilePosition() {
        let grid = Array(repeating: Array(repeating: TileType.sidewalk, count: 10), count: 10)
        let tm = TileMap(grid: grid)
        let pos = tm.tilePosition(worldX: 100, worldY: 200)
        XCTAssertEqual(pos.col, 3)
        XCTAssertEqual(pos.row, 6)
    }

    // MARK: - Pathfinder

    func testPathfinderFindsPath() {
        let grid = Array(repeating: Array(repeating: TileType.sidewalk, count: 10), count: 10)
        let pf = Pathfinder(columns: 10, rows: 10)
        pf.buildGraph(grid: grid)
        let path = pf.findPath(fromCol: 0, fromRow: 0, toCol: 5, toRow: 5)
        XCTAssertFalse(path.isEmpty)
        XCTAssertEqual(path.last?.col, 5)
        XCTAssertEqual(path.last?.row, 5)
    }

    func testPathfinderNoPathThroughWalls() {
        var grid = Array(repeating: Array(repeating: TileType.sidewalk, count: 5), count: 5)
        for c in 0..<5 { grid[2][c] = .building }
        let pf = Pathfinder(columns: 5, rows: 5)
        pf.buildGraph(grid: grid)
        let path = pf.findPath(fromCol: 0, fromRow: 0, toCol: 0, toRow: 4)
        XCTAssertTrue(path.isEmpty)
    }

    func testPathfinderNoGraph() {
        let pf = Pathfinder(columns: 5, rows: 5)
        let path = pf.findPath(fromCol: 0, fromRow: 0, toCol: 4, toRow: 4)
        XCTAssertTrue(path.isEmpty)
    }

    // MARK: - WorldGenerator

    func testWorldGeneratorProducesValidGrid() {
        let result = WorldGenerator.generate()
        XCTAssertEqual(result.grid.count, 128)
        XCTAssertEqual(result.grid[0].count, 128)
        XCTAssertFalse(result.resources.isEmpty)
    }

    func testGridHasSubwayTiles() {
        let result = WorldGenerator.generate()
        var hasSubway = false
        for row in result.grid {
            for tile in row {
                if tile == .subway { hasSubway = true }
            }
        }
        XCTAssertTrue(hasSubway)
    }

    func testResourcesOnSidewalks() {
        let result = WorldGenerator.generate()
        for resource in result.resources {
            XCTAssertEqual(result.grid[resource.row][resource.col], .sidewalk)
        }
    }

    // MARK: - SaveManager

    func testSaveAndLoad() {
        let gs = GameState()
        gs.colonists = [ColonistModel(id: UUID(), name: "Saver", col: 10, row: 20)]
        gs.resources = [.food: 42, .materials: 10, .power: 5, .oxygen: 30, .cash: 15]
        gs.currentTick = 500
        let grid = Array(repeating: Array(repeating: TileType.sidewalk, count: 5), count: 5)
        let testSlot = 99
        try? SaveManager.shared.save(slot: testSlot, gameState: gs, grid: grid)
        let loaded = SaveManager.shared.load(slot: testSlot)
        XCTAssertNotNil(loaded)
        XCTAssertEqual(loaded?.colonists[0].name, "Saver")
        XCTAssertEqual(loaded?.resources[.food], 42)
        SaveManager.shared.delete(slot: testSlot)
    }

    func testLoadNonexistentSlot() {
        XCTAssertNil(SaveManager.shared.load(slot: 98))
    }

    func testRebuildGrid() {
        let original = [[TileType.road, .sidewalk], [.building, .empty]]
        let flat = original.flatMap { $0.map(\.rawValue) }
        let saveData = SaveData(
            colonists: [], buildings: [], resourceNodes: [], resources: [:],
            currentTick: 0, flatGrid: flat, gridSize: 2,
            slot: SaveSlot(slot: 1, saveName: "Test", timestamp: Date(), dayCount: 0, colonistCount: 0)
        )
        let rebuilt = SaveManager.shared.rebuildGrid(from: saveData)
        XCTAssertEqual(rebuilt[0][0], .road)
        XCTAssertEqual(rebuilt[1][1], .empty)
    }

    func testDeleteSlot() {
        let gs = GameState()
        let grid = [[TileType.sidewalk]]
        let testSlot = 97
        try? SaveManager.shared.save(slot: testSlot, gameState: gs, grid: grid)
        XCTAssertNotNil(SaveManager.shared.load(slot: testSlot))
        SaveManager.shared.delete(slot: testSlot)
        XCTAssertNil(SaveManager.shared.load(slot: testSlot))
    }

    // MARK: - TutorialView

    func testCheckAdvanceColonistSelected() {
        let gs = GameState()
        gs.tutorialStep = 2
        TutorialView.checkAdvance(gameState: gs, event: .colonistSelected)
        XCTAssertEqual(gs.tutorialStep, 3)
    }

    func testCheckAdvanceCameraPanned() {
        let gs = GameState()
        gs.tutorialStep = 3
        TutorialView.checkAdvance(gameState: gs, event: .cameraPanned)
        XCTAssertEqual(gs.tutorialStep, 4)
    }

    func testCheckAdvanceBuildMenuOpened() {
        let gs = GameState()
        gs.tutorialStep = 4
        TutorialView.checkAdvance(gameState: gs, event: .buildMenuOpened)
        XCTAssertEqual(gs.tutorialStep, 5)
    }

    func testCheckAdvanceShelterPlaced() {
        let gs = GameState()
        gs.tutorialStep = 5
        TutorialView.checkAdvance(gameState: gs, event: .shelterPlaced)
        XCTAssertEqual(gs.tutorialStep, 6)
    }

    func testCheckAdvanceWrongEvent() {
        let gs = GameState()
        gs.tutorialStep = 2
        TutorialView.checkAdvance(gameState: gs, event: .buildMenuOpened)
        XCTAssertEqual(gs.tutorialStep, 2)
    }

    func testCheckAdvanceNilStep() {
        let gs = GameState()
        gs.tutorialStep = nil
        TutorialView.checkAdvance(gameState: gs, event: .colonistSelected)
        XCTAssertNil(gs.tutorialStep)
    }
}
