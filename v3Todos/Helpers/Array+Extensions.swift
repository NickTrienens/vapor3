//
//  Array+Extensions.swift
//  FuzzKit
//
//  Created by Nicholas Trienens on 11/06/17.
//  Copyright © 2017 Fuzz Productions, LLC. All rights reserved.
//

import Foundation

extension Array {

    /// return a random item from an array
    ///
    /// - Returns: an optional element , optional to allow for empty arrays
    func random() -> Element? {
        if count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(count)))
            return self[randomIndex]
        } else {
            return nil
        }
    }

    /// Safe access for array indexes
    ///
    /// - Parameter index: index to retrieve, it is tested against the array's bounds
    /// - Returns: optional element, if possible to accesss nil if not
    func elementAt(_ index: Int) -> Element? {
        if count > 0 && count > index {
            return self[index]
        } else {
            return nil
        }
    }
    
	/// iterates over `self` array and a passed in array and returns zipped elements that `match` based
	/// as defined by the passed in `match` function.
	/// - Note: if elements don't match, they are ignored.
	///
	/// - Parameters:
	///   - secondArray: array with elements that should be `match`ed against elements from the `self` array.
	///   - match: a definition by which elements of both arrays should be matched.
	/// - Returns: an array of zipped elements whom match based off of the `match` function.
	func findMatches<T>(in secondArray: [T], match: (Element, T) -> Bool) -> [(Element, T)] {
		return self.compactMap { element in
			guard let t = secondArray.first(where: { match(element, $0) }) else { return nil }
			return (element, t)
		}
	}
}

extension Array where Element: Hashable {
    /// Create a new `Array` without duplicate elements. The initial order of the elements is not maintained in the
    /// returned value.
    ///
    /// - Returns: A new `Array` without duplicate elements.
    func deduplicated() -> Array {
        return Array(Set<Element>(self))
    }
    
    /// Strip duplicate elements from the array. The initial order of the elements is not maintained after the strip.
    mutating func deduplicate() {
        self = deduplicated()
    }
}

extension Array where Iterator.Element: Equatable {

	func elements(equaling item: Iterator.Element) -> [Iterator.Element] {
		var newArray = self
		for obj in self where obj == item {
			newArray.append(obj)
		}
		return newArray
	}
	
	func includes(equaling item: Iterator.Element) -> Bool {
		for obj in self where obj == item {
			return true
		}
		return false
	}
	
	func includes(equaling item: Iterator.Element?) -> Bool {
		guard item != nil else { return	false }
		for obj in self where obj == item {
			return true
		}
		return false
	}
	
	func element(equaling item: Iterator.Element) -> Iterator.Element? {
		for obj in self where obj == item {
			return obj
		}
		return nil
	}
	
	mutating func remove(from item: Iterator.Element) {
		if let ind = index(of: item) {
			remove(at: ind)
		}
	}
	
	func remove(_ item: Iterator.Element) -> [Iterator.Element] {
		var newArray = self
		if let ind = newArray.index(of: item) {
			newArray.remove(at: ind)
		}
		return newArray
	}
	
	func replace(_ item: Iterator.Element) -> [Iterator.Element] {
		let newArr: [Iterator.Element] = self.map { oldItem in
			if oldItem == item {
				return item
			}
			return oldItem
		}
		return newArr
	}
}
