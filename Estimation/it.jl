include("SurfingInfo.jl")


# Analysis on 
ISOindex = Dict([ISOs[i]=>i for i in 1:length(ISOs)])
Um = []
Rm = []
UmO = []
RmO = []
for comp in sort.(collect.(unique(map(x-> x.panelOrigs, waves))))

    # Defining uniform measure for off-panel origs
    offPanel = [ ISOindex[c] for c in setdiff(ISOs,comp)]
    UnifOff = zeros(length(ISOs), length(ISOs) ) 
    UnifOff[offPanel, offPanel] .= 1/length(offPanel)

    # Defining uniform measure for on-panel origs
    onPanel = [ISOindex[c] for c in comp]
    UnifOn = zeros(length(ISOs), length(ISOs) )
    UnifOn[onPanel, onPanel] .= length(comp)^-1

    # Constructing SymmetricGroup( panel composition )
    Scomp = S(comp)

    for w in filter(x->x.panelOrigs == Set(comp), waves)
        M = zeros(length(ISOs), length(ISOs))
        n = 0
        for t in Scomp
            if isordered([ w.panel[ tc ] for tc in t ])
                for (c,tc) in zip(comp,t)
                    M[ ISOindex[c] , ISOindex[tc] ] += 1
                end
                n += 1
            end
        end
        if n == 0
            push!(Rm, UnifOn)
            push!(Um, UnifOff + UnifOn) 
        else
            M /= n
            push!(Rm, M)
            push!(RmO, M)
            M += UnifOff
            push!(Um, M)
            push!(UmO, M)
        end
    end
end


using GRUtils
wireframe( length(Um)^-1 * sum(Um) )
wireframe( length(UmO)^-1 * sum(UmO) )

wireframe( length(Rm)^-1 * sum(Rm) )
wireframe( length(RmO)^-1 * sum(RmO) )


draw( gcf( wireframe( length(Um)^-1 * sum(Um),
    xticklabels=String.(ISOs),
    yticklables=String.(ISOs),
    title= "Density with Uniform Measure on All ISOs"
)))


#=
(We will try to follow conventions here https://github.com/invenia/BlueStyle)

put this in
{
    "translate_tabs_to_spaces": true,
    "tab_size": 4,
    "trim_trailing_white_space_on_save": true,
    "ensure_newline_at_eof_on_save": true,
    "rulers": [92]
}

Okay so this may feel weird but I'd like to make an arbitrary function because I do want to emphasize that in some parts of what is hopefully going to be it down below: 
=#

function arb(X...)
    return rand(X...)
end


k = 9
Sk = S(k)
Pk = P(k)

figs = Figure[]

for s in samp
    draw(gcf(wireframe(s)))
end

M = zeros(Int16,n,n)
for s in samp
    M += s
    draw(gcf(wireframe(M)))
end
=#

# Given our sample....

# Perhaps sample is i.i.d. ~ H
# The first momement, E(H^1), is:
#EH1 = n^-1 * sum(samp)

# The second moment, E(H^2), is:
#EH2 = n^-1 * sum(samp.^2)
# centralized second moment
#centEH2 = EH2 - EH1



#=
figs = Figure[]

for d = 0:10:440
  push!(figs, plot(x, y))
end

videofile(figures, "vid.mp4")
=#


