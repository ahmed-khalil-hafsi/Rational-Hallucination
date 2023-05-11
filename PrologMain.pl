:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_client)).
:- use_module(library(http/json)).
:- use_module(library(http/json_convert)).
:- use_module(library(http/http_cors)).

:- set_setting(http:cors, [*]).

:- http_handler(root(query), handle_query, [post]).

server(Port) :-
    http_server(http_dispatch, [port(Port)]).

handle_query(Request) :-
    cors_enable(Request,
                [ methods([get,post,delete])
                ]),
    http_read_json_dict(Request, Dict),
    format(string(Fact), Dict.get(fact)),
    term_string(Term, Fact),
    (call(Term) -> Result = true ; Result = false),
    reply_json_dict(_{result: Result}).
