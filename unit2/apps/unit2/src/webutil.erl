-module(webutil).
-export([template/2]).

-spec template(FileName :: file:filename(), ArgList :: [string()]) -> Html :: [char()].
%% @doc Reads an html file from its complete path name, and inserts strings without escaping `<' or `>'.
template(FileName, ArgList) ->
  {ok, Binary} = file:read_file(FileName),
  io_lib:format(Binary, ArgList).