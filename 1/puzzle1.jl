# Count how many times the dial is left at 0 after a rotation of the wheel.

function modular_add(a::Int, b::Int, ::Val{N}) where N
    return (a + b) % N
end

function modular_sub(a::Int, b::Int, ::Val{N}) where N
    if a >= b
        return (a - b) % N
    else
        return (a + N - b) % N
    end
end

# left => sub right => add

# 100 value dial
function right_rotation(dial::Int, distance::Int)
    return modular_add(dial, distance, Val(100))
end

function left_rotation(dial::Int, distance::Int)
    return modular_sub(dial, distance, Val(100))
end

function process_line(line::String, dial::Int)
    direction = line[1]
    distance = parse(Int, line[2:end])
    if direction == 'L'
        dial = left_rotation(dial, distance)
    elseif direction == 'R'
        dial = right_rotation(dial, distance)
    else
        error("Invalid direction: $direction")
    end
    return dial
end

function process_input(filename::String)
    dial = 50
    number_of_zeroes = 0
    for line in eachline(filename)
        dial = process_line(line, dial)
        if iszero(dial)
            number_of_zeroes += 1
        end
    end
    return number_of_zeroes
end

function @main(ARGS)
    println(Core.stdout, process_input(ARGS[1]))
    return 0
end


