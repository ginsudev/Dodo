//
//  ThemePickerView.ViewModel.swift
//  
//
//  Created by Noah Little on 7/4/2023.
//

import Foundation
import GSCore

extension ThemePickerView {
    struct ViewModel {
        let themes: [PlayerThemeModel]
        
        init() {
            let themeDir = "/Library/Application Support/Dodo/Themes/".rootify
            let fileManager = FileManager.default
            
            do {
                var themeModels: [PlayerThemeModel] = []
                
                let contents = try fileManager.contentsOfDirectory(atPath: themeDir)
                for dir in contents {
                    let info = "\(themeDir)\(dir)/info.json"
                    if fileManager.fileExists(atPath: info) {
                        let data = try Data(contentsOf: URL(fileURLWithPath: info))
                        let decoder = JSONDecoder()
                        let playerThemeModel = try decoder.decode(PlayerThemeModel.self, from: data)
                        themeModels.append(playerThemeModel)
                    }
                }
                self.themes = themeModels
            } catch {
                self.themes = []
            }
        }
        
        func saveWithID(_ id: String) {
            UserDefaults.standard.setValue(id, forKey: "Dodo.selectedPlayerButtonThemeIdentifier")
        }
        
        func savedID() -> String? {
            UserDefaults.standard.string(forKey: "Dodo.selectedPlayerButtonThemeIdentifier")
        }
    }
}
