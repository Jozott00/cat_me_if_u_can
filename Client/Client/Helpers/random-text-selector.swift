//
//  random-text-selector.swift
//  Client
//
//  Created by Tim Dirr on 24.04.23.
//

import Foundation

class RandomTextSelector {
    var data: jsonList?
    let fileName: String
    struct jsonList: Codable {
        let elements: [String]
    }

    init(
        fileName: String
    ) {
        self.fileName = fileName
        self.data = nil
    }

    func getRandomListElement() -> String {
        // load file if not loaded yet
        if self.data == nil {
            if let file = readLocalJSONFile(forName: self.fileName) {
                self.data = parse(jsonData: file)
            }
        }

        // select element from file
        if let data = self.data {
            let rand = Int.random(in: 0..<data.elements.count)
            return data.elements[rand]
        }
        return ""
    }

    func readLocalJSONFile(forName name: String) -> Data? {
        do {
            if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                return data
            }
        }
        catch {
            print("error: \(error)")
        }
        return nil
    }

    func parse(jsonData: Data) -> jsonList? {
        do {
            let decodedData = try JSONDecoder().decode(jsonList.self, from: jsonData)
            return decodedData
        }
        catch {
            print("error: \(error)")
        }
        return nil
    }
}
