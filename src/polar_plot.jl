"""
    createPolarAxis(f, xlabel, ylabel; yticklabelrotation = π/2,
using Base: throw_boundserror
                xgridstyle = :dot, ygridstyle = :dot, xgridwidth = 0.5, ygridwidth = 0.5,
                xtickalign = 1, ytickalign = 1, xticksize = 3, yticksize = 3, rscale = identity, alignmode = Outside())

Create Axis with beautiful attributes.
"""
function createPolarAxis(f, args...; kwargs...)
    PolarAxis(f, args...; kwargs...)
end

"""
    polarplot(thetas, rs::Vector{yT}, labels; xlabel = L"\text{x_label (x_unit)}",
    ylabel = L"\text{y_label (y_unit)}", size_inches = (7, 7), legendposition = :lt,
    rscale = identity, xlim = nothing, ylim = nothing, showlegend = true, xticks = nothing,
    kwargs...) where {yT <: AbstractVector}

绘制单线或多线图。
"""
function polarplot(thetas, rs::Vector{yT}, labels; xlabel = L"\text{x_label (x_unit)}",
    ylabel = L"\text{y_label (y_unit)}", size_inches = (7, 7), legendposition = :lt,
    rscale = identity, xlim = nothing, ylim = nothing, showlegend = true, xticks = nothing,
    kwargs...) where {yT <: AbstractVector}

    CairoMakie.activate!()
    set_theme!(theme2d)

    size_pt = 72 .* size_inches
    f   =   Figure(size = size_pt)
    ax  =   createPolarAxis(f[1, 1]; kwargs...)
    for i in eachindex(labels)
        lines!(ax, rs[i], thetas, linewidth = 1.5, linestyle = linestyles[i],
                        label = labels[i], color = colormap[i])
    end

    !isnothing(xlim) && xlims!(ax, xlim...)
    !isnothing(ylim) && ylims!(ax, ylim...)
    # showlegend && Legend(f[1, 2], labels)
    # showlegend && axislegend(ax; position = legendposition, patchsize = (20, 6),
    # rowgap = 0, labelsize = 8, backgroundcolor = :transparent,
    #                             framevisible = false, padding = (2., 2., 2., 2.))

    # ax.xticks = isnothing(xticks) ? LinRange(first(thetas), last(thetas), 5) : xticks
    current_figure()

    f

end

"""
    polarplot(rs::Vector{yT}, labels; xlabel = L"\text{x_label (x_unit)}",
    ylabel = L"\text{y_label (y_unit)}", size_inches = (7, 7), legendposition = :lt,
    rscale = identity, xlim = nothing, ylim = nothing, showlegend = true, xticks = nothing,
    kwargs...) where {yT <: AbstractVector}

绘制单线或多线图。
"""
function polarplot(rs::Vector{yT}, labels; xlabel = L"\text{x_label (x_unit)}",
    ylabel = L"\text{y_label (y_unit)}", size_inches = (7, 7), legendposition = :lt,
    rscale = identity, xlim = nothing, ylim = nothing, showlegend = true, xticks = nothing,
    kwargs...) where {yT <: AbstractVector}

    CairoMakie.activate!()
    set_theme!(theme2d)

    size_pt = 72 .* size_inches
    f   =   Figure(size = size_pt)
    ax  =   createPolarAxis(f[1, 1]; kwargs...)
    thetas  =   1:100
    for i in eachindex(labels)
        thetas = 1:length(rs[i])
        lines!(ax, rs[i], thetas, linewidth = 1.5, linestyle = linestyles[i],
                        label = labels[i], color = colormap[i])
    end

    !isnothing(xlim) && xlims!(ax, xlim...)
    !isnothing(ylim) && ylims!(ax, ylim...)
    
    showlegend && Legend(f[1, 2], labels)
    # showlegend && axislegend(ax; position = legendposition, patchsize = (20, 6),
    # rowgap = 0, labelsize = 8, backgroundcolor = :transparent,
    #                             framevisible = false, padding = (2., 2., 2., 2.))

    # ax.xticks = isnothing(xticks) ? LinRange(first(thetas), last(thetas), 5) : xticks
    current_figure()

    f

end


"""
    polarplot(thetas, rs::Vector{yT}, rs_compare::Vector{yT}, labels, labels_compare; compare_step = 6,
    xlabel = L"\text{x_label (x_unit)}", ylabel = L"\text{y_label (y_unit)}",
    size_inches = (7, 7), legendposition = :lt, rscale = identity,
    xlim = nothing, ylim = nothing, showlegend = true, comparestyleoffset = 0,
    xticks = nothing, kwargs...) where {yT <: AbstractVector}

绘制单线或多线 + 散点线比较图。
"""
function polarplot(thetas, rs::Vector{yT}, rs_compare::Vector{yT}, labels, labels_compare; compare_step = 6,
    xlabel = L"\text{x_label (x_unit)}", ylabel = L"\text{y_label (y_unit)}",
    size_inches = (7, 7), legendposition = :lt, rscale = identity,
    xlim = nothing, ylim = nothing, showlegend = true, comparestyleoffset = 0,
    xticks = nothing, spratio = 0.3, kwargs...) where {yT <: AbstractVector}

    CairoMakie.activate!( )
    set_theme!(theme2d)

    size_pt = 72 .* size_inches
    f   =   Figure(size = size_pt)
    ax  =   createPolarAxis(f[1, 1]; kwargs...)
    for i in eachindex(labels)
        lines!(ax, rs[i], thetas, linewidth = 1, linestyle = linestyles[i], label = labels[i], color = colormap[i])
    end
    for i in eachindex(labels_compare)
        j = i+comparestyleoffset
        thetas_new, rs_new = get_uni_thetasrs_sample(thetas, rs_compare[i]; spratio = spratio)
        scatter!(ax, thetas_new, rs_new, marker = markers[j], markersize = 4, label = labels_compare[i], color = colormap[j])
    end

    ax.xticks = isnothing(xticks) ? LinRange(first(thetas), last(thetas), 5) : xticks

    !isnothing(xlim) && xlims!(ax, xlim...)
    !isnothing(ylim) && ylims!(ax, ylim...)

    showlegend && begin
        axislegend(ax; position = legendposition,
        patchsize = (10, 10), rowgap = 0, colgap = 0, labelsize = 9, backgroundcolor = :transparent, nbanks = 1,
        framevisible = false, padding = (0., 0., 0., 0.))
    end
    ax.xticks = isnothing(xticks) ? LinRange(first(thetas), last(thetas), 5) : xticks
    current_figure()

    f

