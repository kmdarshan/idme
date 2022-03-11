//
//  ProfileSwiftUIView.swift
//  Id.Me
//
//  Created by darshan on 3/10/22.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var vm = ProfileViewModel()
    var body: some View {
        NavigationView {
            VStack {
                if vm.profile != nil {
                    if vm.profile!.image.count > 0 {
                        AsyncImage(url: URL(string: vm.profile!.image), content: { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                                .frame(maxWidth: 300, maxHeight: 100)
                        }, placeholder: {
                            ProgressView()
                        })
                    }
                    VStack {
                        // strings need to be localized
                        ProfileSubDetailView(title: "Personal", subtitle: "") // strings need to localized
                        ProfileSubDetailView(title: "Username", subtitle: vm.profile!.username)
                        ProfileSubDetailView(title: "Full name", subtitle: vm.profile!.fullname)
                        ProfileSubDetailView(title: "Phone number", subtitle: vm.profile!.phoneNumber)
                        ProfileSubDetailView(title: "Registration Date", subtitle: vm.profile!.registration)
                        NavigationLink(destination: PurchasesHistoryView()) {
                            Text("View Purchases")
                                .frame(width: 300, height: 50, alignment: .center)
                                .foregroundColor(.white)
                                .background(
                                    RoundedRectangle(
                                        cornerRadius: 30,
                                        style: .continuous
                                    )
                                    .fill(Color.blue)
                                )
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
            }.onAppear(perform: {
                vm.getProfile()
            })
        }
    }
}

struct ProfileSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
