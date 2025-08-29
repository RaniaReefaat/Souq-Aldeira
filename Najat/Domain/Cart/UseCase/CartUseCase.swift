//
//  CartUseCase.swift
//  Najat
//
//  Created by mahroUS on 05/08/2567 BE.
//
import Foundation
protocol CartUseCasesProtocol {
    func getCartList() async -> RequestResponse<CartListEntityModel>
    func showCart(cartID: Int) async -> RequestResponse<CartDataModel>
    func deleteItem(cartID: Int, itemID: Int) async -> RequestResponse<EmptyData>
    func addToCart(body: AddToCartBody) async -> RequestResponse<EmptyData>
    func makeCart(cartID: String, body: CheckCartBody) async -> RequestResponse<String>
    func checkCoupon(code: String, subtotal: String) async -> RequestResponse<CouponEntity>
    
}

final class CartUseCases: CartUseCasesProtocol {
    
    let repo: CartRepoInterface
    var bag = AppBag()
    
    init(repo: CartRepoInterface = CartRepository()) {
        self.repo = repo
    }
    
    func getCartList() async -> RequestResponse<CartListEntityModel> {
        await repo.getCartList()
            .singleOutput(with: &bag)
            .result()
    }
    
    func showCart(cartID: Int) async -> RequestResponse<CartDataModel> {
        await repo.showCart(cartID: cartID)
            .singleOutput(with: &bag)
            .result()
            .map { item in
                CartDataModel(
                    id: item.id.unwrapped(or: -1),
                    store: item.store ?? Store(id: -1, name: "", image: "", bio: "", whatsapp: "", email: "",role: "",products: [],shareLnk: "",is_followed: false),
                    items: item.items?.map { item in
                        ItemEntity(
                            id: item.id,
                            product: item.product,
                            qty: item.qty,
                            price: item.price,
                            total: item.total
                        )
                    } ?? [],
                    subtotal: item.subtotal ?? 0,
                    deliveryFee: item.deliveryFee ?? 0,
                    total: item.total ?? 0
                )
            }
    }
    func deleteItem(cartID: Int, itemID: Int) async -> RequestResponse<EmptyData> {
        await repo.deleteItem(cartID: cartID, itemID: itemID)
            .singleOutput(with: &bag)
            .result()
    }

    func addToCart(body: AddToCartBody) async -> RequestResponse<EmptyData> {
        await repo.addToCart(body: body)
            .singleOutput(with: &bag)
            .result()
    }
    
    func makeCart(cartID: String, body: CheckCartBody) async -> RequestResponse<String> {
        await repo.makeCart(cartID: cartID, body: body)
            .singleOutput(with: &bag)
            .result()
    }
    
    func checkCoupon(code: String, subtotal: String) async -> RequestResponse<CouponEntity> {
        await repo.checkCoupon(code: code, subtotal: subtotal)
            .singleOutput(with: &bag)
            .result()
    }
}
