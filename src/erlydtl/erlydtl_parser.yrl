%%%-------------------------------------------------------------------
%%% File:      erlydtl_parser.erl
%%% @author    Roberto Saccon <rsaccon@gmail.com> [http://rsaccon.com]
%%% @author    Evan Miller <emmiller@gmail.com>
%%% @copyright 2008 Roberto Saccon, Evan Miller
%%% @doc Template language grammar
%%% @reference  See <a href="http://erlydtl.googlecode.com" target="_top">http://erlydtl.googlecode.com</a> for more information
%%% @end  
%%%
%%% The MIT License
%%%
%%% Copyright (c) 2007 Roberto Saccon, Evan Miller
%%%
%%% Permission is hereby granted, free of charge, to any person obtaining a copy
%%% of this software and associated documentation files (the "Software"), to deal
%%% in the Software without restriction, including without limitation the rights
%%% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%%% copies of the Software, and to permit persons to whom the Software is
%%% furnished to do so, subject to the following conditions:
%%%
%%% The above copyright notice and this permission notice shall be included in
%%% all copies or substantial portions of the Software.
%%%
%%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%%% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%%% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%%% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%%% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%%% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
%%% THE SOFTWARE.
%%%
%%% @since 2007-11-11 by Roberto Saccon, Evan Miller
%%%-------------------------------------------------------------------

Nonterminals
    Elements
    Literal

    ValueBraced

    ExtendsTag
    IncludeTag
    NowTag

    BlockBlock
    BlockBraced
    EndBlockBraced

    CommentBlock
    CommentBraced
    EndCommentBraced

    CycleTag
    CycleNames
    CycleNamesCompat

    FirstofTag
    FirstofList
    FirstofValues

    ForBlock
    ForBraced
    EmptyBraced
    EndForBraced
    ForExpression
    ForGroup

    IfBlock
    IfBraced
    IfExpression
    ElseBraced
    EndIfBraced
    
    IfEqualBlock
    IfEqualBraced
    IfEqualExpression
    EndIfEqualBraced  
    
    IfNotEqualBlock
    IfNotEqualBraced
    IfNotEqualExpression
    EndIfNotEqualBraced      

    AutoEscapeBlock
    AutoEscapeBraced
    EndAutoEscapeBraced

    Value
    Variable
    Filter
    
    LoadTag
    LoadNames
    
    CustomTag
    Args

    TransTag    

    CallTag
    CallWithTag
    
    Unot.

Terminals
    and_keyword
    autoescape_keyword
    block_keyword
    call_keyword
    close_tag
    close_var
    comment_keyword
    cycle_keyword
    else_keyword
    empty_keyword
    endautoescape_keyword
    endblock_keyword
    endcomment_keyword
    endfor_keyword
    endif_keyword
    endifequal_keyword
    endifnotequal_keyword
    extends_keyword
    firstof_keyword
    for_keyword
    identifier
    if_keyword
    ifequal_keyword
    ifnotequal_keyword
    in_keyword
    include_keyword
    load_keyword
    noop_keyword
    not_keyword
    now_keyword
    number_literal
    or_keyword
    open_tag
    open_var
    string_literal
    string
    trans_keyword
    with_keyword
    ',' '|' '=' ':' '.'
    '==' '!='
    '>=' '<='
    '>' '<'
    '(' ')'.

Rootsymbol
    Elements.

%% Operator precedences for the E non terminal
Left 100 or_keyword.
Left 110 and_keyword.
Nonassoc 300 '==' '!=' '>=' '<=' '>' '<'.
Unary 600 Unot.

Elements -> '$empty' : [].
Elements -> Elements string : '$1' ++ ['$2'].
Elements -> Elements TransTag : '$1' ++ ['$2'].
Elements -> Elements ValueBraced : '$1' ++ ['$2'].
Elements -> Elements ExtendsTag : '$1' ++ ['$2'].
Elements -> Elements IncludeTag : '$1' ++ ['$2'].
Elements -> Elements NowTag : '$1' ++ ['$2'].
Elements -> Elements LoadTag : '$1' ++ ['$2'].
Elements -> Elements CycleTag : '$1' ++ ['$2'].
Elements -> Elements BlockBlock : '$1' ++ ['$2'].
Elements -> Elements FirstofTag : '$1' ++ ['$2'].
Elements -> Elements ForBlock : '$1' ++ ['$2'].
Elements -> Elements IfBlock : '$1' ++ ['$2'].
Elements -> Elements IfEqualBlock : '$1' ++ ['$2'].
Elements -> Elements IfNotEqualBlock : '$1' ++ ['$2'].
Elements -> Elements AutoEscapeBlock : '$1' ++ ['$2'].
Elements -> Elements CommentBlock : '$1' ++ ['$2'].
Elements -> Elements CustomTag : '$1' ++ ['$2'].
Elements -> Elements CallTag : '$1' ++ ['$2'].
Elements -> Elements CallWithTag : '$1' ++ ['$2'].

ValueBraced -> open_var Value close_var : '$2'.

Value -> Value '|' Filter : {apply_filter, '$1', '$3'}.
Value -> Variable : '$1'.
Value -> Literal : '$1'.

Variable -> identifier : {variable, '$1'}.
Variable -> Variable '.' identifier : {attribute, {'$3', '$1'}}.

TransTag -> open_tag trans_keyword string_literal close_tag : {trans, '$3'}.
TransTag -> open_tag trans_keyword Variable close_tag : {trans, '$3'}.
TransTag -> open_tag trans_keyword string_literal noop_keyword close_tag : '$3'.
TransTag -> open_tag trans_keyword Variable noop_keyword close_tag : '$3'.

ExtendsTag -> open_tag extends_keyword string_literal close_tag : {extends, '$3'}.
IncludeTag -> open_tag include_keyword string_literal close_tag : {include, '$3'}.
NowTag -> open_tag now_keyword string_literal close_tag : {date, now, '$3'}.

LoadTag -> open_tag load_keyword LoadNames close_tag : {load, '$3'}.
LoadNames -> identifier : ['$1'].
LoadNames -> LoadNames identifier : '$1' ++ ['$2'].

BlockBlock -> BlockBraced Elements EndBlockBraced : {block, '$1', '$2'}.
BlockBraced -> open_tag block_keyword identifier close_tag : '$3'.
EndBlockBraced -> open_tag endblock_keyword close_tag.

CommentBlock -> CommentBraced Elements EndCommentBraced : {comment, '$2'}.
CommentBraced -> open_tag comment_keyword close_tag.
EndCommentBraced -> open_tag endcomment_keyword close_tag.

CycleTag -> open_tag cycle_keyword CycleNamesCompat close_tag : {cycle_compat, '$3'}.
CycleTag -> open_tag cycle_keyword CycleNames close_tag : {cycle, '$3'}.

CycleNames -> Value : ['$1'].
CycleNames -> CycleNames Value : '$1' ++ ['$2'].

CycleNamesCompat -> identifier ',' : ['$1'].
CycleNamesCompat -> CycleNamesCompat identifier ',' : '$1' ++ ['$2'].
CycleNamesCompat -> CycleNamesCompat identifier : '$1' ++ ['$2'].

FirstofTag -> open_tag firstof_keyword FirstofList close_tag : '$3'.
FirstofList -> FirstofValues : {firstof, '$1'}.
FirstofValues -> FirstofValues Value : ['$2'|'$1'].
FirstofValues -> Value : ['$1'].

ForBlock -> ForBraced Elements EndForBraced : {for, '$1', '$2'}.
ForBlock -> ForBraced Elements EmptyBraced Elements EndForBraced : {for, '$1', '$2', '$4'}.
EmptyBraced -> open_tag empty_keyword close_tag.
ForBraced -> open_tag for_keyword ForExpression close_tag : '$3'.
EndForBraced -> open_tag endfor_keyword close_tag.
ForExpression -> ForGroup in_keyword Variable : {'in', '$1', '$3'}.
ForGroup -> identifier : ['$1'].
ForGroup -> ForGroup ',' identifier : '$1' ++ ['$3'].

IfBlock -> IfBraced Elements ElseBraced Elements EndIfBraced : {ifelse, '$1', '$2', '$4'}.
IfBlock -> IfBraced Elements EndIfBraced : {'if', '$1', '$2'}.
IfBraced -> open_tag if_keyword IfExpression close_tag : '$3'.
IfExpression -> Value in_keyword Value : {'expr', "in", '$1', '$3'}.
IfExpression -> Value not_keyword in_keyword Value : {'expr', "not", {'expr', "in", '$1', '$4'}}.
IfExpression -> Value '==' Value : {'expr', "eq", '$1', '$3'}.
IfExpression -> Value '!=' Value : {'expr', "ne", '$1', '$3'}.
IfExpression -> Value '>=' Value : {'expr', "ge", '$1', '$3'}.
IfExpression -> Value '<=' Value : {'expr', "le", '$1', '$3'}.
IfExpression -> Value '>' Value : {'expr', "gt", '$1', '$3'}.
IfExpression -> Value '<' Value : {'expr', "lt", '$1', '$3'}.
IfExpression -> '(' IfExpression ')' : '$2'.
IfExpression -> Unot : '$1'.
IfExpression -> IfExpression or_keyword IfExpression : {'expr', "or", '$1', '$3'}.
IfExpression -> IfExpression and_keyword IfExpression : {'expr', "and", '$1', '$3'}.
IfExpression -> Value : '$1'.

Unot -> not_keyword IfExpression : {expr, "not", '$2'}.

ElseBraced -> open_tag else_keyword close_tag.
EndIfBraced -> open_tag endif_keyword close_tag.

IfEqualBlock -> IfEqualBraced Elements ElseBraced Elements EndIfEqualBraced : {ifequalelse, '$1', '$2', '$4'}.
IfEqualBlock -> IfEqualBraced Elements EndIfEqualBraced : {ifequal, '$1', '$2'}.
IfEqualBraced -> open_tag ifequal_keyword IfEqualExpression Value close_tag : ['$3', '$4'].
IfEqualExpression -> Value : '$1'.
EndIfEqualBraced -> open_tag endifequal_keyword close_tag.

IfNotEqualBlock -> IfNotEqualBraced Elements ElseBraced Elements EndIfNotEqualBraced : {ifnotequalelse, '$1', '$2', '$4'}.
IfNotEqualBlock -> IfNotEqualBraced Elements EndIfNotEqualBraced : {ifnotequal, '$1', '$2'}.
IfNotEqualBraced -> open_tag ifnotequal_keyword IfNotEqualExpression Value close_tag : ['$3', '$4'].
IfNotEqualExpression -> Value : '$1'.
EndIfNotEqualBraced -> open_tag endifnotequal_keyword close_tag.

AutoEscapeBlock -> AutoEscapeBraced Elements EndAutoEscapeBraced : {autoescape, '$1', '$2'}.
AutoEscapeBraced -> open_tag autoescape_keyword identifier close_tag : '$3'.
EndAutoEscapeBraced -> open_tag endautoescape_keyword close_tag.

Filter -> identifier : ['$1'].
Filter -> identifier ':' Literal : ['$1', '$3'].

Literal -> string_literal : '$1'.
Literal -> number_literal : '$1'.

CustomTag -> open_tag identifier Args close_tag : {tag, '$2', '$3'}.

Args -> '$empty' : [].
Args -> Args identifier '=' Value : '$1' ++ [{'$2', '$4'}].

CallTag -> open_tag call_keyword identifier close_tag : {call, '$3'}.
CallWithTag -> open_tag call_keyword identifier with_keyword Value close_tag : {call, '$3', '$5'}.
