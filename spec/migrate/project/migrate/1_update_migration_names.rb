migrate(Financier::DATABASE, using: DB::Migrate) do
	
end

migrate(Financier::CACHE, using: Async::Redis::Migrate) do
	
end
