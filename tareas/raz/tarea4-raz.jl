# Tarea 4 - Miguel Raz

# --- Ejercicio 1 ---

import Pkg
Pkg.activate("..")

using GLMakie
N = 500_000
zs = [ComplexF64(2rand()-1, 2rand()-1) for i in 1:N];

function Newton(z_n, f, f′, n)
    for i in 1:n
        z_n -= f(z_n)/f′(z_n)
    end
    z_n
end

f(z) = z^3 - 1
f′(z) = 3z^2

iter_f = Newton.(zs, f, f′, 60)
convs = unique(iter_f)

categorias = indexin(iter_f, convs[1:3])

primeros = zs[categorias .== 1]
segundos = zs[categorias .== 2]
terceros = zs[categorias .== 3]

fig, ax, plt = scatter(Point2.(real.(primeros), imag.(primeros)), label = "", markersize = 1, color = RGBf(0.255,0.412,0.847))
scatter!(ax, Point2.(real.(segundos), imag.(segundos)), label = "", markersize = 1, color = RGBf(0.584, 0.345, 0.698))
scatter!(ax, Point2.(real.(terceros), imag.(terceros)), label = "", markersize = 1, color = RGBf(0.133, 0.596, 0.149))

# --- Ejercicio 2 ---
using GLMakie

p1((x, y)) = (0.0, 0.16y)
p2((x, y)) = (0.85x + 0.04y, -0.04x + 0.85y + 1.6)
p3((x, y)) = (0.2x - 0.26y, 0.23x + 0.22y + 1.6)
p4((x, y)) = (-0.15x + 0.28y, 0.26x + 0.24y + 0.44)

function B(t, ps = [0.01, 0.08, 0.15, 1.0])
    p = rand()
    if p < ps[1]
        p1(t)
    elseif p < ps[2]
        p4(t)
    elseif p < ps[3]
        p3(t)
    elseif p < ps[4]
        p2(t)
    end
end


fig = Figure()
ax = Axis(fig[1,1])

sg = SliderGrid(
    fig[2,1],
    (label = "p1", range = 0.0:.01:1.0, startvalue = .01),
    (label = "p2", range = 0.0:.01:1.0, startvalue = .08),
    (label = "p3", range = 0.0:.01:1.0, startvalue = .15),
    tellheight = true)

n = 200_000
bs = Point2f[(20rand()-10, 20rand()-10) for _ in 1:n]

sliderobservables = [s.value for s in sg.sliders]

obs_bs = lift(sliderobservables...) do p1, p2, p3
    for _ in 1:10
        bs .= Point2f.(B.(bs, Ref((p1, p2, p3, 1.0))))
    end
    bs
end

#for _ in 1:50
#    bs .= B.(bs)
#end

scatter!(obs_bs, label = "", markersize = 4)

limits!(ax, 0, 2, 0, 2)

fig

