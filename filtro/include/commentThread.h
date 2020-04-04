#ifndef commentThread_h
#define commentThread_h

typedef struct commentThread *CommentThread;

CommentThread newCommentThread();
void freeCommentThread(CommentThread c);


void setID(CommentThread c,char* s);
void setUser(CommentThread c,char* s);
void setDate(CommentThread c,char* s);
void setTimeStamp(CommentThread c,char* t);
void addCommentTxt(CommentThread c,char* s);
<<<<<<< HEAD
void addLikes(CommentThread c,char* s);
=======
void addLikes(CommentThread c,char * l);
>>>>>>> 26153cb6a34896ab1e5a8457f40fe7cc40ca11e9
void setHasReplaiesTRUE(CommentThread c);
void addNumberOfReplies(CommentThread c,int r);
void addReplieToList(CommentThread c,CommentThread r);
void formatToJSON(CommentThread c);
CommentThread addnewComment(CommentThread head);
int getNumberOfReplies(CommentThread c);
CommentThread getReply(CommentThread c,int p);
CommentThread getCurrentReply(CommentThread c);


#endif