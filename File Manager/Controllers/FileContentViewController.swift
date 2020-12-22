//
//  FileContentViewController.swift
//  File Manager
//
//  Created by Павел on 22.12.2020.
//

import UIKit

class FileContentViewController: UIViewController {
    
    private lazy var fileTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.toAutoLayout()
        return textView
    }()
    
    init(title: String, content: String?) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
        fileTextView.text = content
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setupSubviews()
    }
    
    private func addSubviews() {
        view.addSubview(fileTextView)
    }
    
    private func setupSubviews() {
        NSLayoutConstraint.activate([
            fileTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            fileTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fileTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            fileTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}
