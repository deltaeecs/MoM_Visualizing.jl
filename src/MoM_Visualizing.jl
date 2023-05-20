module MoM_Visualizing

using GLMakie: draw_fullscreen
using MoM_Basics
using LaTeXStrings, CircularArrays
using Meshes, MeshViz
using CairoMakie, GLMakie
using Colors, ColorSchemes

export  plotSource,
        linesplot,
        farfield2D,
        farfield3D,
        convergence_plot,
        plot_sphere_with_nodes,
        plot_sphere_with_nodes!,
        viz_data_in_thetaphi_plane,
        clip_imag,
        plotSparseArrayPattern

theme2d     =   Theme(font = "Times New Roman Bold", fontsize = 8.5, figure_padding = (5, 10, 5, 10))
linestyles  =   CircularVector([:solid, :dashdotdot, :dash, :dot, :dashdot])
markers     =   CircularVector([:circle, :star4, :diamond, :rtriangle, :rect, :pentagon, :cross, :star5])
colormap    =   CircularVector(colorschemes[:Set1_9][[2, 5, 4, 9, 1, 8, 3, 6, 7]])
colormap3d  =   ColorScheme(vcat(range(colorant"blue", colorant"gold", length=50), range(colorant"gold", colorant"red", length=50)))
theme3d     =   Theme(font = "Times New Roman Bold", fontsize = 8.5, figure_padding = (5, 10, 5, 10), 
                        draw_fullscreen=true, float=true, oit=true)

# 点线绘图模板
include("lines_plot.jl")

# 源绘图
include("Sources.jl")

# 远场绘图
include("far_field_viz.jl")

# 求解相关
include("Solvers.jl")

# 网格绘图
include("mesh_viz.jl")

# lebedev矢量插值相关
include("lebedev_viz.jl")

end
