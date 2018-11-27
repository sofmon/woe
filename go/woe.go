package woe

import (
	"encoding/json"
	"io/ioutil"
	"net/http"
	"net/url"
	"strings"
)

// Request for update
type Request struct {
	json []byte
}

// Populate object as the update request
func (r Request) Populate(v interface{}) error {
	return json.Unmarshal(r.json, v)
}

// NewHandlerFunc create handle func for the http package with
// - getFunc is used to retrieve the json to be displayed
func NewHandlerFunc(getFunc func(url url.URL) (interface{}, error), updateFunc func(url url.URL, req Request) (interface{}, error)) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		switch r.Method {
		case http.MethodGet:
			switch {
			case strings.HasSuffix(r.URL.Path, "woe.js"):
				serveJS(w, r)
			case strings.HasSuffix(r.URL.Path, "woe.json"):
				serveLoad(w, r, getFunc)
			default:
				serveHTML(w, r)
			}
		case http.MethodPost:
			serveSave(w, r, updateFunc)
		}
	}
}

func serveHTML(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	w.Write([]byte(woeHTML))
}

func serveJS(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/javascript; charset=utf-8")
	w.Write([]byte(woeJS))
}

func serveLoad(w http.ResponseWriter, r *http.Request, getFunc func(url url.URL) (interface{}, error)) {
	obj, err := getFunc(*r.URL)
	if err != nil {
		serveError(w, r, err)
		return
	}
	data, err := json.Marshal(obj)
	if err != nil {
		serveError(w, r, err)
		return
	}
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.Write(data)
}

func serveSave(w http.ResponseWriter, r *http.Request, updateFunc func(url url.URL, req Request) (interface{}, error)) {
	data, err := ioutil.ReadAll(r.Body)
	if err != nil {
		serveError(w, r, err)
		return
	}
	obj, err := updateFunc(*r.URL, Request{data})
	if err != nil {
		serveError(w, r, err)
		return
	}
	data, err = json.Marshal(obj)
	if err != nil {
		serveError(w, r, err)
		return
	}
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.Write(data)
}

func serveError(w http.ResponseWriter, r *http.Request, err error) {
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	w.WriteHeader(http.StatusInternalServerError)
	w.Write([]byte(err.Error()))
}
