//
//  AppStoreCounterViewDelegate.swift
//  GithubWidget
//
//  Created by Jean DAHER on 03/09/2026.
//

@MainActor
public protocol AppStoreCounterViewDelegate: AnyObject {
    func didRequestRefresh()
}
