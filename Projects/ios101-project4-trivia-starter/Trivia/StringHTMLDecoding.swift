//
//  StringHTMLDecoding.swift
//  Trivia
//
//  Created by Alexon Abreu on 3/25/25.
//
// The file was created to help solve a common issue with speacial
// characters appearing in strings when using Open Trivia DB API

import Foundation


extension String {
    var decodedHTML: String {
        guard let data = self.data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        let decodedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil).string
        return decodedString ?? self
    }
}
