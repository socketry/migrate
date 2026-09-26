# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2017-2021, by Samuel Williams.

migrate(Financier::DATABASE, using: DB::Migrate) do
	
end

migrate(Financier::CACHE, using: Async::Redis::Migrate) do
	
end
