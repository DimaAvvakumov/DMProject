//
//  ServerParams.h
//  formulaEastWind
//
//  Created by Dima Avvakumov on 18.09.13.
//  Copyright (c) 2013 East-Media Ltd. All rights reserved.
//

#ifndef formulaEastWind_ServerParams_h
#define formulaEastWind_ServerParams_h

#define ServerParams_ApiEastMedia @"https://api.east-media.ru"

#define ServerParams_Host @"api.my-domain.ru"
#define ServerParams_URLString @"http://api.my-domain.ru/"
#define ServerParams_BaseURL [NSURL URLWithString: @"http://api.my-domain.ru/"]

// errors block

#define ServerParams_ErrorAuthorizationFailed 1
#define ServerParams_ErrorAccessDeny 2

#define ServerParams_ErrorServerWrongResponse 97
#define ServerParams_ErrorServerIsUnavailable 98
#define ServerParams_ErrorUnknow 99

#define ServerParams_ErrorNoUsername 101
#define ServerParams_ErrorUsernameNotValid 102
#define ServerParams_ErrorUsernameExist 103

#define ServerParams_ErrorLoginFailed 110

#define ServerParams_ErrorChatStartToSelf 201
#define ServerParams_ErrorChatStartThread 202
#define ServerParams_ErrorChatSaveMessage 203
#define ServerParams_ErrorChatRecipientFailed 204

#define ServerParams_ErrorFileManagerCreate 900
#define ServerParams_ErrorFileManagerModify 901

#endif
