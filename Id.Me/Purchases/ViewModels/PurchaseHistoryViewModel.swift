//
//  PurchaseHistoryViewModel.swift
//  Id.Me
//
//  Created by darshan on 3/11/22.
//

import Foundation

class PurchaseHistoryViewModel: ObservableObject {
    @Published var purchases = [Purchase]()
    @Published var error: DownloadError = .unknownDownloadError
    func getPurchases() {
        Task {
            let result = await Downloader(api: .real).downloadPurchaseHistory()
            await MainActor.run {
                switch result {
                case let .success(purchases):

                    self.purchases = purchases
                case let .failure(error):
                    self.error = error
                }
            }
        }
    }

    func getDateString(_ purchase: Purchase) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        let stringDate = dateformatter.string(from: purchase.purchaseDate)
        return stringDate.convertFrom(source: "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ", destination: "MMM dd, yyyy")
    }

    func getPrice(_ purchase: Purchase) -> String {
        return "$" + String(purchase.price)
    }
	
	func getFormattedDescription(_ purchase: Purchase) -> String {
		let okayChars : Set<Character> =
				Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-*=(),.:!_")
			return String(purchase.description.filter {okayChars.contains($0) })
	}
}

extension String {
    func convertFrom(source: String, destination: String) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = source
        let date = dateformatter.date(from: self)
        dateformatter.dateFormat = destination
        let resultString = dateformatter.string(from: date!)
        return resultString
    }
}
