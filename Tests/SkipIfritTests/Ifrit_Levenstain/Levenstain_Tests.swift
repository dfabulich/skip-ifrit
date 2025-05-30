import Foundation
import XCTest
@testable import SkipIfrit

/////////////////////////
///Functional tests
/////////////////////////
final class Levenstain_Tests: XCTestCase {
    func test_BasicSearch() throws {
        let animes = ["Gekijouban Fairy Tail: Houou no Miko",
                    "Fairy Tail the Movie: The Phoenix Priestess",
                    "Priestess of the Phoenix",
                    "Fairy Tail: The Phoenix Priestess"]
        
        let animesSearch = Levenstain.searchSync("Fairy Tail: The Phoenix Priestess", in: animes)
        
        XCTAssertEqual(animesSearch.count, 4)
        XCTAssertEqual(animesSearch.first?.diffScore, 0)
        
        let incorrectSearch = Levenstain.searchSync("Мій маленький поні", in: animes)
        
        XCTAssertEqual(incorrectSearch.count, 4)
        XCTAssertGreaterThan(incorrectSearch.first!.diffScore, 0.9)
    }
}


/////////////////////////
///Performance tests
/////////////////////////
extension Levenstain_Tests {
    
    func test_BasicSearchPerformance() throws {
        var animes = ["Gekijouban Fairy Tail: Houou no Miko",
                      "Fairy Tail the Movie: The Phoenix Priestess",
                      "Priestess of the Phoenix",
                      "Fairy Tail: The Phoenix Priestess"]
        
        animes.append(contentsOf: stride(from: 4, to: 1_300, by: 1).map{ _ in UUID().uuidString }  )
        
        self.measure {
            let _ = Levenstain.searchSync("Fairy Tail the Movie: The Phoenix Priestess", in: animes)
        }
        
        // M1 PC results:
        // search in 10_000 strings array
        // 36.356 seconds
    }
}

/////////////////////////
///HELPERS
/////////////////////////

func getAnimeList(count: Int) -> [AnimeListInfo] {
    guard count >= 2 else { fatalError() }
    
    let animes : [AnimeListInfo] = [
        AnimeListInfo(nameEng: "Fairy Tail the Movie: The Phoenix Priestess",
                      nameJap: "Gekijouban Fairy Tail: Houou no Miko",
                      nameOther: ["Priestess of the Phoenix",
                                  "Fairy Tail: The Phoenix Priestess",
                                  "Test of Array"],
                      genres: [],
                      episodes: nil,
                      year: "1990",
                      studios: [],
                      producers: [],
                      rating: "18+",
                      crawledUrl: "https://myanimelist.net/anime/40052/Great_Pretender"),
        
        AnimeListInfo(nameEng: "Great Pretender",
                      nameJap: "Great Pretender",
                      nameOther: [UUID().uuidString, UUID().uuidString, UUID().uuidString],
                      genres: [],
                      episodes: nil,
                      year: "1990",
                      studios: [],
                      producers: [],
                      rating: "0+",
                      crawledUrl: "https://myanimelist.net/anime/40052/Great_Pretender")
    ]
    
    var additional = stride(from: 0, to: count - 2, by: 1)
        .map{ _ in
            AnimeListInfo(nameEng: UUID().uuidString,
                          nameJap: UUID().uuidString,
                          nameOther: [UUID().uuidString, UUID().uuidString, UUID().uuidString],
                          genres: [],
                          episodes: nil,
                          year: "1990",
                          studios: [],
                          producers: [],
                          rating: "18+",
                          crawledUrl: UUID().uuidString)
        }
    
    additional.append(contentsOf: animes)
    
    return additional
}


struct AnimeListInfo: Codable, Searchable  {
    // Search in this fields
    let nameEng: String?
    let nameJap: String
    var nameJapRomaji: String? = nil
    var nameOther: [String]
    
    // But do not search in this
    let genres: [String]
    let episodes: Int?
    let year: String?
    let studios: [String]
    let producers: [String]
    let rating: String
    let crawledUrl: String
    
    var properties: [FuseProp] {
        [nameEng, nameJap, nameJapRomaji]
            .compactMap{ $0 }
            .appending(contentsOf: nameOther)
            .map{ FuseProp($0) }
    }
}
