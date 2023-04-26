
"""
    farfield2D(xs, ys, labels; xlabel = "θ(°) (ϕ = 90°)", ylabel = "dB",
    size_inches = (3.5, 2.4), legendposition = :lt, 
    xlim = nothing, ylim = nothing, showlegend = true)
    
    绘制单线或多线图，一般用于不同 ϕ 面上的远场分布绘图

"""
function farfield2D(xs, ys, labels; xlabel = L"\theta(^{\circ})", 
    ylabel = "dB", size_inches = (3.5, 2.4), legendposition = :lt, 
    xlim = nothing, ylim = nothing, showlegend = true, x_unit = :rad)

    CairoMakie.activate!( )

    xs_used = if x_unit == :rad
        xs .* (180 / π)
    elseif x_unit == :deg
        xs
    end

    set_theme!(theme2d)

    size_pt = 72 .* size_inches
    f   =   Figure(resolution = size_pt)
    ax  =   Axis(f[1, 1], xlabel = xlabel, ylabel = ylabel, yticklabelrotation = π/2,
                    xgridstyle = :dot, ygridstyle = :dot, xgridwidth = 0.5, ygridwidth = 0.5, 
                    xtickalign = 1, ytickalign = 1, xticksize = 3, yticksize = 3)
    for i in eachindex(labels)
        lines!(ax, xs_used, ys[:, i], linewidth = 1.5, linestyle = linestyles[i],
                        label = labels[i], color = colormap[i])
    end

    !isnothing(xlim) && xlims!(ax, xlim...)
    !isnothing(ylim) && ylims!(ax, ylim...)

    showlegend && axislegend(ax; position = legendposition, patchsize = (20, 6), 
                                rowgap = 0, labelsize = 8, bgcolor = :transparent, 
                                framevisible = false, padding = (2., 2., 2., 2.))

    ax.xticks = LinRange(first(xs_used), last(xs_used), 5)
    current_figure()

    f

end


"""
    farfield2D(xs, ys, ys_compare, labels, labels_compare; compare_step = 6, 
    xlabel = L"θ(deg)" ) (ϕ = bla(deg))", ylabel = "dBsm", size_inches = (3.5, 2.4), legendposition = :lt, 
    xlim = nothing, ylim = nothing, showlegend = true)

    绘制单线或多线+散点图，一般用于比较不同不同算法得到 ϕ 面上的远场分布绘图

TBW
"""
function farfield2D(xs, ys, ys_compare, labels, labels_compare; compare_step = 6, 
    xlabel = L"\theta(^{\circ}) (\phi = 0^{\circ})", ylabel = L"\text{RCS(dBsm)}", size_inches = (3.5, 2.4), legendposition = :lt, 
    xlim = nothing, ylim = nothing, showlegend = true, comparestyleoffset = 0, x_unit = :rad)

    CairoMakie.activate!( )

    xs_used = if x_unit == :rad
        xs .* (180 / π)
    elseif x_unit == :deg
        xs
    end
    set_theme!(theme2d)

    size_pt = 72 .* size_inches
    f   =   Figure(resolution = size_pt)
    ax  =   Axis(f[1, 1], xlabel = xlabel, ylabel = ylabel, yticklabelrotation = π/2,
                    xgridstyle = :dot, ygridstyle = :dot, xgridwidth = 0.5, ygridwidth = 0.5, 
                    xtickalign = 1, ytickalign = 1, xticksize = 3, yticksize = 3)
    for i in eachindex(labels)
        lines!(ax, xs_used, ys[:, i], linewidth = 1, linestyle = linestyles[i], label = labels[i], color = colormap[i])
    end
    for i in eachindex(labels)
        j = i+comparestyleoffset
        scatter!(ax, xs_used[1:compare_step:end], ys_compare[1:compare_step:end, i], marker = markers[j], markersize = 4, label = labels_compare[i], color = colormap[j])
    end

    ax.xticks = LinRange(first(xs), last(xs), 5)

    !isnothing(xlim) && xlims!(ax, xlim...)
    !isnothing(ylim) && ylims!(ax, ylim...)

    showlegend && begin
        # legend = Legend(f, ax; #position = legendposition, 
        #         patchsize = (10, 10), rowgap = 0, labelsize = 5, bgcolor = :transparent, nbanks = 2, 
        #         orientation = :horizontal, framevisible = false, padding = (0., 0., 0., 0.))#orientation = :horizontal, 
        # f[2, 1] = legend
        axislegend(ax; position = legendposition, 
        patchsize = (10, 10), rowgap = 0, colgap = 0, labelsize = 9, bgcolor = :transparent, nbanks = 1, 
        framevisible = false, padding = (0., 0., 0., 0.))
    end
    ax.xticks = LinRange(first(xs_used), last(xs_used), 5)
    current_figure()

    f

