//
//  Fuse+FuseProps.swift
//

import Foundation

extension Fuse {
    ///
    /// instructions how to use: https://github.com/ukushu/Ifrit/blob/main/Docs/FuseInstructions.md
    ///
    public func searchSync(_ text: String, in aList: [[FuseProp]]) -> [FuzzySrchResult] {
        let pattern = self.createPattern(from: text)

        var collectionResult = [FuzzySrchResult]()

        for (index, item) in aList.enumerated() {
            var scores = [Double]()
            var totalScore = 0.0

            var propertyResults = [(value: String, diffScore: Double, ranges: [CountableClosedRange<Int>])]()

            item.forEach { property in

                let value = property.value

                if let result = self.search(pattern, in: value) {
                    let weight = property.weight == 1 ? 1 : 1 - property.weight
                    let score = (result.score == 0 && weight == 1 ? 0.001 : result.score) * weight
                    totalScore += score

                    scores.append(score)

                    propertyResults.append((value: property.value, diffScore: score, ranges: result.ranges))
                }
            }

            if scores.count == 0 {
                continue
            }

            collectionResult.append((
                index: index,
                diffScore: self.objSortStrategy == .averageScore ? totalScore / Double(scores.count) : scores.min() ?? 1 ,
                results: propertyResults
            ))
        }

        return collectionResult.sorted { $0.diffScore < $1.diffScore }
    }
}
