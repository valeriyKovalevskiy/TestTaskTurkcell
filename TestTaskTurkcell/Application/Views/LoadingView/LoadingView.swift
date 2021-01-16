//
//  LoadingView.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/16/21.
//

import UIKit

final class LoadingView: UIView {
    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }
    
    // MARK: - Private
    private func setup() {
        if let view = loadViewFromNib() {
            view.frame = self.bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(view)
        }
    }

    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: Constants.Nibs.LoadingView, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView

        return view
    }

    // MARK: - Open
    func show() {
        self.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hide() {
        activityIndicator.stopAnimating()
        self.isHidden = true
    }
}
