//
//  AppStoreCounterView.swift
//  GithubWidget
//
//  Created by Jean DAHER on 03/09/2026.
//

import SwiftUI

public struct AppStoreCounterView: View {
    
    @ObservedObject
    public var viewModel: AppStoreCounterViewModel
    private var delegate: AppStoreCounterViewDelegate?
    
    public init(
        viewModel: AppStoreCounterViewModel,
        delegate: AppStoreCounterViewDelegate? = nil
    ) {
        self.viewModel = viewModel
        self.delegate = delegate
    }
    
    public var body: some View {
        VStack(spacing: 3) {
            HStack {
                Text(viewModel.appRating)
                    .foregroundStyle(Color.white)
                    .font(.system(size: 25))
                    .bold()
                    .multilineTextAlignment(.center)
                Image("ic_app_rating_start", bundle: .module)
                    .renderingMode(.template)
                    .foregroundColor(.white)
            }
            Text(viewModel.reviewCount)
                .foregroundStyle(Color.white)
                .font(.system(size: 12))
                .bold()
                .multilineTextAlignment(.center)
            
        }
        .frame(maxHeight: .infinity)
    }
}

import WidgetFoundation

#Preview {
    AppStoreCounterView(
        viewModel: AppStoreCounterViewModel(
            appRating: "3.5", reviewCount: "1123"
        )
    )
    .toWidget()
}
