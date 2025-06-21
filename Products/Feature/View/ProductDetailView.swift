//
//  ProductDetailView.swift
//  Products
//
//  Created by 공태웅 on 6/21/25.
//

import SwiftUI
import WebKit

struct ProductDetailView: View {
    
    // MARK: Properties
    
    let url: URL
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isLoading = true
    @State private var isErrorOccured = false
    
    var body: some View {
        VStack(spacing: 0) {
            navigationBar
            
            ZStack {
                webViewSection
                
                if isErrorOccured {
                    errorView
                } else if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

private extension ProductDetailView {
    var navigationBar: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                ZStack(alignment: .center) {
                    Image(systemName: "chevron.backward")
                        .renderingMode(.template)
                        .foregroundStyle(.black)
                }
                .frame(width: 44, height: 44)
            }
            
            Spacer()
        }
    }
    
    var errorView: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 25))
                .foregroundColor(.red)
            
            Text("에러가 발생했습니다.")
                .font(.system(size: 15))
                .foregroundColor(.primary)
        }
    }
    
    var webViewSection: some View {
        WebView(
            url: url,
            isLoading: $isLoading,
            isErrorOccured: $isErrorOccured
        )
        .background(Color(.systemBackground))
    }
}
