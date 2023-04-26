

"""
    plot_sphere_with_nodes(;nodes = nothing, resultDir = "results", filename = "sphere")

    画出点在球面上的分布
TBW
"""
function plot_sphere_with_nodes(;nodes = nothing, colorid = 1, resultDir = "results", filename = "sphere")
    GLMakie.activate!()
    # 单位球面
    sphere = Sphere(Point3f(0), 0.999)

    # 作图参数
    size_in_inches = (4, 3)
    dpi = 600
    size_in_pixels = size_in_inches .* dpi

    # 画板
    fig = Figure(resolution = size_in_pixels, fontsize = 3.2/25.4*dpi, theme = theme_light())
    # 轴图
    ax  = Axis3(fig[1, 1], aspect = :data, )

    # 球面
    mesh!(ax, sphere, color = :gold)
    # 散点
    !isnothing(nodes) && scatter!(ax, eachrow(nodes)...; color = colormap[colorid], markersize = 1/25.4*dpi)
    # 隐藏轴、坐标、网格等
    hidedecorations!(ax; grid = true)

    # 保存后返回
    save(joinpath(resultDir, filename*".png"), fig)
    return fig

end


"""
    plot_sphere_with_nodes(;nodes = nothing, resultDir = "results", filename = "sphere")

    画出点在球面上的分布
TBW
"""
function plot_sphere_with_nodes(nodes::Vararg{AbstractMatrix, N}; colorid = 1, marker = markers,  resultDir = "results", filename = "sphere") where N
    GLMakie.activate!()
    # 单位球面
    sphere = Sphere(Point3f(0), 0.999)

    # 作图参数
    size_in_inches = (4, 3)
    dpi = 600
    size_in_pixels = size_in_inches .* dpi

    # 画板
    fig = Figure(resolution = size_in_pixels, fontsize = 3.2/25.4*dpi, theme = theme_light())
    # 轴图
    ax  = Axis3(fig[1, 1], aspect = :data, )

    # 球面
    mesh!(ax, sphere, color = :gold)
    # 散点
    for i in 1:N
        scatter!(ax, eachrow(nodes[i])...; color = colormap[colorid[i]], marker = marker[i], markersize = 2/25.4*dpi)
    end
    # 隐藏轴、坐标、网格等
    hidedecorations!(ax)

    # 保存后返回
    save(joinpath(resultDir, filename*".png"), fig)
    return fig

end


"""
    plot_sphere_with_nodes(;nodes = nothing, resultDir = "results", filename = "sphere")

    画出点在球面上的分布
TBW
"""
function plot_sphere_with_nodes!(fig; axloc = [1, 1], nodes = nothing, colorid = 2, marker = :star4, 
    dpi = 600, resultDir = "results", filename = "sphere")

    # 散点
    !isnothing(nodes) && scatter!(fig[axloc...], eachrow(nodes)...; color = colormap[colorid], marker = marker, markersize = 1/25.4*dpi)

    # 保存后返回
    save(joinpath(resultDir, filename*".png"), fig)
    return fig

end

function viz_data_in_thetaphi_plane(ϕθnodes::Vararg{AbstractMatrix, N}; labels =  repeat(["球面高斯求积点",], inner = N), fontsize = 10,
    xlabel = L"\phi", ylabel = L"\theta", size_inches = (4, 3), xlim = (0, 2π), ylim = (π, 0),
    resultDir = "results", filename = "θϕnodes", title = "title") where {N}

    CairoMakie.activate!( type = "pdf")

    # 作图参数
    size_pt     =   72 .* size_inches
    markers = [:circle, :star4, :diamond, :rtriangle, :rect, :pentagon, :cross, :star5]
    colormap    =  colorschemes[:Set1_9][[2, 5, 4, 9, 1, 8, 3, 6, 7]]

    # 画板
    fig =   Figure(resolution = size_pt, fontsize = fontsize)
    ax  =   CairoMakie.Axis(fig[1, 1], xlabel = xlabel, ylabel = ylabel, yticklabelrotation = π/2,
                    xgridstyle = :dot, ygridstyle = :dot, xgridwidth = 0.5, ygridwidth = 0.5, 
                    xtickalign = 1, ytickalign = 1, xticksize = 3, yticksize = 3, title = title, #xaxisposition = :top,
                    xticks = (0:0.5π:2π, [L"%$(i)\pi" for i in 0:0.5:2]), yticks = (0:0.5π:π, [L"%$(i)\pi" for i in 0:0.5:1]))#MultiplesTicks(3, pi, "π")
    # 绘图
    for i in 1:N
        scatter!(ax, eachrow(ϕθnodes[i])..., marker = markers[i], markersize = 5, label = labels[i], color = colormap[i+1])
    end

    # 调整绘图范围
    !isnothing(xlim) && ylims!(ax, xlim...)
    !isnothing(ylim) && ylims!(ax, ylim...)

    # 保存后返回
    save(joinpath(resultDir, filename*".pdf"), fig)
    save(joinpath(resultDir, filename*".png"), fig)
    return fig

end

function clip_imag(targetdir, filenames, window, savedir)

    for filename in filenames
        @info filename
        img = load(joinpath(targetdir, filename))
        img_new = img[window...]
        save(joinpath(savedir, filename), img_new)
    end

    nothing

end
