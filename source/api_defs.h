// Aaron Cendan, 2023

#include "reascript_api.h"

#include "api.h"

inline std::vector<APIdef> g_apidefs =
{
	{ APIFUNC(API_HelloWorld), "void", "", "", "[API] Prints hello world to the ReaScript console.", },

	{ NULL, }
};
