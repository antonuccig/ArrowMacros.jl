function _setfield!(s, b, a)
    if isstructtype(typeof(s))
        if isdefined(s, b)
            return setfield!(s, b, a)
        end
    end
    return b
end

"""
    @↑ s = a, b ← abs(b), ...

packs fields into mutable structs or sub-structs.
"""
macro ↑(input)
    s = input.args[1]
    vars = input.args[2]
    vars = vars isa Symbol ? [vars] : vars.args
    output = Expr(:block)
    for v in vars
        if v isa Symbol
            b = a = v
        elseif v isa Expr && v.args[1] == :←
            b, a = v.args[2:3]
        end
        b_ = string(b)
        push!(output.args, :($_setfield!($s, Symbol($b_), $a)))
    end
    esc(output)
end