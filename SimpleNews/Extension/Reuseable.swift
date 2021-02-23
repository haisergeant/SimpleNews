//
//  Reuseable.swift
//
//  Created by Hai Le Thanh.
//
	
import UIKit

protocol Reuseable {
    static var reuseIdentifier: String { get }
}

extension Reuseable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionView {
    func dequeueReuseableCell<T: Reuseable>(indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    func register<T: UICollectionViewCell>(_: T.Type) where T: Reuseable {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
}
