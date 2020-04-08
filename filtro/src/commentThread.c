#include <glib.h>
#include <stdio.h>
#include <string.h>
#include <commentThread.h>

#define REPLYSPACE 10
#define COMMENTSPACE 5



typedef struct commentThread {

    GString * id;
    GString * user;
    GString * date;
    GString * timestamp; 
    GString * comentTxt; 
    int hasReplies;
    int numberOfReplies;
    CommentThread replies[]; 
}*CommentThread;


FILE* fp;

CommentThread newCommentThread(){
    CommentThread ct = malloc(sizeof(struct commentThread));
    ct->id = g_string_new("");
    ct->user = g_string_new("");
    ct->date = g_string_new("");
    ct->timestamp = g_string_new(""); 
    ct->comentTxt = g_string_new("");
    ct->hasReplies = FALSE;
    ct->numberOfReplies = 0; 
    //ct->replies
    return ct;
}



void freeCommentThread(CommentThread c){
    g_string_free(c->id,TRUE);
    g_string_free(c->user,TRUE);
    g_string_free(c->date,TRUE);
    g_string_free(c->timestamp,TRUE);
    g_string_free(c->comentTxt,TRUE);
    c->hasReplies = FALSE;
    c->numberOfReplies = 0;
    //g_list_free(c->replies);


}


void setID(CommentThread c,char* s){
    g_string_append(c->id,s);


}

void setUser(CommentThread c,char* s){
    
    g_string_append(c->user,s);


}
void setDate(CommentThread c,char* s){
    g_string_append(c->date,s);

}

void setTimeStamp(CommentThread c,char* t){
    g_string_append(c->timestamp,t);
}

void addCommentTxt(CommentThread c,char* s){
    g_string_append(c->comentTxt,s);

}



void setHasReplaiesTRUE(CommentThread c){
    c->hasReplies = TRUE;
}

void addNumberOfReplies(CommentThread c,int r){
    c->numberOfReplies += r;
}


void openFile(char * f){
    fp = fopen(f,"w+");
}


void formatToJsonHead(CommentThread c){
    fputs("\"commentThread\" : [\n",fp);
    for(int i = 0; i < c->numberOfReplies;i++){
        fputs("{\n",fp);
        formatToJSON(c->replies[i]);
        if(i < c->numberOfReplies-1)
        fputs("},\n",fp);
        else 
        fputs("}\n",fp);
    }
    fputs("]\n",fp);

}

GString* addSpacesToString(int spaces, GString* str ) {
    for(int i=0; i < spaces; i++)
    g_string_prepend_c(str,' ');
}



void formatToJSON(CommentThread c){
    char *cat;

    cat = g_string_free(c->id, FALSE);
    fputs("     \"id\" : \"",fp);
    fputs(cat,fp);
    fputs("\"\n",fp);
    
    cat = g_string_free(c->user, FALSE);
    fputs("     \"user\" : \"",fp);
    fputs(cat,fp);
    fputs("\"\n",fp);

    cat = g_string_free(c->date, FALSE);
    fputs("     \"data\" : \"",fp);
    fputs(cat,fp);
    fputs("\"\n",fp);

    cat = g_string_free(c->timestamp, FALSE);
    fputs("     \"hora\" : \"",fp);
    fputs(cat,fp);
    fputs("\"\n",fp);

    cat = g_string_free(c->comentTxt, FALSE);
    fputs("     \"comment\" : \"",fp);
    fputs(cat,fp);
    fputs("\"\n",fp);


    fputs("     \"Nº respostas\" : \"",fp);
    fprintf(fp,"%d",c->numberOfReplies);
    fputs("\"\n",fp);


    fputs("     \"reply\" : [ ",fp);
    for(int i = 0; i < c->numberOfReplies;i++){
        fputs("\n",fp);
        fputs("             {\n",fp);
        ReplyToJSON(c->replies[i]);
        if(i < c->numberOfReplies-1)
        fputs("             },",fp);
        else 
        fputs("             }\n",fp);
    }
    fputs("     ] \n",fp);
    fputs("\n",fp);
    fputs("\n",fp);
}

void ReplyToJSON(CommentThread c){
    char *cat;

    cat = g_string_free(c->id, FALSE);
    fputs("             \"id\" : \"",fp);
    fputs(cat,fp);
    fputs("\"\n",fp);
    
    cat = g_string_free(c->user, FALSE);
    fputs("             \"user\" : \"",fp);
    fputs(cat,fp);
    fputs("\"\n",fp);

    cat = g_string_free(c->date, FALSE);
    fputs("             \"data\" : \"",fp);
    fputs(cat,fp);
    fputs("\"\n",fp);

    cat = g_string_free(c->timestamp, FALSE);
    fputs("             \"hora\" : \"",fp);
    fputs(cat,fp);
    fputs("\"\n",fp);

    cat = g_string_free(c->comentTxt, FALSE);
    fputs("             \"comment\" : \"",fp);
    fputs(cat,fp);
    fputs("\"\n",fp);




    fputs("             \"Nº respostas\" : \"",fp);
    fprintf(fp,"%d",c->numberOfReplies);
    fputs("\"\n",fp);

    fputs("             \"reply\" : [ ",fp);
    for(int i = 0; i < c->numberOfReplies;i++){
        fputs("\n",fp);
        fputs("             {\n",fp);
        ReplyToJSON(c->replies[i]);
        if(i < c->numberOfReplies-1)
        fputs("             },",fp);
        else 
        fputs("             }\n",fp);
    }
    fputs("     ] \n",fp);
    fputs("\n",fp);
    fputs("\n",fp);



}





CommentThread addnewComment(CommentThread head){
    head->hasReplies = TRUE;
    head->replies[head->numberOfReplies] = newCommentThread();
    CommentThread curr = head->replies[head->numberOfReplies];

    head->numberOfReplies++;

    return curr;

}



int getNumberOfReplies(CommentThread c){
    return c->numberOfReplies;


}

CommentThread getReply(CommentThread c,int p){
    return c->replies[p];


}

CommentThread getCurrentReply(CommentThread c){
    int tmp = c->numberOfReplies - 1 ;
    return c->replies[tmp];

}










