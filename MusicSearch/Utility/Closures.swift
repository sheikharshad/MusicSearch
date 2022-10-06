//
//  Closures.swift
//  MusicSearch
//
//  Created by Arshad shaikh on 05/10/2022.
//

typealias GenericInClosure<T> = ((T) -> Void)
typealias GenericInOutClosure<T, O> = ((T) -> O)
typealias GenericOutClosure<T> = (() -> T)
typealias EmptyClosure = (() -> Void)
