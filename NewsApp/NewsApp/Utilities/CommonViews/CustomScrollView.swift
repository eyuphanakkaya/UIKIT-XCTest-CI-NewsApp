//
//  CustomScrollView.swift
//  NewsApp
//
//  Created by Eyüphan Akkaya on 17.06.2026.
//


import Foundation
import UIKit
import SnapKit

final class CustomScrollView: UIView {
    // MARK: - Components
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    
    var arrangedSubViews: [UIView] {
        stackView.arrangedSubviews
    }
    
    var spacing: CGFloat {
        get {
            stackView.spacing
        } set {
            stackView.spacing = newValue
        }
    }
    
    var verticalScrollIndicatorEnabled: Bool {
        get {
            scrollView.showsVerticalScrollIndicator
        }
        set {
            scrollView.showsVerticalScrollIndicator = newValue
        }
    }
    
    override var layoutMargins: UIEdgeInsets {
        get {
            stackView.layoutMargins
        }
        set {
            stackView.layoutMargins = newValue
        }
    }
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func addArrangedSubview(_ views: UIView...) {
        views.forEach { view in
            stackView.addArrangedSubview(view)
        }
    }
    
    func setCustomSpacing(_ spacing: CGFloat,after arrangedSubview: UIView) {
        stackView.setCustomSpacing(spacing, after: arrangedSubview)
    }
}

// MARK: - Setup UI
private extension CustomScrollView {
    func setupUI() {
        configureStackView()
        setupConstraints()
        scrollView.showsVerticalScrollIndicator = false
    }
    
    func configureStackView() {
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
    }
    
    func setupConstraints() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
}
