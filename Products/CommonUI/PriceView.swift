//
//  PriceView.swift
//  ProductsTests
//
//  Created by 공태웅 on 6/21/25.
//

import SwiftUI

struct PriceView: View {
    
    // MARK: Definitions
    
    struct DiscountInfo {
        let discountPrice: Int
        let discountRate: Int
        
        init?(discountPrice: Int, discountRate: Int) {
            guard discountRate > 0 else { return nil }
            self.discountPrice = discountPrice
            self.discountRate = discountRate
        }
    }
    
    // MARK: Properties
    
    let price: Int
    let discountInfo: DiscountInfo?
    
    var body: some View {
        Group {
            if let discountInfo {
                VStack(alignment: .leading, spacing: 3) {
                    Text("\(price.formatted)원")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .strikethrough()
                        .lineLimit(1)
                    
                    HStack(spacing: 2) {
                        Text("\(discountInfo.discountRate)%")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.red)
                            .lineLimit(1)

                        HStack(alignment: .center, spacing: 0) {
                            Text(discountInfo.discountPrice.formatted)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.primary)
                                .lineLimit(1)
                            
                            Text("원")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.primary)
                                .lineLimit(1)
                        }
                    }
                }
            } else {
                HStack(alignment: .center, spacing: 0) {
                    Text(price.formatted)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Text("원")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    VStack(spacing: 30) {
        PriceView(price: 58600, discountInfo: .init(discountPrice: 46880, discountRate: 20))
        
        PriceView(price: 12000, discountInfo: .init(discountPrice: 10800, discountRate: 10))
        
        PriceView(price: 12000, discountInfo: nil)
    }
}
