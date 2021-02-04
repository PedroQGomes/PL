%{
#include "y.tab.h"
#include <stdio.h>
%}
%option noyywrap
%%
(?i:title)                          { return (TITLE); }
(?i:owner)                          { return (OWNER); }
(?i:database)                       { return (DATABASE);}
(?i:servers)                        { return (SERVERS);}
(?i:name)                           { return (NAME); } 
(?i:date)                           { return (DATE); }
(?i:time)                           { return (TIME); }
(?i:server)                         { return (SERVER); }
(?i:ports)                          { return (PORTS); }
(?i:connection_max)                 { return (CONNECT_MAX); }
(?i:enabled)                        { return (DB_ENABLED); }
(?i:ip)                             { return (IP); }
(?i:dc)                             { return (DC); }
(?i:hosts)                          { return (HOSTS);}
(?i:(\[servers\.[a-zA-Z]+\]))       { yytext[yyleng-1] = '\0'; yylval.nome = strdup(yytext+9);return (SUBSERVER); }
[0-9]+                              { yylval.numero = atoi(yytext); return num; }
[0-9]{4}\-[0-9]{2}\-[0-9]{2}        { yylval.nome = strdup(yytext); return texto;} 
[0-9]{2}\:[0-9]{2}(\:[0-9]{2})?     { yylval.nome = strdup(yytext); return texto;}
[Tt][Rr][Uu][Ee]                    { yylval.nome = strdup(yytext); return texto;}
[Ff][Aa][Ll][Ss][Ee]                { yylval.nome = strdup(yytext); return texto;}
\"[^"]+\"                           { yytext[yyleng-1] = '\0'; yylval.nome = strdup(yytext + 1); return texto;}
[\=\[\]\,]                          { return yytext[0];}
#                                   {;}
.|\n                                {;}

%%
