//
//  Equatable+Extension.swift
//  App
//
//  Created by Ahmed Taha on 05/02/2024.
//

import UIKit

/// Match `enum` cases with associated values, while disregarding the values themselves.
/// - Parameter case: Looks like `Enum.case`.
public func ~= <Enum: Equatable, AssociatedValue>(
    case: (AssociatedValue) -> Enum,
    instance: Enum
) -> Bool {
    Mirror.associatedValue(of: instance, ifCase: `case`) != nil
}

/// Match `enum` cases with associated values, while disregarding the values themselves.
/// - Parameter case: Looks like `Enum.case`.
public func ~= <Enum, AssociatedValue>(
    case: (AssociatedValue) -> Enum,
    instance: Enum
) -> Bool {
    Mirror.associatedValue(of: instance, ifCase: `case`) != nil
}

/// Match non-`Equatable` `enum` cases without associated values.
public func ~= <Enum>(pattern: Enum, instance: Enum) -> Bool {
    guard (
        [pattern, instance].allSatisfy {
            let mirror = Mirror(reflecting: $0)
            return (mirror.displayStyle == .enum) && mirror.children.isEmpty
        }
    ) else { return false }
    
    return .equate(pattern, to: instance) { "\($0)" }
}

public extension Mirror {
    /// Get an `enum` case's `associatedValue`.
    static func associatedValue<AssociatedValue>(
        of subject: Any,
        _: AssociatedValue.Type = AssociatedValue.self
    ) -> AssociatedValue? {
        guard let childValue = Self(reflecting: subject).children.first?.value
        else { return nil }
        
        if let associatedValue = childValue as? AssociatedValue {
            return associatedValue
        }
        
        let labeledAssociatedValue = Self(reflecting: childValue).children.first
        return labeledAssociatedValue?.value as? AssociatedValue
    }
    
    /// Get an `enum` case's `associatedValue`.
    /// - Parameter case: Looks like `Enum.case`.
    static func associatedValue<Enum: Equatable, AssociatedValue>(
        of instance: Enum,
        ifCase case: (AssociatedValue) throws -> Enum
    ) rethrows -> AssociatedValue? {
        try associatedValue(of: instance)
            .filter { try `case`($0) == instance }
    }
    
    /// Get an `enum` case's `associatedValue`.
    /// - Parameter case: Looks like `Enum.case`.
    static func associatedValue<Enum, AssociatedValue>(
        of instance: Enum,
        ifCase case: (AssociatedValue) throws -> Enum
    ) rethrows -> AssociatedValue? {
        try associatedValue(of: instance).filter {
            .equate(try `case`($0), to: instance) {
                Self(reflecting: $0).children.first?.label
            }
        }
    }
}

public extension Optional {
    /// Transform `.some` into `.none`, if a condition fails.
    /// - Parameters:
    ///   - isSome: The condition that will result in `nil`, when evaluated to `false`.
    func filter(_ isSome: (Wrapped) throws -> Bool) rethrows -> Self {
        try flatMap { try isSome($0) ? $0 : nil }
    }
}

public extension Equatable {
    /// Equate two values using a closure.
    static func equate<Wrapped, Equatable: Swift.Equatable>(
        _ optional0: Wrapped?, to optional1: Wrapped?,
        using transform: (Wrapped) throws -> Equatable
    ) rethrows -> Bool {
        try optional0.map(transform) == optional1.map(transform)
    }
}
