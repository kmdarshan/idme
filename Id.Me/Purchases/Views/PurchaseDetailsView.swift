//
//  PurchaseDetailsView.swift
//  Id.Me
//
//  Created by darshan on 3/11/22.
//

import SwiftUI

struct PurchaseDetailsView: View {
    @State var showAdditionalDetailsOnClick = false
    let vm = PurchaseHistoryViewModel()
    let purchase: Purchase
    init(purchase: Purchase) {
        self.purchase = purchase
    }

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: purchase.image), content: { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(maxWidth: 50, maxHeight: 500)
            }, placeholder: {
                ProgressView()
            })
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(purchase.itemName)
                        .font(.headline)
                    Text(vm.getDateString(purchase))
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    if showAdditionalDetailsOnClick {
                        Text("Description:")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        Text(purchase.serial)
                            .foregroundColor(.gray)
                            .font(.subheadline)
						Text(vm.getFormattedDescription(purchase))
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                }
                Spacer()
                HStack {
                    Text(vm.getPrice(purchase))
                }
            }
        }
        .onTapGesture {
            showAdditionalDetailsOnClick.toggle()
        }
    }
}

struct PurchaseDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseDetailsView(purchase: Purchase.samplePurchases![0])
    }
}
