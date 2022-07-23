package main

import (
	"database/sql"
	"log"

	_ "github.com/lib/pq"
	"github.com/rafaelvianacunha/simplebank/api"
	db "github.com/rafaelvianacunha/simplebank/db/sqlc"
	"github.com/rafaelvianacunha/simplebank/util"
)

func main() {
	config, err := util.LoadConfig(".")
	if err != nil {
		log.Fatal("can't load config: ", err)
	}

	conn, err := sql.Open(config.DBDriver, config.DBSource)

	if err != nil {
		log.Fatal("can't connect to database: ", err)
	}

	store := db.NewStore(conn)
	server := api.NewServer(store)

	err = server.Start(config.ServerAddress)

	if err != nil {
		log.Fatal("can't start server: ", err)
	}

}
