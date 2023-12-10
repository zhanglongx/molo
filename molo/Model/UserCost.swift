import Foundation
import Yams

let filePath = "Documents/molo.yml"

func load() -> [Stock]? {

    let iCloudURL: URL?

    let fileManager = FileManager.default

    if let iCloudURL = fileManager.url(forUbiquityContainerIdentifier: nil)?
                                .appendingPathComponent(filePath) {
        iCloudURL = iCloudURL
    } else {
        return nil
    }

    do {
        let yamlString = try String(contentsOf: iCloudURL, encoding: .utf8)
        let yamlObject = try Yams.load(yaml: yamlString)
        let decoder = JSONDecoder()
        if let yamlData = try? JSONSerialization.data(withJSONObject: yamlObject, options: []),
            let costs = try? decoder.decode([Stock].self, from: yamlData) {
            return costs
        }
    } catch {
        print("Failed to load or parse YAML: \(error)")
    }

    return nil
}
