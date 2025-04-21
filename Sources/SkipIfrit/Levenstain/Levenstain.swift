import Foundation

public class Levenstain {
    public static func searchSync(_ text: String, in aList: [String]) -> [FuzzySrchResult] {
        let tmp = aList.indices
            .map { idx -> FuzzySrchResult in
                let score = aList[idx].levenshteinDistanceScore(to: text, trimWhiteSpacesAndNewLines: true)
                
                return FuzzySrchResult(Int(idx), 1 - score, [])
            }
        
        return tmp
            .sorted(by: { $0.diffScore < $1.diffScore } )
    }
}
