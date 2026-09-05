//
//  PlayStoreCounterViewDelegate.swift
//  GithubWidget
//
//  Created by Jean DAHER on 03/09/2026.
//

@MainActor
public protocol PlayStoreCounterViewDelegate: AnyObject {
    func didRequestRefresh()
}
