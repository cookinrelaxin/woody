import Foundation

fileprivate let woodyFixturePath = """
./Tests/woodyTests/woodySourceAnalysisTests/fixtures/
"""

fileprivate let fixturePath = """
./Tests/woodyTests/intermediateAnalysisTests/fixtures/
"""

fileprivate let woodyFixtureURL = URL(fileURLWithPath: woodyFixturePath)
fileprivate let fixtureURL = URL(fileURLWithPath: fixturePath)

func woodyFixture(named name: String) -> URL
{
    fatalError()
}

func fixture(named name: String) -> URL
{
    fatalError()
}
