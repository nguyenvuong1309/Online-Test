import Foundation

func findMissingNumberSum(arr: [Int], n: Int) -> Int {
    // Tính tổng dự kiến từ 1 đến n + 1
    let total = (n + 1) * (n + 2) / 2
    
    // Tính tổng các phần tử trong mảng
    let sumOfArr = arr.reduce(0, +)
    
    // Số bị mất là hiệu giữa tổng dự kiến và tổng thực tế
    return total - sumOfArr
}

// Ví dụ sử dụng
let arr1 = [1, 2, 4, 5]
let n1 = 4
let missing1 = findMissingNumberSum(arr: arr1, n: n1)
print("Số bị mất (Sum) là: \(missing1)") // Output: Số bị mất là: 3


func findMissingNumberXOR(arr: [Int], n: Int) -> Int {
    var xorAll = 0
    var xorArr = 0
    
    // XOR tất cả các số từ 1 đến n + 1
    for num in 1...(n + 1) {
        xorAll ^= num
    }
    
    // XOR tất cả các phần tử trong mảng
    for num in arr {
        xorArr ^= num
    }
    
    // Số bị mất là XOR của hai kết quả trên
    return xorAll ^ xorArr
}

// Ví dụ sử dụng
let arr2 = [1, 2, 4, 5]
let n2 = 4
let missing2 = findMissingNumberXOR(arr: arr2, n: n2)
print("Số bị mất (XOR) là: \(missing2)") // Output: Số bị mất là: 3