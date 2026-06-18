using TestItems
using TestItemRunner

@run_package_tests

@testsnippet Setup begin
  using GeoTables
  using Meshes
  using CoordRefSystems
  using Distributions
  using Unitful
  using Colors
  using ReferenceTests
  using StableRNGs
  using Random

  import CairoMakie as Mke

  datadir = joinpath(@__DIR__, "data")
end

@testitem "viewer" setup = [Setup] begin
  grid = CartesianGrid(10, 10)

  rng = StableRNG(123)

  # continuous variables
  a = rand(rng, 100)
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "viewer-continuous.png") viewer(gtb)

  # categorical variables
  a = rand(rng, 1:5, 100)
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "viewer-categorical-1.png") viewer(gtb)
  a = rand(rng, ["yes", "no"], 100)
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "viewer-categorical-2.png") viewer(gtb)

  # distributional variables
  a = Normal.(rand(rng, 100), rand(rng, 100))
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "viewer-distributional.png") viewer(gtb)

  # colors
  a = Gray.(rand(rng, 100))
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "viewer-colors.png") viewer(gtb)

  # constant columns
  # continuous
  a = fill(1.0, 100)
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "viewer-const-continuous.png") viewer(gtb)
  # categorical
  a = fill("test", 100)
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "viewer-const-categorical.png") viewer(gtb)
  # distributional
  a = fill(Normal(), 100)
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "viewer-const-distributional.png") viewer(gtb)
  # color
  a = fill(Gray(0.1), 100)
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "viewer-const-color.png") viewer(gtb)

  # missing values
  missings = fill(missing, 20)
  # continuous with missing
  a = shuffle(rng, [missings; rand(rng, 80)])
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "viewer-missing-continuous-1.png") viewer(gtb)
  # continuous with NaN
  a = shuffle(rng, [fill(NaN, 20); rand(rng, 80)])
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "viewer-missing-continuous-2.png") viewer(gtb)
  # continuous with missing and NaN
  a = shuffle(rng, [fill(missing, 10); fill(NaN, 10); rand(rng, 80)])
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "viewer-missing-continuous-3.png") viewer(gtb)
  # categorical
  a = shuffle(rng, [missings; rand(rng, 'a':'e', 80)])
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "viewer-missing-categorical.png") viewer(gtb)
  # distributional
  a = shuffle(rng, [missings; Normal.(rand(rng, 80), rand(rng, 80))])
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "viewer-missing-distributional.png") viewer(gtb)
  # colors
  a = shuffle(rng, [missings; RGB.(rand(rng, 80), rand(rng, 80), rand(rng, 80))])
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "viewer-missing-colors.png") viewer(gtb)

  # units
  # continuous
  a = rand(rng, 100) * u"m/s"
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "viewer-unit-continuous.png") viewer(gtb)
  # categorical
  a = rand(rng, 1:5, 100) * u"°C"
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "viewer-unit-categorical.png") viewer(gtb)
  # continuous with missing
  a = shuffle(rng, [missings; rand(rng, 80)]) * u"m/s"
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "viewer-unit-missing-continuous.png") viewer(gtb)
  # categorical with missing
  a = shuffle(rng, [missings; rand(rng, 1:5, 80)]) * u"°C"
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "viewer-unit-missing-categorical.png") viewer(gtb)
end
