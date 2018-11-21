package owe

import (
	"io/ioutil"
	"net/http"
	"net/url"
	"strings"
)

// NewHandlerFunc create handle func for the http package with
// - getFunc is used to retrieve the json to be displayed
func NewHandlerFunc(getFunc func(url url.URL) ([]byte, error), updateFunc func(url url.URL, json []byte) ([]byte, error), errFunc func(url url.URL, err error)) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		switch r.Method {
		case http.MethodGet:
			if strings.HasSuffix(r.URL.Path, "owe.js") {
				serveJS(w, r)
			} else {
				serveHTML(w, r)
			}
		case http.MethodPost:
			serveLoad(w, r, getFunc)
		case http.MethodPut:
			serveSave(w, r, updateFunc)
		}
	}
}

func serveHTML(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	w.Write([]byte(oweHTML))
}

func serveJS(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/javascript; charset=utf-8")
	w.Write([]byte(oweJS))
}

func serveLoad(w http.ResponseWriter, r *http.Request, getFunc func(url url.URL) ([]byte, error)) {
	json, err := getFunc(*r.URL)
	if err != nil {
		serveError(w, r, err)
		return
	}
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.Write(json)
}

func serveSave(w http.ResponseWriter, r *http.Request, updateFunc func(url url.URL, json []byte) ([]byte, error)) {
	json, err := ioutil.ReadAll(r.Body)
	if err != nil {
		serveError(w, r, err)
		return
	}
	json, err = updateFunc(*r.URL, json)
	if err != nil {
		serveError(w, r, err)
		return
	}
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.Write(json)
}

func serveError(w http.ResponseWriter, r *http.Request, err error) {
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	w.WriteHeader(http.StatusInternalServerError)
	w.Write([]byte(err.Error()))
}
