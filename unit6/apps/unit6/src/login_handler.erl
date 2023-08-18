-module(login_handler).
-behaviour(cowboy_handler).

-export([init/2]).

init(Req0=#{method := <<"GET">>}, State) ->
  {ok, Content} = file:read_file(code:priv_dir(unit6) ++ "/login_form.html"),
  Req = cowboy_req:reply(200,
    #{<<"content-type">> => <<"text/html; charset=UTF-8">>}, Content, Req0),
  {ok, Req, State};

init(Req0=#{method := <<"POST">>}, State) ->
  {ok, [{JString, true}], _} = cowboy_req:read_urlencoded_body(Req0),
  Proplist = jsx:decode(JString),%%TODO: Might need list convertion
  ConvertedProps = lists:map(fun webutil:convert_maps/1, maps:to_list(Proplist)),
  Json = jsx:encode([{<<"uuid">>, webutil:getuuid(ConvertedProps)}]),
  Req = cowboy_req:reply(200,
    #{<<"content-type">> => <<"application/json; charset=UTF-8">>},
    Json,
    Req0
    ),
  {ok, Req, State}.
