//
//  ViewController.swift
//  WorldClockMVVMExample
//
//  Created by iMac on 2022/03/04.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private var date: Date?

    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18.0, weight: .bold)
        label.text = "Loading..."
        label.textColor = .label
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        
        let prevButton = UIButton()
        prevButton.setTitle("Prev", for: .normal)
        prevButton.setTitleColor(.label, for: .normal)
        prevButton.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        prevButton.layer.borderWidth = 1
        prevButton.layer.cornerRadius = 10
        prevButton.addTarget(self, action: #selector(didTapPrev), for: .touchUpInside)
        prevButton.snp.makeConstraints {
            $0.width.equalTo(80)
        }
        
        let nowButton = UIButton()
        nowButton.setTitle("Now", for: .normal)
        nowButton.setTitleColor(.label, for: .normal)
        nowButton.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        nowButton.layer.borderWidth = 1
        nowButton.layer.cornerRadius = 10
        nowButton.addTarget(self, action: #selector(didTapNow), for: .touchUpInside)
        nowButton.snp.makeConstraints {
            $0.width.equalTo(80)
        }
        
        
        let nextButton = UIButton()
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.label, for: .normal)
        nextButton.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        nextButton.layer.borderWidth = 1
        nextButton.layer.cornerRadius = 10
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        nextButton.snp.makeConstraints {
            $0.width.equalTo(80)
        }
        
        [prevButton, nowButton, nextButton]
            .forEach {
                stackView.addArrangedSubview($0)
            }
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        didTapNow()
    }


}

private extension ViewController {
    func setupViews() {
        [timeLabel, stackView]
            .forEach {
                view.addSubview($0)
            }
        
        timeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        let inset: CGFloat = 16.0
        stackView.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(inset)
            $0.leading.equalToSuperview().offset(inset)
            $0.trailing.equalToSuperview().inset(inset)
        }
        
    }
    
    @objc func didTapPrev() {
        guard let date = self.date else { return }
        let movedDate = self.moveData(day: -1, date: date)
        self.timeLabel.text = self.convertDisplayDate(date: movedDate)
        self.date = movedDate
    }
    
    @objc func didTapNow() {
        NetworkManager().requestTime { [weak self] time in
            guard let self = self else { return }
            self.date = self.stringToDate(stringDate: time.dateTime)
            
            guard let date = self.date else { return }
            
            self.timeLabel.text = self.convertDisplayDate(date: date)
            
        }
    }
    
    @objc func didTapNext() {
        guard let date = self.date else { return }
        let movedDate = self.moveData(day: 1, date: date)
        self.timeLabel.text = self.convertDisplayDate(date: movedDate)
        self.date = movedDate
        
    }
    
    func stringToDate(stringDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm'Z'"
        let date = dateFormatter.date(from: stringDate)
        guard let date = date else { return Date()}
        return date
    }
    
    
    func convertDisplayDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM년 dd일 HH시 mm분"
        return dateFormatter.string(from: date)
    }
    
    func moveData(day: Int, date: Date) -> Date {
        guard let movedDay = Calendar.current.date(byAdding: .day, value: day, to: date) else { return Date() }
        return movedDay
    }
}

