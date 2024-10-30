import Foundation

func findMissingNumberSum(arr: [Int], n: Int) -> Int {
    // Calculate the expected sum from 1 to n + 1
    let total = (n + 1) * (n + 2) / 2
    
    // Calculate the sum of the elements in the array
    let sumOfArr = arr.reduce(0, +)
    
    // The missing number is the difference between the expected sum and the actual sum
    return total - sumOfArr
}

// Example usage
let arr1 = [1, 2, 4, 5]
let n1 = 4
let missing1 = findMissingNumberSum(arr: arr1, n: n1)
print("The missing number (Sum) is: \(missing1)") // Output: The missing number is: 3


func findMissingNumberXOR(arr: [Int], n: Int) -> Int {
    var xorAll = 0
    var xorArr = 0
    
    // XOR all numbers from 1 to n + 1
    for num in 1...(n + 1) {
        xorAll ^= num
    }
    
    // XOR all elements in the array
    for num in arr {
        xorArr ^= num
    }
    
    // The missing number is the XOR of the two results above
    return xorAll ^ xorArr
}

// Example usage
let arr2 = [1, 2, 4, 5]
let n2 = 4
let missing2 = findMissingNumberXOR(arr: arr2, n: n2)
print("The missing number (XOR) is: \(missing2)") // Output: The missing number is: 3




func findMissingNumber(_ nums: [Int]) -> Int {
    let sortedNums = nums.sorted()
    for (index, num) in sortedNums.enumerated() {
        if num != index + 1 {
            return index + 1
        }
    }
    return nums.count + 1
}

// Example usage:
let inputArray = [1, 2, 4, 5, 6]
let missingNumber = findMissingNumber(inputArray)
print("The missing number is \(missingNumber)")
