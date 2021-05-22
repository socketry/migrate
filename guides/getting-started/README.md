# Getting Started

This guide explains how to use `migrate` for executing structured migrations against persistent data sources.

## Installation

Add the gem to your project:

~~~ bash
$ bundle add migrate
~~~

## Core Concepts

`migrate` has several core concepts:

- A {ruby Migrate::Migration} instance which represents a specific source file which can be executed to perform a migration.
- A {ruby Migrate::Provider} class which represents an interface which can migrate a specific kind of data source.

## Applying a Migration

You can apply all current migrations:

~~~ bash
$ bake migrate
~~~

## Create a Migration

You can create a migration:

~~~ bash
$ bake migrate:create my_migration
~~~
