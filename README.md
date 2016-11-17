# Lipsey's

Ruby library for Lipsey's API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lipseys'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lipseys

## Usage

**Note**: Nearly all methods require `:email` and `:password` keys in the options hash.

```ruby
options = {
  email: 'dealer@example.com',
  password: 'sekret-passwd'
}
```

### Lipseys::Catalog

There are several methods you can use to fetch different kinds (or all) items in the catalog.
All of the listed methods return the same response structure.  See `Lipseys::Catalog` for details.

```ruby
# All items
catalog = Lipseys::Catalog.all(options)

# Firearms only
firearms = Lipseys::Catalog.firearms(options)

# NFA / Class 3 items only
nfa = Lipseys::Catalog.nfa(options)

# Optics only
optics = Lipseys::Catalog.optics(options)

# Accessories only
accessories = Lipseys::Catalog.accessories(options)
```

### Lipseys::Inventory

There are similar methods for getting your account's inventory (availability, price, etc.).
All methods return the same response structure.  See `Lipseys::Inventory` for details.

```ruby
inventory = Lipseys::Inventory.all(options)
firearms = Lipseys::Inventory.firearms(options)
nfa = Lipseys::Inventory.nfa(options)
optics = Lipseys::Inventory.optics(options)
accessories = Lipseys::Inventory.accessories(options)
```

### Lipseys::Order

In addition to the `:email` and `:password` keys in the options hash, submitting an order requires
the following params:

```ruby
options = {
  email: 'dealer@example.com',
  password: 'sekret-passwd',

  item_number: '...',  # Lipsey's item number
  # - OR -
  upc: '...',  # Universal Product Code

  quantity: 1,
  purchase_order: 'PO-123',  # Application specific Purchase Order

  # Optional order params:
  notify_by_email: true,  # If you want an email sent when the order is created
  note: '...',  # Any notes attached to the order
}

response = Lipseys::Order.submit!(options)
```

The response will have this structure:  (See `Lipseys::Order` for more details)

```ruby
{
  order_number: '...',
  new_order: (true/false),
  success: (true/false),
  description: '...',
  quantity_received: Integer,
}
```

### Lipseys::Invoice

In addition to the `:email` and `:password` keys in the options hash, finding an invoice requires
either an `:order_number` **OR** a `:purchase_order` param.

```ruby
options = {
  email: 'dealer@example.com',
  password: 'sekret-passwd',

  order_number: '...',  # Lipsey's order number
  # - OR -
  purchase_order: '...',  # Application specific Purchase Order submitted with the order
}

invoice = Lipseys::Invoice.all(options)
```

See `Lipseys::Invoice` for the response structure details.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ammoready/lipseys.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

