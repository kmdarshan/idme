//
//  Purchase.swift
//  Id.Me
//
//  Created by darshan on 3/10/22.
//

import Foundation
extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale.current
        return formatter
    }()
}

enum TransactionType {
	case purchase, refund, unknown
}

protocol Transaction {
	var image: String { get set }
	var transactionDate: Date? { get set }
	var itemName: String { get set }
	var serial: String { get set }
	var description: String { get set }
	var type: TransactionType? { get set }
	var transactionAmount: Double? { get set }
}

struct Purchase: Decodable, Transaction {
	var purchaseDate: Date?
	var image: String
	var transactionDate: Date?
	var itemName: String
	var serial: String
	var description: String
	var type: TransactionType?
	var transactionAmount: Double?
	
	enum CodingKeys: String, CodingKey {
		case image
		case transactionDate = "purchase_date"
		case itemName = "item_name"
		case transactionAmount = "price"
		case serial
		case description
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		image = try container.decode(String.self, forKey: .image)
		do {
			transactionDate = try container.decode(Date.self, forKey: .transactionDate)
		} catch {
			transactionDate = Date()
		}
		
		itemName = try container.decode(String.self, forKey: .itemName)
		do {
			let temporaryPrice = try container.decode(String.self, forKey: .transactionAmount)
			transactionAmount = Double(temporaryPrice)!
		} catch {
			transactionAmount = 0.0
		}
		serial = try container.decode(String.self, forKey: .serial)
		description = try container.decode(String.self, forKey: .description)
		type = .purchase
	}
}

struct Refund: Decodable, Transaction {
	var image: String
	
	var purchaseDate: Date?
	
	var itemName: String
	
	var price: Double?
	
	var serial: String
	
	var description: String
	
	var type: TransactionType?
	var refundDate: Date?
	var transactionDate: Date?
	var transactionAmount: Double?
	
	enum CodingKeys: String, CodingKey {
		case image
		case transactionDate = "refund_date"
		case itemName = "item_name"
		case price
		case serial
		case description
		case transactionAmount = "refund_amt"
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		image = try container.decode(String.self, forKey: .image)
		do {
			transactionDate = try container.decode(Date.self, forKey: .transactionDate)
		} catch {
			transactionDate = Date()
		}
			
		itemName = try container.decode(String.self, forKey: .itemName)
		do {
			let temporaryPrice = try container.decode(String.self, forKey: .price)
			price = Double(temporaryPrice)!
		} catch {
			price = 0.0
		}
		serial = try container.decode(String.self, forKey: .serial)
		description = try container.decode(String.self, forKey: .description)
		do {
			let temporaryPrice = try container.decode(String.self, forKey: .transactionAmount)
			transactionAmount = Double(temporaryPrice)!
		} catch {
			transactionAmount = 0.0
		}
		type = .refund
	}
}

//extension Transaction {
//    static let testjson = """
//    [{
//       "image": "https://picsum.photos/id/0/200",
//       "purchase_date": "2020-12-27T00:00:00.000Z",
//       "item_name": "neural copying card",
//       "price": "214.00",
//       "serial": "1938367811",
//       "description": "Try to hack the COM transmitter, maybe it will index the bluetooth bus!"
//    },{
//       "image": "https://picsum.photos/id/1/200",
//       "purchase_date": "2020-12-28T00:00:00.000Z",
//       "item_name": "auxiliary calculating feed",
//       "price": "111.00",
//       "serial": "1393025156",
//       "description": "programming the bus won&#x27;t do anything, we need to reboot the bluetooth RAM system!"
//    }]
//    """
//    static let samplePurchases = try? JSONDecoder().decode([Transaction].self, from: Transaction.testjson.data(using: .utf8)!)
//}
