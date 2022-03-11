//
//  ProfileViewModel.swift
//  Id.Me
//
//  Created by darshan on 3/11/22.
//

import Foundation
class ProfileViewModel: ObservableObject {
    @Published var profile: Profile?
    @Published var error: DownloadError = .unknownDownloadError
    func getProfile() {
        Task {
            let result = await Downloader(api: .real).downloadUserProfile()
            await MainActor.run {
                switch result {
                case let .success(downloadedProfile):
                    self.profile = getFormattedProfile(downloadedProfile!)
                case let .failure(error):
                    self.error = error
                }
            }
        }
    }

    func getFormattedProfile(_ profile: Profile) -> Profile {
        var newProfile = profile
        newProfile.registration = profile.registration.convertFrom(source: "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ", destination: "MMM dd, yyyy")
        newProfile.phoneNumber = getFormattedPhoneNumber(number: profile.phoneNumber)
        return newProfile
    }

    func getFormattedPhoneNumber(number: String) -> String {
        let newNumber = number
        if newNumber.count > 0 {
            let first = newNumber.prefix(1)
            let areaCode = newNumber[newNumber.index(newNumber.startIndex, offsetBy: 1) ... newNumber.index(newNumber.startIndex, offsetBy: 3)]
            let middleThree = newNumber[newNumber.index(newNumber.startIndex, offsetBy: 4) ... newNumber.index(newNumber.startIndex, offsetBy: 6)]
            let lastFour = newNumber.suffix(4)
            let result = String("+") + String(first) + " (" + String(areaCode) + ") " + String(middleThree) + "-" + String(lastFour)
            return result
        }
        return newNumber
    }
}
