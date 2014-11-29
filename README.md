# Dragonfly Harfbuzz

[Harfbuzz](http://fontforge.github.io) renderer wrapped by [Dragonfly](http://markevans.github.io/dragonfly) processors.

## Installation

Add this line to your application's Gemfile:

    gem 'dragonfly_harfbuzz'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dragonfly_harfbuzz

You will also need Harfbuzz installed. 

Using [Homebrew](http://brew.sh):

    $ brew install harfbuzz

Or build from source. See [Harfbuzz](http://harfbuzz.org) website for instructions.

## Usage

Add the `:harfbuzz` plugin to your Dragonfly config block:

```ruby
Dragonfly.app.configure do
  plugin :harfbuzz
  # ...
end
```

Then use as:

```ruby
font.hb_view('my text', :svg, { font_size: 36 })
```

See tests and `hb-view --help-all` for more details on options.

## Contributing

1. Fork it ( https://github.com/tomasc/dragonfly_harfbuzz/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
