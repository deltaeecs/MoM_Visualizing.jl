module MoM_Visualizing

using MoM_Basics
using LaTeXStrings
using Meshes, MeshViz
using CairoMakie, GLMakie, ElectronDisplay
using Colors, ColorSchemes

export  plotSource,
        farfield2D,
        farfield3D,
        convergencePlot,
        plot_sphere_with_nodes,
        plot_sphere_with_nodes!,
        viz_data_in_thetaphi_plane,
        clip_imag,
        plotSparseArrayPattern

theme2d     =   Theme(font = "Times New Roman Bold", fontsize = 8.5, figure_padding = (5, 10, 5, 10))
linestyles  =   [:solid, :dashdotdot, :dash, :dot, :dashdot]
markers     =   [:circle, :star4, :diamond, :rtriangle, :rect, :pentagon, :cross, :star5]
colormap    =   colorschemes[:Set1_9][[2, 5, 4, 9, 1, 8, 3, 6, 7]]
colormap3d  =   ColorScheme(vcat(range(colorant"blue", colorant"gold", length=50), range(colorant"gold", colorant"red", length=50)))

# 源绘图
include("Sources.jl")

# 远场绘图
include("far_field_viz.jl")

# 网格绘图
include("mesh_viz.jl")

# lebedev矢量插值相关
include("lebedev_viz.jl")

end
