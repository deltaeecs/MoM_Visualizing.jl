"""
    createAxis(f, xlabel, ylabel; yticklabelrotation = π/2,
using Base: throw_boundserror
                xgridstyle = :dot, ygridstyle = :dot, xgridwidth = 0.5, ygridwidth = 0.5,
                xtickalign = 1, ytickalign = 1, xticksize = 3, yticksize = 3, yscale = identity, alignmode = Outside())

Create Axis with beautiful attributes.
"""
function createAxis(f, xlabel, ylabel; yticklabelrotation = π/2,
    xgridstyle = :dot, ygridstyle = :dot, xgridwidth = 0.5, ygridwidth = 0.5,
    xtickalign = 1, ytickalign = 1, xticksize = 3, yticksize = 3, yscale = identity, alignmode = Outside())

    Axis(f, xlabel = xlabel, ylabel = ylabel, yticklabelrotation = yticklabelrotation,
            xgridstyle = xgridstyle, ygridstyle = ygridstyle, xgridwidth = xgridwidth, ygridwidth = ygridwidth,
            xtickalign = xtickalign, ytickalign = ytickalign, xticksize = xticksize, yticksize = yticksize,
            yscale = yscale, alignmode = alignmode)
end

"""
    linesplot(xs, ys::Vector{yT}, labels; xlabel = L"\text{x_label (x_unit)}",
    ylabel = L"\text{y_label (y_unit)}", size_inches = (3.5, 2.4), legendposition = :lt,
    yscale = identity, xlim = nothing, ylim = nothing, showlegend = true, xticks = nothing,
    kwargs...) where {yT <: AbstractVector}

绘制单线或多线图。
"""
function linesplot(xs, ys::Vector{yT}, labels; xlabel = L"\text{x_label (x_unit)}",
    ylabel = L"\text{y_label (y_unit)}", size_inches = (3.5, 2.4), legendposition = :lt,
    yscale = identity, xlim = nothing, ylim = nothing, showlegend = true, xticks = nothing,
    kwargs...) where {yT <: AbstractVector}

    CairoMakie.activate!()
    set_theme!(theme2d)

    size_pt = 72 .* size_inches
    f   =   Figure(resolution = size_pt)
    ax  =   createAxis(f[1, 1], xlabel, ylabel; yscale = yscale)
    for i in eachindex(labels)
        lines!(ax, xs, ys[i], linewidth = 1.5, linestyle = linestyles[i],
                        label = labels[i], color = colormap[i])
    end

    !isnothing(xlim) && xlims!(ax, xlim...)
    !isnothing(ylim) && ylims!(ax, ylim...)

    showlegend && axislegend(ax; position = legendposition, patchsize = (20, 6),
    rowgap = 0, labelsize = 8, bgcolor = :transparent,
                                framevisible = false, padding = (2., 2., 2., 2.))

    ax.xticks = isnothing(xticks) ? LinRange(first(xs), last(xs), 5) : xticks
    current_figure()

    f

end

"""
    linesplot(ys::Vector{yT}, labels; xlabel = L"\text{x_label (x_unit)}",
    ylabel = L"\text{y_label (y_unit)}", size_inches = (3.5, 2.4), legendposition = :lt,
    yscale = identity, xlim = nothing, ylim = nothing, showlegend = true, xticks = nothing,
    kwargs...) where {yT <: AbstractVector}

绘制单线或多线图。
"""
function linesplot(ys::Vector{yT}, labels; xlabel = L"\text{x_label (x_unit)}",
    ylabel = L"\text{y_label (y_unit)}", size_inches = (3.5, 2.4), legendposition = :lt,
    yscale = identity, xlim = nothing, ylim = nothing, showlegend = true, xticks = nothing,
    kwargs...) where {yT <: AbstractVector}

    CairoMakie.activate!()
    set_theme!(theme2d)

    size_pt = 72 .* size_inches
    f   =   Figure(resolution = size_pt)
    ax  =   createAxis(f[1, 1], xlabel, ylabel; yscale = yscale)
    xs  =   1:100
    for i in eachindex(labels)
        xs = 1:length(ys[i])
        lines!(ax, xs, ys[i], linewidth = 1.5, linestyle = linestyles[i],
                        label = labels[i], color = colormap[i])
    end

    !isnothing(xlim) && xlims!(ax, xlim...)
    !isnothing(ylim) && ylims!(ax, ylim...)

    showlegend && axislegend(ax; position = legendposition, patchsize = (20, 6),
    rowgap = 0, labelsize = 8, bgcolor = :transparent,
                                framevisible = false, padding = (2., 2., 2., 2.))

    ax.xticks = isnothing(xticks) ? LinRange(first(xs), last(xs), 5) : xticks
    current_figure()

    f

end


