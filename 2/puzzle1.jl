# Figure out if a number is made of repeating the same pattern of digits twice


# numbers that have odd number of digits cannot have a repeating pattern
function is_repeating_pattern(number::Int)
    if number < 10
        return false
    end
    if isodd(ndigits(number))
        return false
    end
    num_digits = digits(number)
    half_digits = length(num_digits) ÷ 2
    return @views num_digits[1:half_digits] == num_digits[half_digits+1:end]
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

