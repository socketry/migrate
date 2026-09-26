# Migrate

Provides a generic set of tools to implement migrations.

[![Development Status](https://github.com/socketry/migrate/workflows/Test/badge.svg)](https://github.com/socketry/migrate/actions?workflow=Test)

## Usage

Please see the [project documentation](https://socketry.github.io/migrate).

### Checkpoints

A checkpoint is an absolute snapshot of state, while a regular migration is a delta applied on top of the existing state. A checkpoint migration is any migration whose name contains the `checkpoint` marker, for example:

``` ruby
20260101000000-checkpoint.rb
```

Checkpoints are optional, and without one, all non-checkpoint migrations are applied in order:

``` ruby
controller.migrate!
```

When a checkpoint is present, it is applied first, and then only the migrations which sort after it are applied:

``` ruby
# Apply the most recent checkpoint:
controller.migrate!(checkpoint: true)

# Apply the checkpoint with a specific name:
controller.migrate!(checkpoint: "20260101000000-checkpoint.rb")
```

If the specified checkpoint cannot be found, a `RuntimeError` is raised.

## Releases

There are no documented releases.

## Contributing

We welcome contributions to this project.

1.  Fork the repository.
2.  Create your feature branch (`git checkout -b my-new-feature`).
3.  Commit your changes (`git commit -am 'Add some feature.'`).
4.  Push to the branch (`git push origin my-new-feature`).
5.  Create a new pull request.

### Running Tests

To run the test suite:

``` bash
$ bundle exec sus
```

### Making Releases

To make a new release:

``` bash
$ bundle exec bake gem:release:patch # or minor or major
```

### Developer Certificate of Origin

In order to protect users of this project, we require all contributors to comply with the [Developer Certificate of Origin](https://developercertificate.org/). This ensures that all contributions are properly licensed and attributed.

### Community Guidelines

This project is best served by a collaborative and respectful environment. Treat each other professionally, respect differing viewpoints, and engage constructively. Harassment, discrimination, or harmful behavior is not tolerated. Communicate clearly, listen actively, and support one another. If any issues arise, please inform the project maintainers.
