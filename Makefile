DB_URL=postgresql://root:root@localhost:5432/simple_bank?sslmode=disable

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
	migrate -path db/migration -database "$(DB_URL)" -verbose up

migrateup1:
	migrate -path db/migration -database "$(DB_URL)" -verbose up 1

migratedown:
	migrate -path db/migration -database "$(DB_URL)" -verbose down

migratedown1:
	migrate -path db/migration -database "$(DB_URL)" -verbose down 1

sqlc:
	echo "Running sqlc..."
	sqlc generate
	echo "Sqlc done."

test:
	go test -v -cover ./...

server:
	echo "Running server..."
	go run main.go
	echo "Server done."

mock:
	echo "Generating mocks..."
	mockgen -build_flags=--mod=mod -package mockdb -destination db/mock/store.go github.com/rafaelvianacunha/simplebank/db/sqlc Store
	echo "Mocks generated."

.PHONY: createdb dropdb postgres migrateup migratedown sqlc test server mock