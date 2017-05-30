# Kuhn-Munkres in Rust as a Ruby gem

This is a wrapper of https://github.com/mneumann/munkres-rs for Ruby.

## Usage

Add to your Gemfile

```
gem 'munkres_ru'
```

Then you can do:

```
problem = [
  [1.0, 1.0, 1.0, 1.0, 1.0],
  [1.0, 1.0, 1.0, 1.0, 1.0],
  [1.0, 1.0, 1.0, 1.0, 1.0],
  [0.0, 0.0, 0.0, 0.0, 0.0],
  [0.0, 0.0, 0.0, 0.0, 0.0]
]
solution = MunkresRu.solve(problem)

# => [[0, 0], [1, 1], [2, 2], [3, 3], [4, 4]]
```

Note: only square matrixes are handled.

## Building

Install Rust and Cargo; then run

```
$ rake compile
$ rake spec
```

Build the Ruby gem with

```
$ rake build
```
