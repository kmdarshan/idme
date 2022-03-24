//
//  PurchaseHistoryViewModel.swift
//  Id.Me
//
//  Created by darshan on 3/11/22.
//

import Foundation

class PurchaseHistoryViewModel: ObservableObject {
    @Published var purchases = [Transaction]()
    @Published var error: DownloadError = .unknownDownloadError
    func getPurchases() {
        Task {
			let purchasesResult = await Downloader(api: .real).downloadPurchaseHistory()
			let refundsResult = await Downloader(api: .real).downloadRefundHistory()
			await MainActor.run {
				switch purchasesResult {
				case let .success(downloadedTransaction):
					purchases.append(contentsOf: downloadedTransaction)
				case let .failure(error):
					self.error = error
				}
				switch refundsResult {
				case let .success(refunds):
					purchases.append(contentsOf: refunds)
				case let .failure(error):
					self.error = error
				}
				purchases.sort { transaction1, transaction2 in
					transaction1.transactionDate! < transaction2.transactionDate!
				}
			}
			
//            await MainActor.run {
//                switch result {
//                case let .success(purchases):
//                    self.purchases = purchases
//                case let .failure(error):
//                    self.error = error
//                }
//            }
        }
    }

	func getTransactions() async -> [Transaction] {
		return []
	}
	
    func getDateString(_ purchase: Transaction) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        let stringDate = dateformatter.string(from: purchase.transactionDate!)
        return stringDate.convertFrom(source: "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ", destination: "MMM dd, yyyy")
    }

    func getPrice(_ purchase: Transaction) -> String {
		guard purchase.transactionAmount != nil else {
			return ""
		}
        return "$" + String(purchase.transactionAmount!)
    }
	
	func getFormattedDescription(_ purchase: Transaction) -> String {
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