end

"""
    polarplot(rs::Vector{yT}, rs_compare::Vector{yT}, labels, labels_compare; compare_step = 6,
    xlabel = L"\text{x_label (x_unit)}", ylabel = L"\text{y_label (y_unit)}",
    rscale = identity, size_inches = (7, 7), legendposition = :lt,
    xlim = nothing, ylim = nothing, showlegend = true, comparestyleoffset = 0,
    xticks = nothing, kwargs...) where {yT <: AbstractVector}

绘制无x坐标的单线或多线+散点图，一般用于比较不同不同算法得到 ϕ 面上的远场分布绘图。
"""
function polarplot(rs::Vector{yT}, rs_compare::Vector{yT}, labels, labels_compare; compare_step = 6,
    xlabel = L"\text{x_label (x_unit)}", ylabel = L"\text{y_label (y_unit)}",
    rscale = identity, size_inches = (7, 7), legendposition = :lt,
    xlim = nothing, ylim = nothing, showlegend = true, comparestyleoffset = 0,
    xticks = nothing, spratio = 0.3, kwargs...) where {yT <: AbstractVector}

    CairoMakie.activate!()
    set_theme!(theme2d)

    size_pt = 72 .* size_inches
    f   =   Figure(size = size_pt)
    ax  =   createPolarAxis(f[1, 1]; kwargs...)

    thetas = 1:100
    for i in eachindex(labels)
        thetas = 1:length(rs[i])
        lines!(ax, rs[i], thetas, linewidth = 1, linestyle = linestyles[i], label = labels[i], color = colormap[i])
    end
    for i in eachindex(labels_compare)
        thetas = 1:length(rs_compare[i])
        j = comparestyleoffset + i
        thetas_new, rs_new = get_uni_thetasrs_sample(thetas, rs_compare[i]; spratio = spratio)
        scatter!(ax, thetas_new, rs_new, marker = markers[j], markersize = 4, label = labels_compare[i], color = colormap[j])
    end

    ax.xticks = isnothing(xticks) ? LinRange(first(thetas), last(thetas), 5) : xticks

    !isnothing(xlim) && xlims!(ax, xlim...)
    !isnothing(ylim) && ylims!(ax, ylim...)

    tightlimits!(ax)

    showlegend && begin
        axislegend(ax; position = legendposition,
        patchsize = (10, 10), rowgap = 0, colgap = 0, labelsize = 9, backgroundcolor = :transparent, nbanks = 1,
        framevisible = false, padding = (0., 0., 0., 0.))
    end

    current_figure()

    f

end

function polarplot(rs::Matrix, rs_compare::Matrix, labels, labels_compare; args...)
    polarplot(collect(Vector, eachcol(rs)), collect(Vector, eachcol(rs_compare)), labels, labels_compare; args...)
end
function polarplot(thetas, rs::Matrix, rs_compare::Matrix, labels, labels_compare; args...)
    polarplot(thetas, collect(Vector, eachcol(rs)), collect(Vector, eachcol(rs_compare)), labels, labels_compare; args...)
end
function polarplot(rs::Matrix, labels; args...)
    polarplot(collect(Vector, eachcol(rs)), labels; args...)
end
function polarplot(thetas, rs::Matrix, labels; args...)
    polarplot(thetas, collect(Vector, eachcol(rs)), labels; args...)
end

"""
    get_uni_thetasrs_sample(thetas, rs; spratio = 0.2)

Make sx, rs sample more uniform.
"""
function get_uni_thetasrs_sample(thetas, rs; spratio = 0.3)

    !(0 <= spratio <= 1) && throw("spratio must be in 0~1.")

    # get total length
    diffthetas = diff(thetas)
    diffrs = diff(rs)
    ls     = map((x, y) -> sqrt(x^2 + y^2), diffthetas, diffrs)
    lscum  = pushfirst!(cumsum(ls), 0)
    ltotal = lscum[end]

    n_new = ceil(Int, length(rs) * spratio)

    lsample = ltotal/n_new

    thetas_new = zeros(eltype(thetas), n_new)
    rs_new = zeros(eltype(rs), n_new)

    jstart = 1
    for i in 1:n_new
        for j in jstart:length(rs)
            if lscum[j] >= (i-1)*lsample
                thetas_new[i] = thetas[j]
                rs_new[i] = rs[j]
                jstart = j
                break
            end
        end
    end

    return thetas_new, rs_new

end