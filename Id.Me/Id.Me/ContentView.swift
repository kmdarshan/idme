//
//  ContentView.swift
//  Id.Me
//
//  Created by darshan on 3/10/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, darshan!")
            .padding()
            .onAppear(perform: {
                Task {
                    let result = await Downloader(api: .real).downloadPurchaseHistory()
                    switch result {
                    case let .success(purchases):
                        for p in purchases {
                            print(p.price)
                        }
                        print(purchases.count)
                    case let .failure(error):
                        print("error \(error)")
                    }
                }
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
