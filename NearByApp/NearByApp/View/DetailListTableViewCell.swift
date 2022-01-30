//
//  DetailListTableViewCell.swift
//  NearByApp
//
//  Created by miori Lee on 2022/01/30.
//

import UIKit

class DetailListTableViewCell: UITableViewCell {

    let placeNameLabel = UILabel()
    let addressLabel = UILabel()
    let distanceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribue()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribue(){
        backgroundColor = .white
        placeNameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        addressLabel.font = .systemFont(ofSize: 14)
        addressLabel.textColor = .gray
        distanceLabel.font = .systemFont(ofSize: 12, weight: .light)
        distanceLabel.textColor = .darkGray
    }
    
    private func layout(){
        [placeNameLabel,addressLabel,distanceLabel].forEach {
            contentView.addSubview($0)
        }
        placeNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().offset(12)
        }
        
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(placeNameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(placeNameLabel)
            $0.bottom.equalToSuperview().inset(8)
        }
        
        distanceLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
        }
    }

    func setData(_ dataEntity : DetailCellData) {
        placeNameLabel.text = dataEntity.placeName
        addressLabel.text = dataEntity.addressName
        distanceLabel.text = dataEntity.distance
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
