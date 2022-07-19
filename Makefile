postgres:
	docker run --name postgres12 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=root -d postgres:12-alpine

createdb:
	echo "Creating database..."
	docker exec -i postgres12 createdb --username=root --owner=root simple_bank
	echo "Database created."

dropdb:
	echo "Droping database..."
	docker exec -i postgres12 dropdb simple_bank
	echo "Database droped."

migrateup:
	echo "Migrating up..."
	migrate -path db/migration -database "postgresql://root:root@localhost:5432/simple_bank?sslmode=disable" -verbose up
	echo "Migration up."

migratedown:
	echo "Migrating down..."
	migrate -path db/migration -database "postgresql://root:root@localhost:5432/simple_bank?sslmode=disable" -verbose down
	echo "Migration down."

sqlc:
	echo "Running sqlc..."
	sqlc generate
	echo "Sqlc done."

test:
	echo "Running tests..."
	go test -v -cover ./...
	echo "Tests done."

.PHONY: createdb dropdb postgres migrateup migratedown sqlc