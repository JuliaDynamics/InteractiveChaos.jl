using Agents, Random
using GLMakie
using InteractiveChaos

model, agent_step!, model_step! = Models.social_distancing(isolated = 0.8)

# Various possibilities for colors/sizes/markers
sir_colors(a) = a.status == :S ? "#2b2b33" : a.status == :I ? "#bf2642" : "#338c54"
# sir_sizes(a) = 10*randn()
# sir_sizes(a) = 5*(mod1(a.id, 3)+1)
sir_sizes = 10

# sir_shape(a) = rand(('🐑', '🐺', '🌳'))
# sir_shape(a) = rand(('😹', '🐺', '🌳'))
# sir_shape(a) = rand(('π', '😹', '⚃', '◑', '▼'))
# sir_shape(a) = rand((:diamond, :circle))
sir_shape(a) = a.status == :S ? :circle : a.status == :I ? :diamond : :rect

# function sir_shape(b)
#     φ = atan(b.vel[2], b.vel[1])
#     xs = [(i ∈ (0, 3) ? 2 : 1)*cos(i*2π/3 + φ) for i in 0:3]
#     ys = [(i ∈ (0, 3) ? 2 : 1)*sin(i*2π/3 + φ) for i in 0:3]
#     poly(xs, ys)
# end

fig = abm_plot(model;
    ac = sir_colors, as = sir_sizes, am = sir_shape,
)

# %% same, but interactive
fig = abm_play(model, agent_step!, model_step!;
    ac = sir_colors, as = sir_sizes, am = sir_shape,
)

# %% same, but video
fig = abm_video("socialdist.mp4", model, agent_step!, model_step!;
    ac = sir_colors, as = sir_sizes, am = sir_shape,
    spf = 2, frames = 100,
)

# %% Interactive data plot
model, agent_step!, model_step! = Models.social_distancing(isolated = 0.8)

infected(x) = count(i == :I for i in x)
recovered(x) = count(i == :R for i in x)
adata = [(:status, infected), (:status, recovered)]
alabels = ["I", "R"]
mdata = [nagents]
mlabels = ["N"]

params = Dict(
    :death_rate => 0.02:0.001:1.0,
    :reinfection_probability => 0:0.01:1.0,
    :infection_period => 24:24:2400,
)

when = (model, s) -> s % 50 == 0

fig, adf, mdf = abm_data_exploration(model, agent_step!, model_step!, params;
ac = sir_colors, as = sir_sizes, am = sir_shape,
when = when, mdata = mdata, adata=adata, alabels=alabels, mlabels=mlabels)
