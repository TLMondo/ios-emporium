//
//
//  Created by Jason Koo on 5/14/18.
//  Copyright © 2018 Jason Koo. All rights reserved.
//

import Foundation

extension String {
    
    func localized() -> String {
        return Bundle.main.localizedString(forKey: self,
                                           value: nil,
                                           table: nil)
    }
    
    func localized(fromFile: String) -> String {
        let localizedString = Bundle.main.localizedString(forKey: self,
                                                          value: nil,
                                                          table: fromFile)
        if localizedString == "" {
            // If appLocalizationFilename was not set then it will check the main bundle twice... meh.
            return Bundle.main.localizedString(forKey: self,
                                               value: nil,
                                               table: nil)
        
        }
        return localizedString
    }
    
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
    
}
