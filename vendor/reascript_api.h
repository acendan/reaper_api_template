// Original source code from ReaPack and ReaImGui (LGPL v3)

/* Usage example...
inline std::vector<APIdef> g_apidefs =
{
	{ APIFUNC(NVK_IsFolderItem), "bool", "MediaItem*", "item", "[NVK] Checks if the given item is an NVK Folder Item.", },
	{ APIFUNC(NVK_CountFolderItems), "int", "ReaProject*", "project", "[NVK] Counts the number of NVK Folder Items in a given project. 0 = active project.", },
	{ APIFUNC(NVK_CountFolderItemChildren), "int", "MediaItem*", "folderItem", "[NVK] Counts the number of child items under the given NVK Folder Item.", },
	{ APIFUNC(NVK_CountTrackFolderItems), "int", "MediaTrack*", "track", "[NVK] Counts the number of NVK Folder Items on a given track.", },

	{ NULL, }
};
*/

#pragma once

#include <stdio.h>
#include <vector>

#include "reaper_plugin.h"
#include "reaper_plugin_functions.h"
#include "reascript_vararg.h"

// API registration helpers used by SWS
// https://github.com/reaper-oss/sws/blob/master/ReaScript.cpp

#define APIFUNC(x)  (void*)x,#x,reinterpret_cast<void*>(&InvokeReaScriptAPI<&x>),"APIvararg_" #x "","API_" #x "","APIdef_" #x ""
#define CAPIFUNC(x) (void*)x,#x,NULL,NULL,"API_" #x "",NULL // export to C/C++ only
#ifdef _MSC_VER
#define strdup(p) _strdup(p)
#endif

typedef struct APIdef
{
	void* func;
	const char* func_name;
	void* func_vararg;
	const char* regkey_vararg;
	const char* regkey_func;
	const char* regkey_def;
	const char* ret_val;
	const char* parm_types;

	// if additionnal data are needed, add them below (see top remark)
	const char* parm_names;
	const char* help;
	char* dyn_def; // used for dynamic allocations/cleanups

} APIdef;

// Register exported functions
inline bool RegisterExportedFuncs(reaper_plugin_info_t* _rec, const std::vector<APIdef>& _apidefs)
{
	bool ok = (_rec != NULL);
	int i = -1;
	while (ok && _apidefs[++i].func)
	{
		ok &= (_rec->Register(_apidefs[i].regkey_func, _apidefs[i].func) != 0);
		if (_apidefs[i].regkey_vararg && _apidefs[i].func_vararg)
		{
			ok &= (_rec->Register(_apidefs[i].regkey_vararg, _apidefs[i].func_vararg) != 0);
		}
	}
	return ok;
}

// Unregister exported functions
inline void UnregisterExportedFuncs(const std::vector<APIdef>& _apidefs)
{
	char tmp[512];
	int i = -1;
	while (_apidefs[++i].func)
	{
		snprintf(tmp, sizeof(tmp), "-%s", _apidefs[i].regkey_func);
		plugin_register(tmp, _apidefs[i].func);
	}
}

// Register exported function definitions + help text for the reaper api header and html documentation
inline bool RegisterExportedAPI(reaper_plugin_info_t* _rec, std::vector<APIdef>& _apidefs)
{
	bool ok = (_rec != NULL);
	int i = -1;
	char tmp[8 * 1024];
	while (ok && _apidefs[++i].func)
	{
		if (_apidefs[i].regkey_def)
		{
			memset(tmp, 0, sizeof(tmp));
			snprintf(tmp, sizeof(tmp), "%s\r%s\r%s\r%s", _apidefs[i].ret_val, _apidefs[i].parm_types, _apidefs[i].parm_names, _apidefs[i].help);
			char* p = _apidefs[i].dyn_def = strdup(tmp);
			while (*p) { if (*p == '\r') *p = '\0'; p++; }
			ok &= (_rec->Register(_apidefs[i].regkey_def, _apidefs[i].dyn_def) != 0);
		}
	}
	return ok;
}
