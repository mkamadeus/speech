package main

import (
	"fmt"
	"net/http"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	"github.com/notnil/chess"
)

func main() {
	// init
	e := echo.New()
	game := chess.NewGame(chess.UseNotation(chess.UCINotation{}))

	// middlewares
	e.Use(middleware.Logger())
	e.Use(middleware.Recover())

	// handlers
	moveHandler := func(c echo.Context) error {
		// https://github.com/notnil/chess#uci-notation
		notation := c.QueryParam("q")
		fmt.Println(notation)
		err := game.MoveStr(notation)
		if err != nil {
			return c.String(http.StatusBadRequest, err.Error())
		}
		return c.String(http.StatusOK, game.Position().Board().Draw())
	}

	// routers
	e.PUT("/move", moveHandler)

	// start server
	e.Start(":1337")
}
