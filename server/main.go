package server

import (
	"github.com/labstack/echo"
	"net/http"
	"users"
)

// Use a warmup request to help smooth App Engine auto-scaling, 
// see: https://cloud.google.com/appengine/docs/standard/go/configuring-warmup-requests
// Note this isn't guaranteed to run in all cases so never do initialization in
// warmup requests. Minor initialization can occur in the init() function below.
// If you have work that needs to occur regularly, consider using the Google Cloud
// Cron service
//
// Warmup requests also need to be configured in server/app.yaml
func warmup(ctx echo.Context) error {
	return ctx.JSON(http.StatusOK, map[string]interface{}{
		"success": true,
	})
}

// Using handler functions like this, you can create a basic rest API
func example(ctx echo.Context) error {
	return ctx.JSON(http.StatusOK, map[string]interface{}{
		"success": true,
		"fakeUser":users.EXAMPLE_CONST,
	})
}

func init(){
	// I chose to use echo for this demo so you can see a more complete example
	// that leverages vendored dependencies.
	echoServer := echo.New()

	// Warmup request configured in app.yaml
	echoServer.GET("/_ah/warmup", warmup)

	// Our only API route for now. Echo will return a 404 or 405 for all other
	// paths
	echoServer.GET("/api/example", example)
	http.Handle("/", echoServer)
}

