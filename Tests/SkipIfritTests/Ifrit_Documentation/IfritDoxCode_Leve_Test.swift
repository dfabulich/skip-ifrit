import Foundation
import XCTest
@testable import SkipIfrit

final class IfritDoxCode_Leve_Test: XCTestCase {
    
    //#### Levenstain search in `[String]`
    func test_1() throws {
        let animes = ["Gekijouban Fairy Tail: Houou no Miko",
                    "Fairy Tail the Movie: The Phoenix Priestess",
                    "Priestess of the Phoenix",
                    "Fairy Tail: The Phoenix Priestess"]
        
        let animesSearch = Levenstain.searchSync("Fairy Tail: The Phoenix Priestess", in: animes)
        
        // --------------------
        // ASYNC: async/await
        // DOES NOT SUPPORTED
        
        // --------------------
        // ASYNC: callbacks
        // DOES NOT SUPPORTED
    }
}
