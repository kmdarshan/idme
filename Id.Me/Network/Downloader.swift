//
//  Downloader.swift
//  Id.Me
//
//  Created by darshan on 3/10/22.
//

import Foundation

enum DownloadError: Error {
    case decoderDownloadError
    case networkDownloadError
    case timedOutError
    case unknownDownloadError
    case userAuthenticationDownloadError
}

enum API {
    case real
    case mock
}

struct Downloader {
    var api: API
    init(api: API) {
        // we can use this for testing purposes
        self.api = api
    }

    func downloadUserProfile() async -> Result<Profile?, DownloadError> {
        if api == .mock {
            // this needs to be modified
            // we can use this for testing purposes
            // send back mock data
            return .success(nil)
        } else {
            let url = URL(string: "https://idme-takehome.proxy.beeceptor.com/profile/U13023932")!
            do {
                let (data, urlResponse) = try await URLSession.shared.data(from: url, delegate: nil)
                if let httpResponse = urlResponse as? HTTPURLResponse, (200 ... 299).contains(httpResponse.statusCode) {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let profile = try jsonDecoder.decode(Profile.self, from: data)
                        return .success(profile)
                    } catch {
                        return .failure(.decoderDownloadError)
                    }
                }
            } catch {
                return .failure(.networkDownloadError)
            }
            return .failure(.networkDownloadError)
        }
    }

    func downloadPurchaseHistory() async -> Result<[Purchase], DownloadError> {
        let url = URL(string: "https://idme-takehome.proxy.beeceptor.com/purchases/U13023932?page=1")!
        do {
            let (data, urlResponse) = try await URLSession.shared.data(from: url, delegate: nil)
            if let httpResponse = urlResponse as? HTTPURLResponse, (200 ... 299).contains(httpResponse.statusCode) {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                do {
                    let purchases = try jsonDecoder.decode([Purchase].self, from: data)
                    return .success(purchases)
                } catch {
                    print(error)
                    return .failure(.decoderDownloadError)
                }
            }
        } catch {
            return .failure(.networkDownloadError)
        }
        return .failure(.networkDownloadError)
    }
}
