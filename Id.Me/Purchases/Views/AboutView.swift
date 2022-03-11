//
//  AboutView.swift
//  Id.Me
//
//  Created by darshan on 3/11/22.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            HStack {
                Text("About Purchases")
                Spacer()
                Image(systemName: "x.circle")
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
            }.padding()
            Text("This screen contains your entire purchase history. You can sort it by date of purchase. You can sort it by price. And you can filter it with the search bar.")
                .padding()
            Spacer()
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
