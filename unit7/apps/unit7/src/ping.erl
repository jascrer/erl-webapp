-module(ping).

-export([client/0,ping/3]).

client() ->
    {ok, Pid} = gun:open("localhost", 3031),
    {ok, _} = gun:await_up(Pid),
    StreamRef = gun:ws_upgrade(Pid, "/pong"),
    {upgrade, [<<"websocket">>], _} = gun:await(Pid, StreamRef),
    ping(3, Pid, StreamRef),
    gun:shutdown(Pid).

ping(0,_,_) ->
    io:format("Ping finished~n", []);
ping(N,Pid,StreamRef) ->
    Message = list_to_binary(io_lib:format("Ping ~s", [integer_to_list(N)])),
    io:format("Sent ~p~n", [Message]),
    %%I added the StreamRef in the gun:ws_send as it is necessary in newer versions of gun
    gun:ws_send(Pid, StreamRef, [{text, Message}]), 
    {ws, Frame} = gun:await(Pid, StreamRef),
    io:format("Received ~p~n", [Frame]),
    ping(N - 1, Pid, StreamRef).