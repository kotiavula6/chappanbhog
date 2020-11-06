//
//  MyOrderModel.swift
//  ChappanBhog
//
//  Created by Dheeraj Chauhan on 16/10/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

import Foundation


// MARK: - Welcome
struct MyOrderModel: Codable {
    let success: Int
    let msg: String
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let id: Int
    let orderNumber: String
    let createdAt : String
    //let createdAt, updatedAt, completedAt: Date
    let status, currency, total, subtotal: String
    let totalLineItemsQuantity: Int
    let totalTax, totalShipping, cartTax, shippingTax: String
    let totalDiscount, shippingMethods: String
    let paymentDetails: PaymentDetails
    let billingAddress, shippingAddress: IngAddress
    let note, customerIP, customerUserAgent: String
    let customerID: Int
    let viewOrderURL: String
    let lineItems: [LineItem]
    let shippingLines: [ShippingLine]
    let taxLines, feeLines, couponLines: [JSONAny]
    let wpoWcpdfInvoiceNumber: String
    let customer: Customer

    enum CodingKeys: String, CodingKey {
        case id
        case orderNumber = "order_number"
        
        case createdAt = "created_at"
        //case updatedAt = "updated_at"
       // case completedAt = "completed_at"
        case status, currency, total, subtotal
        case totalLineItemsQuantity = "total_line_items_quantity"
        case totalTax = "total_tax"
        case totalShipping = "total_shipping"
        case cartTax = "cart_tax"
        case shippingTax = "shipping_tax"
        case totalDiscount = "total_discount"
        case shippingMethods = "shipping_methods"
        case paymentDetails = "payment_details"
        case billingAddress = "billing_address"
        case shippingAddress = "shipping_address"
        case note
        case customerIP = "customer_ip"
        case customerUserAgent = "customer_user_agent"
        case customerID = "customer_id"
        case viewOrderURL = "view_order_url"
        case lineItems = "line_items"
        case shippingLines = "shipping_lines"
        case taxLines = "tax_lines"
        case feeLines = "fee_lines"
        case couponLines = "coupon_lines"
        case wpoWcpdfInvoiceNumber = "wpo_wcpdf_invoice_number"
        case customer
    }
}

// MARK: - IngAddress
struct IngAddress: Codable {
    let firstName, lastName, company, address1: String
    let address2, city, state, postcode: String
    let country: String
    let email, phone: String?
    
    var fullAddress: String {
        var str = ""
        if !firstName.isEmpty {
            str = self.firstName
        }
        if !lastName.isEmpty {
            str.append(" \(lastName)")
        }
        if !address1.isEmpty {
            str.append(", \(address1)")
        }
        if !address2.isEmpty {
            str.append(", \(address2)")
        }
        if !city.isEmpty {
            str.append(", \(city)")
        }
        if !state.isEmpty {
            str.append(", \(state)")
        }
        if !postcode.isEmpty {
            str.append(", \(postcode)")
        }
        if !country.isEmpty {
            str.append(", \(country)")
        }
        return str
    }

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case company
        case address1 = "address_1"
        case address2 = "address_2"
        case city, state, postcode, country, email, phone
    }
}

// MARK: - Customer
struct Customer: Codable {
    let id: Int
   // let createdAt: Date
    let email, firstName, lastName, username: String
    let role: String
    let lastOrderID: Int
    let lastOrderDate: String
    let ordersCount: Int
    let totalSpent: String
    let avatarURL: String
    let billingAddress, shippingAddress: IngAddress

    enum CodingKeys: String, CodingKey {
        case id
    //    case createdAt = "created_at"
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case username, role
        case lastOrderID = "last_order_id"
        case lastOrderDate = "last_order_date"
        case ordersCount = "orders_count"
        case totalSpent = "total_spent"
        case avatarURL = "avatar_url"
        case billingAddress = "billing_address"
        case shippingAddress = "shipping_address"
    }
}

// MARK: - LineItem
struct LineItem: Codable {
    let id: Int
    let subtotal, subtotalTax, total, totalTax: String
    let price: String
    let quantity: Int
    let taxClass, name: String
    let productID: Int
    let sku: String
    let meta: [JSONAny]
    let image: String

    enum CodingKeys: String, CodingKey {
        case id, subtotal
        case subtotalTax = "subtotal_tax"
        case total
        case totalTax = "total_tax"
        case price, quantity
        case taxClass = "tax_class"
        case name
        case productID = "product_id"
        case sku, meta
        case image
    }
}

// MARK: - PaymentDetails
struct PaymentDetails: Codable {
    let methodID, methodTitle: String
    let paid: Bool

    enum CodingKeys: String, CodingKey {
        case methodID = "method_id"
        case methodTitle = "method_title"
        case paid
    }
}

// MARK: - ShippingLine
struct ShippingLine: Codable {
    let id: Int
    let methodID, methodTitle, total: String

    enum CodingKeys: String, CodingKey {
        case id
        case methodID = "method_id"
        case methodTitle = "method_title"
        case total
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}

