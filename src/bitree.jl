mutable struct BallTreeNode
    leaf::Bool
end

mutable struct KDTreeNode
    leaf::Bool
end

mutable struct BinaryTree{N, T}
    x::T
    nodes::Vector{N}
    indices::Vector{Integer}
    L::Integer
    h::Integer
    n::Integer
    BinaryTree{N, T}() where {N, T} = new{N, T}()
end

function BinaryTree{N}(x; L::Integer=40) where N
    tree = BinaryTree{N, typeof(x)}()

    tree.L = L
    # Check x.
    tree.x = x

    nᵣ = size(tree.x, 1)
    tree.indices = [1:nᵣ;]
    tree.h = floor(Integer, log(2, (nᵣ - 1) / tree.L) + 1)
    tree.n = 2^tree.h - 1
    tree.nodes = Vector{N}(undef, tree.n)

    build!(tree, 1, 1, tree.n)

    return tree
end

function build!(
    tree::BinaryTree{N}, i::Integer, first::Integer, last::Integer
) where {N}
    add_node!(tree, i, first, last)
    if !(tree.nodes[i].leaf)
        m = (last - first + 1) / 2
        jₚ = argmax(maximum(tree.points, dims=1) - minimum(tree.points, dims=1))[2]
        # Sort node indices in the ascending order in terms of the dimension of x with
        # the largest spread.
        sort!(tree.indices, by=i->x[i, jₚ])
        build!(tree, 2 * i + 1, first, first + m - 1)
        build!(tree, 2 * i + 2, first + m, last)
    end
end

const BallTree{T} = BinaryTree{BallTreeNode, T}
const KDTree{T} = BinaryTree{KDTreeNode, T}

function add_node!(
    tree::BallTree, i::Integer, first::Integer, last::Integer
)
    print("Ball\n")
end

function add_node!(
    tree::KDTree, i::Integer, first::Integer, last::Integer
)
    print("KD\n")
end
