# LibUCL FFI bindings for Ruby

[![GitHub license](https://img.shields.io/github/license/jbox-web/ucl.svg)](https://github.com/jbox-web/ucl/blob/master/LICENSE)
[![GitHub release](https://img.shields.io/github/release/jbox-web/ucl.svg)](https://github.com/jbox-web/ucl/releases/latest)
[![Build Status](https://travis-ci.com/jbox-web/ucl.svg?branch=master)](https://travis-ci.com/jbox-web/ucl)
[![Code Climate](https://codeclimate.com/github/jbox-web/ucl/badges/gpa.svg)](https://codeclimate.com/github/jbox-web/ucl)
[![Test Coverage](https://codeclimate.com/github/jbox-web/ucl/badges/coverage.svg)](https://codeclimate.com/github/jbox-web/ucl/coverage)

[LibUCL](https://github.com/vstakhov/libucl) is a universal configuration language.

This gem is a Ruby wrapper around LibUCL implemented with [FFI](https://github.com/ffi/ffi).

It was heavily inspired by [pyucl](https://github.com/jaimeMF/pyucl).


## Installation

Put this in your `Gemfile` :

```ruby
gem 'ucl'
```

then run `bundle install`.

[LibUCL](https://github.com/vstakhov/libucl) is vendored with the gem and is automatically compiled when you install the gem.

You can disable this behavior by setting `USE_GLOBAL_LIBUCL` environment variable to `true` before running `bundle install`.

By default the gem looks for `libucl.so` in the system path and fallbacks to the bundled version if not found.


## Usage

* `UCL.load(string)`

```ruby
ucl_conf =
  '''
  string: "bar",
  "string2": baz,
  true = true
  false = false
  nil: null
  integer 1864
  double 23.42
  time: 10s
  array: [
    "foo",
    true,
    false,
    null,
    1864,
    23.42,
    10s,
  ]
  hash: {
    foo  "bar"
    bar = baz
    baz: "foo"
  }
  array_of_array: [
    ["foo", "bar"]
    ["bar", "baz"]
  ]
  auto_array = {
    key: "foo"
    key: "bar"
    key: "baz"
  }
  section "foo" {
    key = value;
  }
  section bar {
    key = value;
  }
  section "baz" "foo" {
    key = value;
  }
  '''

object = UCL.load(ucl_conf)

puts object # =>
{
  'string'  => 'bar',
  'string2' => 'baz',
  'true'    => true,
  'false'   => false,
  'nil'     => nil,
  'integer' => 1864,
  'double'  => 23.42,
  'time'    => 10.0,
  'array'   => [
    'foo',
    true,
    false,
    nil,
    1864,
    23.42,
    10.0
  ],
  'hash' => {
    'foo' => 'bar',
    'bar' => 'baz',
    'baz' => 'foo'
  },
  'array_of_array' => [
    ["foo", "bar"],
    ["bar", "baz"]
  ],
  'auto_array' => {
    'key' => ['foo', 'bar', 'baz']
  },
  'section' => {
    'foo' => {
      'key' => 'value'
    },
    'bar' => {
      'key' => 'value',
    },
    'baz' => {
      'foo' => {
        'key' => 'value'
      }
    },
  },
}
```

* `UCL.dump(object)`

```ruby
object =
  {
    'string'  => 'bar',
    'true'    => true,
    'false'   => false,
    'nil'     => nil,
    'integer' => 1864,
    'double'  => 23.42,
    'time'    => 10.seconds,
    'array'   => [
      'foo',
      true,
      false,
      nil,
      1864,
      23.42,
      10.seconds
    ],
    'hash' => {
      'foo' => 'bar',
      'bar' => 'baz',
      'baz' => 'foo'
    },
    'array_of_array' => [
      ["foo", "bar"],
      ["bar", "baz"]
    ],
    'section' => {
      'foo' => {
        'key' => 'value'
      },
      'bar' => {
        'key' => 'value',
      },
      'baz' => {
        'foo' => {
          'key' => 'value'
        }
      },
    },
  }

ucl_conf = UCL.dump(object)

puts ucl_conf # =>
'''
string = "bar";
true = true;
false = false;
nil = null;
integer = 1864;
double = 23.420000;
time = 10.0;
array [
    "foo",
    true,
    false,
    null,
    1864,
    23.420000,
    10.0,
]
hash {
    foo = "bar";
    bar = "baz";
    baz = "foo";
}
array_of_array [
    [
        "foo",
        "bar",
    ]
    [
        "bar",
        "baz",
    ]
]
section {
    foo {
        key = "value";
    }
    bar {
        key = "value";
    }
    baz {
        foo {
            key = "value";
        }
    }
}
'''
```

* `UCL.validate(schema, string)`

```ruby
schema =
  '''
  {
    "type": "object",
    "properties": {
      "key": {
        "type": "string"
      }
    }
  }
  '''

ucl_conf =
  '''
  {
    "key": "some string"
  }
  '''

puts UCL.validate(schema, string) # =>
true
```

It raises an exception (`UCL::Error::SchemaError`) if the schema is not valid.


## Development

To compile LibUCL in dev environment use `bin/rake compile`.

To run specs use `bin/rspec`.


## Other bindings

* [Go](https://github.com/mitchellh/go-libucl)
* [Rust](https://github.com/draft6/libucl-rs)
* [Python](https://github.com/vstakhov/libucl/tree/master/python)
* [Crystal](https://github.com/jbox-web/ucl.cr)
