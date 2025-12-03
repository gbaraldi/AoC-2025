# In a string of numbers find the group of numbers that when concatenated form the largest number possible. In this case 12
# They have to be in sequence but not adjacent, i.e 544437 would give 57 

# We can treat the numbers as a sequence and subsequences. 

# We can allocate a triangular matrix to store the subsequences, 
# Each row contains the best subsequence that has been found since we updated the row above.
# For each digit, we scan the rows from bottom to top checking if the digit should be appended 

# The last row contains the current best number, 

using LinearAlgebra

# extra space for the new digit

@inline function update_digit_array(digit_array::Vector, digit)
    digit_array[end] = digit
    @inbounds for idx in 1:length(digit_array) - 1
        # if the digit is less than the one after it, shift the array to the left
        if digit_array[idx] < digit_array[idx + 1]
            for i in idx : length(digit_array) - 1
                digit_array[i] = digit_array[i + 1]
            end
            break
        end
    end
    digit_array
end


function process_input(filename::AbstractString, _::Val{N}) where N
    data = read(filename)
    total_joltage = 0
    digit_array = zeros(Int, N + 1) # extra space for the new digit
    for idx in eachindex(data)
        value = Char(data[idx])
        if value == '\n'
            number = 0
            @inbounds for idx in 1:N
                number = number * 10 + digit_array[idx]
            end
            total_joltage += number
            fill!(digit_array, 0)
            continue
        end
        number = parse(Int, value)
        update_digit_array(digit_array, number)
    end
    return total_joltage
end


function @main(ARGS)
    println(Core.stdout, process_input(ARGS[1], Val(12)))
    return 0
end
