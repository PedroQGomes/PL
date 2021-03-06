%{
#include <commentThread.h>
#include <stdio.h>
#include <glib.h>

 
CommentThread head;
CommentThread curr;
int isreply = 0;

CommentThread giveThread(){
    if(isreply == 0){
        return head;
    }else{
        return curr;
    }

}

%}
acentos \xc3[\x80-\xbf]       
letra [a-zA-Z]|{acentos} 
pL               [a-z]|ç|ã|á|à|â|é|
%x ID USER TIMESTAMP TEXT  

%%

\<(ol)[' '](class)\=\"(comments__list)\"[' '](id)\=\"(approved)\-(comments)\"\> {head = newCommentThread();} 
\<(ol)[' '](class)\=\"(comments__list)\"\>                                      {isreply = 1;}                                          
\<\/ol\>                                                                        {isreply = 0;curr = getCurrentReply(head);}


\<(li)[' '](class)\=\"(comment)\"       {curr = addnewComment(giveThread());BEGIN ID;}
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
<USER>[' '][' '][' ']+                                  {;}
<USER>\<(a)[' '](href)\=\"(.*)\"[' '](rel)\=\"(.*)\"\>  {;}
<USER>\<\/a\>                                           {;}
<USER>.                                                 {setUser(curr,yytext);}


\<(time)[' '](class)\=\"                            {BEGIN TIMESTAMP;}
<TIMESTAMP>\<\/time\>                               {BEGIN INITIAL;}
<TIMESTAMP>[0-9]{2}\:[0-9]{2}\:[0-9]{2}\.[0-9]+     {;}  
<TIMESTAMP>[0-9]{2}\.[0-9]{2}\.[0-9]{4}             {setDate(curr,yytext);} 
<TIMESTAMP>[0-9]{2}\:[0-9]{2}                       {setTimeStamp(curr,yytext);}
<TIMESTAMP>.|\n                                     {;}



\<(div)[' '](class)\=\"(comment__content)\"\>   {BEGIN TEXT;}
<TEXT>\<\/p\>                                   {curr = getCurrentReply(head);BEGIN INITIAL;}
<TEXT>\<p\>                                     {;}
<TEXT>\n                                        {;} 
<TEXT>\"                                        {;} 
<TEXT>[' '][' '][' ']+                          {;}
<TEXT>.                                         {addCommentTxt(curr,yytext);}





.|\n  { ; }
%%




int yywrap()
{ return(1); }

int main()
{ 

yylex();


openFile("output.json");

formatToJsonHead(head);


 return 0; 
}
