# Input contains a list of ranges, figure out how many numbers are covered by the ranges.

@enum RangeComparison begin
    FULLY_BEFORE
    FULLY_AFTER
    OVERLAPS
end

function compare_position(new_range::UnitRange{Int64}, range::UnitRange{Int64})
    if new_range.start < range.start && new_range.stop < range.start
        return FULLY_BEFORE 
    elseif new_range.start > range.stop
        return FULLY_AFTER
    else
        return OVERLAPS
    end
end

function union_ranges(range1::UnitRange{Int64}, range2::UnitRange{Int64})
    return UnitRange(min(range1.start, range2.start), max(range1.stop, range2.stop))
end

function insert_range(ranges::Vector{UnitRange{Int64}}, new_range::UnitRange{Int64})
    if isempty(new_range)
        return ranges
    end
    has_merged = false # if the new range has been merged with an existing range
    idx = 1
    while idx <= length(ranges)
        range = ranges[idx]
        comparison = compare_position(new_range, range)
        if comparison == FULLY_BEFORE
            if !has_merged
                insert!(ranges, idx, new_range)
            end
            return ranges
        elseif comparison == FULLY_AFTER
            idx += 1
            continue
        elseif comparison == OVERLAPS
            new_range = union_ranges(range, new_range)
            ranges[idx] = new_range
            if has_merged
                deleteat!(ranges, idx - 1)
            end
            has_merged = true
        end
        idx += 1
    end
    if !has_merged
        push!(ranges, new_range)
    end
    return ranges
end

# The input is first a list of ranges, an empty line, then a list of numbers.
function process_input(filename::AbstractString)
    # Store non overlapping ranges sorted by start
    ranges = UnitRange{Int64}[]
    for line in eachline(filename)
        if isempty(line)
            break
        end
        start, finish = split(line, '-')
        insert_range(ranges, UnitRange(parse(Int, start), parse(Int, finish)))
    end
    total = 0
    for range in ranges
        total += length(range)
    end
    return total
end

function @main(ARGS)
    println(Core.stdout, process_input(ARGS[1]))
    return 0
end
