package main

import (
	"database/sql"
	"fmt"
	"html/template"
	"net/http"
	"net/url"

	_ "github.com/denisenkom/go-mssqldb"
)

type dbRecord struct {
	Id string
	Va string
	Dt string
}

func main() {
	HandleFunc()
}

func HandleFunc() {
	http.HandleFunc("/create", create)
	http.HandleFunc("/save", save)
	http.HandleFunc("/", index)

	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		panic(err)
	}
}

func save(writer http.ResponseWriter, request *http.Request) {

	id := request.FormValue("id")
	va := request.FormValue("val")

	query := url.Values{}
	query.Add("app name", "MyAppName")

	u := &url.URL{
		Scheme:   "sqlserver",
		User:     url.UserPassword("tcuser", "tcuser"),
		Host:     fmt.Sprintf("%s:%d", "192.168.0.9", 1433),
		RawQuery: query.Encode(),
	}
	db, err := sql.Open("sqlserver", u.String())

	if err != nil {
		panic(err)
	}

	defer db.Close()

	insert, err := db.Query(fmt.Sprintf("insert into test_table (id, val, dt) values ('%v', '%v', getdate());", id, va))
	if err != nil {
		panic(err)
	}
	defer insert.Close()

	http.Redirect(writer, request, "/", 301)
}

func create(writer http.ResponseWriter, request *http.Request) {

	t, err := template.ParseFiles("templates/create.html", "templates/footer.html", "templates/header.html ")
	if err != nil {
		panic(err)
	}

	err2 := t.ExecuteTemplate(writer, "create", nil)

	if err2 != nil {
		panic(err)
	}
}

func index(writer http.ResponseWriter, request *http.Request) {

	var dbRecords []dbRecord

	t, err := template.ParseFiles("templates/index.html", "templates/footer.html", "templates/header.html ")

	if err != nil {
		_, err := fmt.Fprintf(writer, err.Error())
		if err != nil {
			panic(err)
		}
	}

	query := url.Values{}
	query.Add("app name", "MyAppName")

	u := &url.URL{
		Scheme:   "sqlserver",
		User:     url.UserPassword("tcuser", "tcuser"),
		Host:     fmt.Sprintf("%s:%d", "192.168.0.9", 1433),
		RawQuery: query.Encode(),
	}
	db, err := sql.Open("sqlserver", u.String())

	if err != nil {
		panic(err)
	}

	defer db.Close()

	res, err := db.Query("select id, val, dt from dbo.test_table;")
	if err != nil {
		panic(err)
	}

	for res.Next() {
		var t dbRecord
		err = res.Scan(&t.Id, &t.Va, &t.Dt)
		if err != nil {
			panic(err)
		}
		dbRecords = append(dbRecords, t)
	}

	defer func(res *sql.Rows) {
		err := res.Close()
		if err != nil {
			panic(err)
		}
	}(res)

	fmt.Print(dbRecords)
	err2 := t.ExecuteTemplate(writer, "index", dbRecords)

	if err2 != nil {
		panic(err)
	}
}
