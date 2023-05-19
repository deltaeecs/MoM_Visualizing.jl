using IterativeSolvers:ConvergenceHistory

"""
    convergence_plot(ch::ConvergenceHistory, labels=CircularVector([""]); xlabel = L"\text{Epoch}", 
                    ylabel = "ϵ", showlegend = false, kwargs...)
绘制单线或多线收敛图。
"""
function convergence_plot(ch::ConvergenceHistory, labels=CircularVector([""]); xlabel = L"\text{Epoch}", 
                            ylabel = "ϵ", yscale = log10, showlegend = false, legendposition = :rt, kwargs...)
    xticks = 1:(length(ch.data[:resnorm]) ÷ 5):length(ch.data[:resnorm])
    linesplot([ch.data[:resnorm] ./ ch.data[:resnorm][1]], labels; xlabel = xlabel, ylabel = ylabel,
                yscale = yscale, showlegend = showlegend, legendposition = legendposition, xticks = xticks, kwargs...)

end