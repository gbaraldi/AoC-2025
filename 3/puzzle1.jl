# In a string of numbers find the pair of numbers that when concatenated form the largest number possible.
# They have to be in sequence but not adjacent, i.e 544437 would give 57


function process_input(filename::AbstractString)
    data = read(filename)
    total_joltage = 0
    highest_number = -1
    highest_after = -1
    previous_highest = -1
    for idx in eachindex(data)
        value = Char(data[idx])
        if value == '\n'
            if highest_number == -1 && previous_highest == -1 && highest_after == -1
                continue
            end
            if highest_after != -1
                joltage = 10 * highest_number + highest_after
                total_joltage += joltage
            else
                # highest number found is the last one in the line
                joltage = 10 * previous_highest + highest_number
                total_joltage += joltage
            end
            highest_number = -1
            highest_after = -1
            previous_highest = -1
            continue
        end
        number = parse(Int, value)
        if number > highest_number
            previous_highest = highest_number
            highest_number = number
            highest_after = -1
        elseif number > highest_after
            highest_after = number
        end

    end
    return total_joltage
end


function @main(ARGS)
    println(Core.stdout, process_input(ARGS[1]))
    return 0
end