end

"""
    farfield2D(xs, ys, ys_compare, labels, labels_compare; compare_step = 6, 
    xlabel = L"θ(deg)" ) (ϕ = bla(deg))", ylabel = "dBsm", size_inches = (3.5, 2.4), legendposition = :lt, 
    xlim = nothing, ylim = nothing, showlegend = true)

    绘制无x坐标的单线或多线+散点图，一般用于比较不同不同算法得到 ϕ 面上的远场分布绘图

TBW
"""
function farfield2D(ys, ys_compare, labels, labels_compare; compare_step = 6, 
    xlabel = L"\theta(^{\circ}) (\phi = 0^{\circ})", ylabel = "dBsm", yscale = identity, size_inches = (3.5, 2.4), legendposition = :lt, 
    xlim = nothing, ylim = nothing, showlegend = true, comparestyleoffset = 0)
    CairoMakie.activate!()

    set_theme!(theme2d)

    size_pt = 72 .* size_inches
    f   =   Figure(resolution = size_pt)
    ax  =   Axis(f[1, 1], xlabel = xlabel, ylabel = ylabel, yticklabelrotation = π/2,
                    xgridstyle = :dot, ygridstyle = :dot, xgridwidth = 0.5, ygridwidth = 0.5, 
                    xtickalign = 1, ytickalign = 1, xticksize = 3, yticksize = 3, yscale = yscale, alignmode = Outside())

    xs = 1:100
    for i in eachindex(labels)
        xs = 1:length(ys[i])
        lines!(ax, xs, ys[i], linewidth = 1, linestyle = linestyles[i], label = labels[i], color = colormap[i])
    end
    for i in eachindex(labels_compare)
        xs = 1:length(ys_compare[i])
        j = comparestyleoffset + i
        scatter!(ax, xs[1:compare_step:end], ys_compare[i][1:compare_step:end], marker = markers[j], markersize = 4, label = labels_compare[i], color = colormap[j])
    end

    ax.xticks = LinRange(first(xs), last(xs), 5)

    !isnothing(xlim) && xlims!(ax, xlim...)
    !isnothing(ylim) && ylims!(ax, ylim...)

    tightlimits!(ax)

    showlegend && begin
        # legend = Legend(f, ax; #position = legendposition, 
        #         patchsize = (10, 10), rowgap = 0, labelsize = 5, bgcolor = :transparent, nbanks = 2, 
        #         orientation = :horizontal, framevisible = false, padding = (0., 0., 0., 0.))#orientation = :horizontal, 
        # f[2, 1] = legend
        axislegend(ax; position = legendposition, 
        patchsize = (10, 10), rowgap = 0, colgap = 0, labelsize = 9, bgcolor = :transparent, nbanks = 1, 
        framevisible = false, padding = (0., 0., 0., 0.))
    end
    
    current_figure()

    f

end

function farfield2D(ys::Matrix, ys_compare::Matrix, labels, labels_compare; args...)

    farfield2D(collect(eachcol(ys)), collect(eachcol(ys_compare)), labels, labels_compare; args...)

end

"""
    farfield3D(θs, ϕs, data; xlabel = "θ(°) (ϕ = 90°)", ylabel = "dB", size_inches = (3.5, 2.4), legendposition = :lt, 
    xlim = nothing, ylim = nothing, showlegend = true)

    
    绘制单线或多线图，一般用于不同 ϕ 面上的远场分布绘图

"""
function farfield3D(θs, ϕs, data; size_inches = (3.5, 2.4), label = "RCS(dB)",
    xlim = nothing, ylim = nothing, zlim = nothing, showlegend = true, dpi = 600, cmap = colormap3d)
    
    GLMakie.activate!()

    # xyz网格坐标
    x = [sin(θ) * sin(ϕ) for θ in θs, ϕ in ϕs]
    y = [sin(θ) * cos(ϕ) for θ in θs, ϕ in ϕs]
    z = [cos(θ) for θ in θs, _ in ϕs]

    #
    size_in_pixels = size_inches .* dpi
    fig = Figure(resolution = size_in_pixels, fontsize = 3.2/25.4*dpi, theme = theme_light())
    axs = Axis3(fig[1, 1], aspect = :data)

    pltobj = surface!(axs, data .* x, data .* y, data .* z; color = data, colormap = cmap, 
                        lightposition = CairoMakie.Vec3f(0, 0, 0), ambient = CairoMakie.Vec3f(0.65, 0.65, 0.65),
                        backlight = 5.0f0, shading = true)
    Colorbar(fig[1, 2], pltobj, label = label, tickwidth = 2, tickalign = 1, width = 25, ticksize = 3.2/25.4*dpi, height = Relative(0.5))

    hidedecorations!(axs)

    current_figure()

    fig

end
