:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_client)).
:- use_module(library(http/json)).
:- use_module(library(http/json_convert)).
:- use_module(library(http/http_cors)).

:- set_setting(http:cors, [*]).

:- http_handler(root(query), handle_query, [post]).


:- consult('procurement_kb.pl').

bindings_to_dict([], _).
bindings_to_dict([Name=Value|T], Dict) :-
    atom_string(Name, NameStr), % convert atom to string
    Dict.put(NameStr, Value),
    bindings_to_dict(T, Dict).


server(Port) :-
    http_server(http_dispatch, [port(Port)]).

handle_query(Request) :-
    cors_enable(Request,
                [ methods([get,post,delete])
                ]),
    http_read_json_dict(Request, Dict),
    Fact = Dict.get(fact),
    term_string(Term, Fact),
    Term =.. [Functor|Args],
    length(Args, Arity),
    (safe_predicate(Functor/Arity) ->
        (findall(Args, call(Term), Results),
         maplist(term_string, Results, ResultsStr),
         reply_json_dict(_{result: "true", bindings: ResultsStr})
        ;
         reply_json_dict(_{result: "false"})
        )
    ;
        reply_json_dict(_{error: "Unsafe predicate"})
    ).


safe_predicate(supplier/2).

% Add more predicates here as per your requirement.

