%{
#include <commentThread.h>
#include <stdio.h>
#include <glib.h>

 
CommentThread head;
CommentThread curr;


%}
acentos \xc3[\x80-\xbf]       
letra [a-zA-Z]|{acentos} 
pL               [a-z]|ç|ã|á|à|â|é|
%x ID USER TIMESTAMP TEXT REPLY

%%

\<(ol)[' '](class)\=\"(comments__list)\"[' '](id)\=\"(approved)\-(comments)\"\> {head = newCommentThread();}                                           


\<(li)[' '](class)\=\"(comment)\"       {curr = addnewComment(head);BEGIN ID;}
<ID>\>                                  {BEGIN INITIAL;}
<ID>[' ']                               {;}
<ID>\"                                  {;}
<ID>\n                                  {;}
<ID>\=                                  {;}
<ID>data\-comment\-id                   {;}
<ID>.                                   {setID(curr,yytext);}


\<(h5)[' '](class)\=\"(comment__author)\"\>             {BEGIN USER;}
<USER>\<\/h5\>                                          {BEGIN INITIAL;} 
<USER>\n                                                {;}
<USER>\<(a)[' '](href)\=\"(.*)\"[' '](rel)\=\"(.*)\"\>  {;}
<USER>\<\/a\>                                           {;}
<USER>.                                                 {setUser(curr,yytext);}


\<(time)[' '](class)                    {BEGIN TIMESTAMP;}
<TIMESTAMP>\<\/time\>                   {BEGIN INITIAL;}
<TIMESTAMP>[0-9]{2}\.[0-9]{2}\.[0-9]{4} {setDate(curr,yytext);} 
<TIMESTAMP>[0-9]{2}\:[0-9]{2}           {setTimeStamp(curr,yytext);}
<TIMESTAMP>.|\n                         {;}


\<(div)[' '](class)\=\"(comment__content)\"\>  {BEGIN TEXT;}
<TEXT>\<\/p\>                                  {BEGIN INITIAL;}
<TEXT>\<p\>                                    {;}
<TEXT>\n                                       {;} 
<TEXT>[' '][' '][' ']+                         {;}
<TEXT>.                                        {addCommentTxt(curr,yytext);}


\<(ol)[' '](class)\=\"(comments__list)\"\>              {curr = addnewComment(curr);BEGIN REPLY;}
<REPLY>\<\/ol\>                                         {curr = getCurrentReply(head);BEGIN INITIAL;}
<REPLY>\<(li)[' '](class)\=\"(comment)\"                {BEGIN ID;BEGIN REPLY;}
<REPLY>\<(h5)[' '](class)\=\"(comment__author)\"\>      {BEGIN USER;BEGIN REPLY;}
<REPLY>\<(time)[' '](class)                             {BEGIN TIMESTAMP;BEGIN REPLY;}
<REPLY>\<(div)[' '](class)\=\"(comment__content)\"\>    {BEGIN TEXT;BEGIN REPLY;}
<REPLY>.|\n                                             {;}


.|\n  { ; }
%%




int yywrap()
{ return(1); }

int main()
{ 

yylex();

printf("%d\n",getNumberOfReplies(head));


// para ver comentarios, neste caso o primeiro, up to 50
formatToJSON(getReply(head,0));

// para ver replys a comentarios, neste caso a primeira reply do 7 comentario 
// NEEDS WORK
//formatToJSON(getReply(getReply(head,6),0));  




 return 0; 
}
