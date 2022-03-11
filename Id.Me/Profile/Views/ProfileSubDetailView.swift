//
//  ProfileSubDetailView.swift
//  Id.Me
//
//  Created by darshan on 3/11/22.
//

import SwiftUI

struct ProfileSubDetailView: View {
    let title: String
    let subtitle: String
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(subtitle)
        }
        .padding(.leading)
        .padding(.trailing)
        .padding(.bottom)
        .padding(.top)
    }
}

struct ProfileSubDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSubDetailView(title: "Username", subtitle: "Darshan")
    }
}
