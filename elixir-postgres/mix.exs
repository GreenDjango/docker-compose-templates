defmodule TimeManagerAPI.MixProject do
  use Mix.Project

  def project do
    [
      # ...
      releases: [
        timemanager: [
          # Ask mix release to build tarball of the release.
          steps: [:assemble, :tar]
        ]
      ]
      # ...
    ]
  end

# ...
