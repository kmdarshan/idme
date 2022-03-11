//
//  PurchasesHistoryView.swift
//  Id.Me
//
//  Created by darshan on 3/11/22.
//

import SwiftUI

struct PurchasesHistoryView: View {
    @StateObject var vm = PurchaseHistoryViewModel()
    @State var showAbout: Bool = false
    var body: some View {
        List {
            ForEach(0 ..< vm.purchases.count, id: \.self) { idx in
                PurchaseDetailsView(purchase: vm.purchases[idx])
                    .listRowSeparator(.hidden)
            }
        }.onAppear(perform: {
            vm.getPurchases()
        })
        .navigationTitle("Purchases")
        .navigationBarItems(
            trailing:
            HStack {
                Button {
                    showAbout.toggle()
                } label: {
                    Image(systemName: "info")
                }
                .sheet(isPresented: $showAbout, onDismiss: {}, content: {
                    AboutView()
                })
            }
        )
    }
}

struct PurchasesHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        PurchasesHistoryView()
    }
}
