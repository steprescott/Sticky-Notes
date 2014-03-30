//
//  Constants.h
//  Sticky Notes
//
//  Created by Ste Prescott on 04/02/2014.
//  Copyright (c) 2014 ste.me. All rights reserved.
//

#ifndef Sticky_Notes_Constants_h
#define Sticky_Notes_Constants_h

#define kBaseURL @"http://stickyapi.alanedwardes.com/"

#define kLogin @"user/login"
#define kRegister @"user/register"
#define kUpdateUser @"user/editDetails"

#define kGetBoards @"boards/list" 
#define kUploadBoards @"boards/save" 
#define kDeleteBoard @"boards/delete"
#define kLeaveBoard @"/boards/leave"
#define kUsersForBoard @"/board/getUsers"
#define kInviteUserToBoard @"/board/addUser"

#define kGetNotes @"notes/list"
#define kUploadNewNote @"notes/save"
#define kUpdateNote @"notes/edit"
#define kDeleteNote @"notes/delete"

#endif
