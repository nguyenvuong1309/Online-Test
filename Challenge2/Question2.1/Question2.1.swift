import Foundation

// MARK: - Product Class

class Product {
    let name: String
    let price: Double
    var quantity: Int

    init(name: String, price: Double, quantity: Int) {
        self.name = name
        self.price = price
        self.quantity = quantity
    }
}

// MARK: - Inventory Manager

class InventoryManager {
    private var products: [Product]

    init(products: [Product] = []) {
        self.products = products
    }

    // Add a new product to the inventory
    func addProduct(_ product: Product) {
        products.append(product)
    }

    // Calculate the total inventory value
    func totalInventoryValue() -> Double {
        return products.reduce(0.0) { $0 + ($1.price * Double($1.quantity)) }
    }

    // Find the most expensive product
    func mostExpensiveProduct() -> String? {
        guard let mostExpensive = products.max(by: { $0.price < $1.price }) else {
            return nil
        }
        return mostExpensive.name
    }

    // Check if a product with the given name is in stock
    func isProductInStock(name: String) -> Bool {
        return products.contains(where: { $0.name.lowercased() == name.lowercased() && $0.quantity > 0 })
    }

    // Sorting options
    enum SortOption {
        case price
        case quantity
    }

    // Sort products based on the given option and order
    func sortProducts(by option: SortOption, ascending: Bool = true) -> [Product] {
        switch option {
        case .price:
            return products.sorted(by: ascending ? { $0.price < $1.price } : { $0.price > $1.price })
        case .quantity:
            return products.sorted(by: ascending ? { $0.quantity < $1.quantity } : { $0.quantity > $1.quantity })
        }
    }

    // Display all products
    func displayProducts() {
        for product in products {
            print("Name: \(product.name), Price: \(product.price), Quantity: \(product.quantity)")
        }
    }
}

// MARK: - Example Usage

// Create some sample products
let product1 = Product(name: "Laptop", price: 999.99, quantity: 10)
let product2 = Product(name: "Smartphone", price: 699.49, quantity: 25)
let product3 = Product(name: "Headphones", price: 199.99, quantity: 0)
let product4 = Product(name: "Monitor", price: 299.99, quantity: 15)
let product5 = Product(name: "Keyboard", price: 49.99, quantity: 50)

// Initialize the inventory manager and add products
let inventory = InventoryManager()
inventory.addProduct(product1)
inventory.addProduct(product2)
inventory.addProduct(product3)
inventory.addProduct(product4)
inventory.addProduct(product5)

// Calculate the total inventory value
let totalValue = inventory.totalInventoryValue()
print(String(format: "Total Inventory Value: %.2f", totalValue)) // Example output: 10599.82

// Find the most expensive product
if let expensiveProduct = inventory.mostExpensiveProduct() {
    print("Most Expensive Product: \(expensiveProduct)") // Example output: "Laptop"
} else {
    print("No products in inventory.")
}

// Check if "Headphones" is in stock
let headphonesInStock = inventory.isProductInStock(name: "Headphones")
print("Are Headphones in stock? \(headphonesInStock)") // Example output: false

// Sort products by price in descending order
let sortedByPriceDesc = inventory.sortProducts(by: .price, ascending: false)
print("\nProducts sorted by price (descending):")
for product in sortedByPriceDesc {
    print("Name: \(product.name), Price: \(product.price)")
}

// Sort products by quantity in ascending order
let sortedByQuantityAsc = inventory.sortProducts(by: .quantity, ascending: true)
print("\nProducts sorted by quantity (ascending):")
for product in sortedByQuantityAsc {
    print("Name: \(product.name), Quantity: \(product.quantity)")
}