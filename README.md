# Neologdish::Normalizer for Ruby

A Japanese text normalization library for Ruby follows the conventions of [neologd/mecab-ipadic-neologd](https://github.com/neologd/mecab-ipadic-neologd), with some performance optimizations. It is designed to preprocess Japanese text before applying NLP techniques.

The specific rules are documented here: https://github.com/neologd/mecab-ipadic-neologd/wiki/Regexp.ja

## Usage

```ruby
require "neologdish-normalizer"

Neologdish::Normalizer.normalize("南アルプスの　天然水-　Ｓｐａｒｋｉｎｇ*　Ｌｅｍｏｎ+　レモン一絞り")
# => 南アルプスの天然水-Sparking*Lemon+レモン一絞り 
```

## Benchmark

The performance comparison between the official Ruby example (https://github.com/neologd/mecab-ipadic-neologd/wiki/Regexp.ja#ruby-written-by-kimoto-and-overlast) and this library is as follows:

```
                           user     system      total        real
original normalizer:   4.200670   0.032004   4.232674 (  4.274573)
this library:          1.158801   0.005238   1.164039 (  1.170226)
```

The benchmark script is here: [./scripts/benchmark.rb](./scripts/benchmark.rb)

## Installation

TODO: Replace `UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG` with your gem name right after releasing it to RubyGems.org. Please do not do it earlier due to security reasons. Alternatively, replace this section with instructions to install your gem from git if you don't plan to release to RubyGems.org.

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/moznion/neologdish-normalizer.

