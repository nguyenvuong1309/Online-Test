# Finding the Missing Number in an Array

This README provides an overview of various algorithms to efficiently find a missing number in an array containing integers from **1** to **n + 1** with exactly one number missing. It covers three primary methods: Summation, XOR, and Sorting. Each method is explained in detail with corresponding code examples in Python.

## Table of Contents

- [Problem Statement](#problem-statement)
- [Methods to Find the Missing Number](#methods-to-find-the-missing-number)
  - [1. Summation Method](#1-summation-method)
  - [2. XOR Method](#2-xor-method)
  - [3. Sorting Method](#3-sorting-method)
- [Comparison of Methods](#comparison-of-methods)
- [Usage Examples](#usage-examples)
- [Conclusion](#conclusion)
- [License](#license)

## Problem Statement

Given an array containing **n** distinct integers where each integer is in the range **1** to **n + 1** (inclusive), exactly one number from this range is missing. The task is to identify the missing number efficiently in terms of both time and space complexity.

### Example

```plaintext
Input: [1, 2, 4, 5, 6]
Output: 3
```

### Methods to Find the Missing Number

#### 1. Summation Method

##### Conecpt:

Calculate the expected sum of numbers from 1 to n + 1 using the arithmetic series formula. Then, subtract the sum of the elements in the array from this expected sum. The result will be the missing number.

##### Steps:

1. Calculate the theoretical sum using the formula:
   $$
   \text{Sum}_{\text{theoretical}} = \frac{(n+1)(n+2)}{2}
   $$
2. Compute the actual sum of all elements in the array.

3. Find the missing number by subtracting the actual sum from the theoretical sum:
   $$
   \text{Missing Number} = \text{Sum}_{\text{theoretical}} - \text{Sum}_{\text{actual}}
   $$

##### Complexity:

- Time: `O(n)` – Iterates through the array once to compute the sum.
- Space: `O(1)` – Uses constant extra space.

#### 2. XOR Method

##### Conecpt:

Utilize the XOR (exclusive OR) operation to cancel out paired numbers, leaving the missing number as the result.

##### Steps:

1. Initialize a variable `xor_all` to 0.
2. XOR all numbers from 1 to n + 1 with `xor_all`.
3. XOR all elements in the array with `xor_all`.
4. The remaining value in `xor_all` is the missing number.

##### Why it work:

- XOR of a number with itself is 0.
- XOR of a number with 0 is the number itself.
- All paired numbers cancel out, leaving only the missing number

##### Complexity:

- Time: `O(n)` – Iterates through the range and the array once.
- Space: `O(1)` – Uses constant extra space.

#### 3. Sorting Method

##### Conecpt:

Sort the array and then iterate through it to find the first position where the number doesn't match its expected value.

##### Steps:

1. Sort the array in ascending order.
2. Iterate through the sorted array, comparing each element with its expected value (i.e., index + 1).
3. Identify the missing number when a discrepancy is found.
4. If no discrepancy is found during iteration, the missing number is n + 1.

##### Why it work:

- XOR of a number with itself is 0.
- XOR of a number with 0 is the number itself.
- All paired numbers cancel out, leaving only the missing number

##### Complexity:

- Time: `O(n log n) ` – Due to the sorting step.
- Space: `O(n)` or `O(1)` – Depending on the sorting algorithm used.

## Comparison of Methods

| Method           | Time Complexity | Space Complexity | Description                                                     |
| ---------------- | --------------- | ---------------- | --------------------------------------------------------------- |
| Summation Method | O(n)            | O(1)             | Calculates expected and actual sums to find the missing number. |
| XOR Method       | O(n)            | O(1)             | Uses XOR operations to isolate the missing number.              |
| Sorting Method   | O(n log n)      | O(n) or O(1)     | Sorts the array and checks for discrepancies.                   |

## Conclusion

Finding the missing number in an array of integers can be efficiently achieved using the Summation Method or the XOR Method, both offering
`O(n)` time complexity and `O(1)` space complexity. The Sorting Method, while straightforward, is less optimal due to its higher time complexity. Choose the method that best fits your application's requirements and constraints.

## License

This project is created by [Nguyen Duc Vuong](https://github.com/nguyenvuong1309).
