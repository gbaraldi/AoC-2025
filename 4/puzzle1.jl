# Given a matrix of bools figure out how many true entries have less than 4 true entries in the square around them.
# This is basically a convolution with a kernel of 3x3.

using PaddedViews
# The easiest way to do this quickly is to read the matrix and pad it with zeros on all sides.
function process_matrix(in_matrix::Matrix{Bool})
    # Check that the matrices are padded correctly
    padded_in_matrix = PaddedView(false, in_matrix, (0:size(in_matrix,1)+1, 0:size(in_matrix,2)+1))
    out_matrix = fill!( similar(in_matrix), false)
    for i in 1:size(out_matrix, 2)
        @inbounds for j in 1 : size(out_matrix, 1)
            count = 0
            if padded_in_matrix[j, i] != true
                continue
            end
            for k in -1:1
                @inbounds for l in -1:1
                    if k == 0 && l == 0
                        continue
                    end
                    count += padded_in_matrix[j+l, i+k]
                end
            end
            out_matrix[j, i] = count < 4
        end
    end
    return out_matrix
end
# ..@@.@@@@.
# @@@.@.@.@@
# @@@@@.@.@@
# @.@@@@..@.
# @@.@@@@.@@
# @ are true, . are false


function parse_matrix(filename::AbstractString)
    @show nrows = countlines(filename)
    line1 = readline(filename)
    @show ncols = length(line1)
    matrix = Matrix{Bool}(undef, nrows, ncols)
    data = read(filename)
    current_row = 1
    current_col = 1
    @inbounds for idx in eachindex(data)
        if Char(data[idx]) == '\n'
            current_row += 1
            current_col = 1
            continue
        end
        if Char(data[idx]) == '.'
            matrix[current_row, current_col] = false
        else
            matrix[current_row, current_col] = true
        end
        current_col += 1
    end
    return matrix
end

function @main(ARGS)
    matrix = parse_matrix(ARGS[1])
    println(Core.stdout, sum(process_matrix(matrix)))
    return 0
end
