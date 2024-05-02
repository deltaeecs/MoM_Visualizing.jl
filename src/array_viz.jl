using ColorSchemes:grayC
function plotSparseArrayPattern(spa; size_inches = (4, 3), resultDir = "results", filename = "saprsepattern", title = "title")
    CairoMakie.activate!( type = "pdf")

    # 作图参数
    size_pt     =   72 .* size_inches

    # 画板
    fig =   Figure(size = size_pt)
    # 轴
    ax  =    CairoMakie.Axis(fig[1, 1])#, title = title
    heatmap!(ax, spa; colormap = :grayC)
    # 隐藏轴、坐标、网格等
    hidedecorations!(ax)
    # 保存后返回
    save(joinpath(resultDir, filename*".pdf"), fig)
    save(joinpath(resultDir, filename*".png"), fig)

    fig
end