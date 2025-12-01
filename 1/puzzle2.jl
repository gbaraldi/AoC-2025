# Count how many times the dial is left at 0 after a rotation of the wheel.

# b must be smaller than N
function modular_add_with_carry(a::Int, b::Int, ::Val{N}) where N
    result = (a + b)
    carry = 0
    if result >= N
        carry = 1
        result = result % N
    end
    carry |= result == 0
    return result, carry
end

# b must be smaller than N
# the complexity is due to cases where we start at zero and go to N-1 since that doesn't count as crossing zero
function modular_sub_with_carry(a::Int, b::Int, ::Val{N}) where N
    carry = 0
    if a == 0 
        carry = 0
        result = N - b
    elseif a >= b
        carry = 0
        result = a - b
    else
        carry = 1
        result = a + N - b
    end
    carry |= result == 0
    return result, carry
end

# left => sub right => add

# 100 value dial
# Also check if we crossed zero during the rotation
function right_rotation(dial::Int, distance::Int)
    # split distance into rotations and remainder
    rotations = distance ÷ 100
    remainder = distance % 100
    dial, carry = modular_add_with_carry(dial, remainder, Val(100))
    return dial, rotations + carry
end

function left_rotation(dial::Int, distance::Int)
    rotations = distance ÷ 100
    remainder = distance % 100
    dial, carry = modular_sub_with_carry(dial, remainder, Val(100))
    return dial, rotations + carry
end

function process_line(line::String, dial::Int)
    # @show line, dial
    direction = line[1]
    distance = parse(Int, line[2:end])
    if direction == 'L'
        dial, rotations = left_rotation(dial, distance)
    elseif direction == 'R'
        dial, rotations = right_rotation(dial, distance)
    else
        error("Invalid direction: $direction")
    end
    # @show dial, rotations
    return dial, rotations
end

function process_input(filename::String)
    dial = 50
    number_of_zeroes = 0
    for line in eachline(filename)
        dial, rotations = process_line(line, dial)
        number_of_zeroes += rotations
    end
    return number_of_zeroes
end

function @main(ARGS)
    println(Core.stdout,process_input(ARGS[1]))
    return 0
end


