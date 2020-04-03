%{
#include <commentThread.h>
#include <stdio.h>
#include <glib.h>

CommentThread t;

%}
acentos \xc3[\x80-\xbf]       
letra [a-zA-Z]|{acentos} 
pL               [a-z]|ç|ã|á|à|â|é|
%x ID USER TIMESTAMP TEXT

%%

\<(li)[' '](class)\=\"(comment)\"       {t = newCommentThread();BEGIN ID;}
<ID>\>                                  {BEGIN INITIAL;}
<ID>[' ']                               {;}
<ID>\"                                  {;}
<ID>\=                                  {;}
<ID>data\-comment\-id                   {;}
<ID>.                                   {setID(t,yytext);}


\<(h5)[' '](class)\=\"(comment__author)\"\>             {BEGIN USER;}
<USER>\<\/h5\>                                          {BEGIN INITIAL;} 
<USER>\n                                                {;}
<USER>\<(a)[' '](href)\=\"(.*)\"[' '](rel)\=\"(.*)\"\>  {;}
<USER>\<\/a\>                                           {;}
<USER>.                                                 {setUser(t,yytext);}


\<(time)[' '](class)                    {BEGIN TIMESTAMP;}
<TIMESTAMP>\<\/time\>                   {BEGIN INITIAL;}
<TIMESTAMP>[0-9]{2}\.[0-9]{2}\.[0-9]{4} {setDate(t,yytext);} 
<TIMESTAMP>[0-9]{2}\:[0-9]{2}           {setTimeStamp(t,yytext);}
<TIMESTAMP>.|\n                         {;}


\<(div)[' '](class)\=\"(comment__content)\"\>  {BEGIN TEXT;}
<TEXT>\<\/p\>                                  {BEGIN INITIAL;}
<TEXT>\<p\>                                    {;}
<TEXT>\n                                       {;}
<TEXT>[' ']                                    {addCommentTxt(t,yytext);} 
<TEXT>[' ']+                                   {;}
<TEXT>{pL}+                                    {addCommentTxt(t,yytext);}
<TEXT>.                                        {addCommentTxt(t,yytext);}




.|\n  { ; }
%%




int yywrap()
{ return(1); }

int main()
{ 
yylex();



printamerdas(t);
 return 0; 
}
