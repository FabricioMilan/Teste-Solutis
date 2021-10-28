//
//  Utils.swift
//  ProvaFinalSolutis
//
//  Created by Virtual Machine on 25/10/21.
//

import Foundation

class Utils {
    
    func formatarData(data: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/yyyy"
        print(data)
        let date = dateFormatterGet.date(from: data)
        print(date)
        return dateFormatterPrint.string(from: date!)
        
    }
}