"""
    linesplot(xs, ys::Vector{yT}, ys_compare::Vector{yT}, labels, labels_compare; compare_step = 6,
    xlabel = L"\text{x_label (x_unit)}", ylabel = L"\text{y_label (y_unit)}",
    size_inches = (3.5, 2.4), legendposition = :lt, yscale = identity,
    xlim = nothing, ylim = nothing, showlegend = true, comparestyleoffset = 0,
    xticks = nothing, kwargs...) where {yT <: AbstractVector}

绘制单线或多线 + 散点线比较图。
"""
function linesplot(xs, ys::Vector{yT}, ys_compare::Vector{yT}, labels, labels_compare; compare_step = 6,
    xlabel = L"\text{x_label (x_unit)}", ylabel = L"\text{y_label (y_unit)}",
    size_inches = (3.5, 2.4), legendposition = :lt, yscale = identity,
    xlim = nothing, ylim = nothing, showlegend = true, comparestyleoffset = 0,
    xticks = nothing, spratio = 0.3, kwargs...) where {yT <: AbstractVector}

    CairoMakie.activate!( )
    set_theme!(theme2d)

    size_pt = 72 .* size_inches
    f   =   Figure(resolution = size_pt)
    ax  =   createAxis(f[1, 1], xlabel, ylabel; yscale = yscale)
    for i in eachindex(labels)
        lines!(ax, xs, ys[i], linewidth = 1, linestyle = linestyles[i], label = labels[i], color = colormap[i])
    end
    for i in eachindex(labels)
        j = i+comparestyleoffset
        xs_new, ys_new = get_uni_xsys_sample(xs, ys_compare[i]; spratio = spratio)
        scatter!(ax, xs_new, ys_new, marker = markers[j], markersize = 4, label = labels_compare[i], color = colormap[j])
    end

    ax.xticks = isnothing(xticks) ? LinRange(first(xs), last(xs), 5) : xticks

    !isnothing(xlim) && xlims!(ax, xlim...)
    !isnothing(ylim) && ylims!(ax, ylim...)

    showlegend && begin
        axislegend(ax; position = legendposition,
        patchsize = (10, 10), rowgap = 0, colgap = 0, labelsize = 9, bgcolor = :transparent, nbanks = 1,
        framevisible = false, padding = (0., 0., 0., 0.))
    end
    ax.xticks = isnothing(xticks) ? LinRange(first(xs), last(xs), 5) : xticks
    current_figure()

    f

end

"""
    linesplot(ys::Vector{yT}, ys_compare::Vector{yT}, labels, labels_compare; compare_step = 6,
    xlabel = L"\text{x_label (x_unit)}", ylabel = L"\text{y_label (y_unit)}",
    yscale = identity, size_inches = (3.5, 2.4), legendposition = :lt,
    xlim = nothing, ylim = nothing, showlegend = true, comparestyleoffset = 0,
    xticks = nothing, kwargs...) where {yT <: AbstractVector}

绘制无x坐标的单线或多线+散点图，一般用于比较不同不同算法得到 ϕ 面上的远场分布绘图。
"""
function linesplot(ys::Vector{yT}, ys_compare::Vector{yT}, labels, labels_compare; compare_step = 6,
    xlabel = L"\text{x_label (x_unit)}", ylabel = L"\text{y_label (y_unit)}",
    yscale = identity, size_inches = (3.5, 2.4), legendposition = :lt,
    xlim = nothing, ylim = nothing, showlegend = true, comparestyleoffset = 0,
    xticks = nothing, spratio = 0.3, kwargs...) where {yT <: AbstractVector}

    CairoMakie.activate!()
    set_theme!(theme2d)

    size_pt = 72 .* size_inches
    f   =   Figure(resolution = size_pt)
    ax  =   createAxis(f[1, 1], xlabel, ylabel; yscale = yscale)

    xs = 1:100
    for i in eachindex(labels)
        xs = 1:length(ys[i])
        lines!(ax, xs, ys[i], linewidth = 1, linestyle = linestyles[i], label = labels[i], color = colormap[i])
    end
    for i in eachindex(labels_compare)
        xs = 1:length(ys_compare[i])
        j = comparestyleoffset + i
        xs_new, ys_new = get_uni_xsys_sample(xs, ys_compare[i]; spratio = spratio)
        scatter!(ax, xs_new, ys_new, marker = markers[j], markersize = 4, label = labels_compare[i], color = colormap[j])
    end

    ax.xticks = isnothing(xticks) ? LinRange(first(xs), last(xs), 5) : xticks

    !isnothing(xlim) && xlims!(ax, xlim...)
    !isnothing(ylim) && ylims!(ax, ylim...)

    tightlimits!(ax)

    showlegend && begin
        axislegend(ax; position = legendposition,
        patchsize = (10, 10), rowgap = 0, colgap = 0, labelsize = 9, bgcolor = :transparent, nbanks = 1,
        framevisible = false, padding = (0., 0., 0., 0.))
    end

    current_figure()

    f

end

function linesplot(ys::Matrix, ys_compare::Matrix, labels, labels_compare; args...)
    linesplot(collect(Vector, eachcol(ys)), collect(Vector, eachcol(ys_compare)), labels, labels_compare; args...)
end
function linesplot(xs, ys::Matrix, ys_compare::Matrix, labels, labels_compare; args...)
    linesplot(xs, collect(Vector, eachcol(ys)), collect(Vector, eachcol(ys_compare)), labels, labels_compare; args...)
end
function linesplot(ys::Matrix, labels; args...)
    linesplot(collect(Vector, eachcol(ys)), labels; args...)
end
function linesplot(xs, ys::Matrix, labels; args...)
    linesplot(xs, collect(Vector, eachcol(ys)), labels; args...)
end

"""
    get_uni_xsys_sample(xs, ys; spratio = 0.2)

Make sx, ys sample more uniform.
"""
function get_uni_xsys_sample(xs, ys; spratio = 0.3)

    !(0 <= spratio <= 1) && throw("spratio must be in 0~1.")

    # get total length
    diffxs = diff(xs)
    diffys = diff(ys)
    ls     = map((x, y) -> sqrt(x^2 + y^2), diffxs, diffys)
    lscum  = pushfirst!(cumsum(ls), 0)
    ltotal = lscum[end]

    n_new = ceil(Int, length(ys) * spratio)

    lsample = ltotal/n_new

    xs_new = zeros(eltype(xs), n_new)
    ys_new = zeros(eltype(ys), n_new)

    jstart = 1
    for i in 1:n_new
        for j in jstart:length(ys)
            if lscum[j] >= (i-1)*lsample
                xs_new[i] = xs[j]
                ys_new[i] = ys[j]
                jstart = j
                break
            end
        end
    end

    return xs_new, ys_new

end