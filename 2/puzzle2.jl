# Figure out if a number is made of repeating the same pattern of digits any number of times
using Primes

# numbers that have odd number of digits cannot have a repeating pattern
function is_repeating_pattern(number::Int)
    if number < 10
        return false
    end
    # check N where N is a valid divisor of ndigits(number)
    num_digits = ndigits(number)
    # first divisor is 1
    num_divisors = @view divisors(num_digits)[2:end]
    num_digits = digits(number)
    for divisor in num_divisors
        partition_size = length(num_digits) ÷ divisor
        iter = Iterators.partition(num_digits, partition_size)
        first_partition, state = iterate(iter)
        found = true
        next = iterate(iter, state)
        while next !== nothing
            if first_partition != first(next)
                found = false
                break
            end
            next = iterate(iter, last(next))
        end
        if found
            return true
        end
    end
    return false
end

# return the sum of the numbers that have a repeating pattern
function process_range(range::AbstractString)
    iter = eachsplit(range, '-')
    first_number_str, state = iterate(iter)
    first_number = parse(Int, first_number_str)
    last_number_str, state = iterate(iter, state)
    last_number = parse(Int, last_number_str)
    sum = 0
    for number in first_number:last_number
        if is_repeating_pattern(number)
            sum += number
        end
    end
    return sum
end

function process_input(filename::AbstractString)
    sum = 0
    for range in eachsplit(readchomp(filename), ',')
        sum += process_range(range)
    end
    return sum
end

function @main(ARGS)
    println(Core.stdout, process_input(ARGS[1]))
    return 0
end

