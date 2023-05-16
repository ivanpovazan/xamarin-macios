/* -*- Mode: C; tab-width: 8; indent-tabs-mode: t; c-basic-offset: 8 -*- */
/*
*  Authors: Rolf Bjarne Kvinge
*
*  Copyright (C) 2023 Microsoft Corp.
*
*/

#if defined (NATIVEAOT)

#include <sys/stat.h>
#include <inttypes.h>
#include <pthread.h>
#include <sys/mman.h>
#include <dlfcn.h>

#include "product.h"
#include "runtime-internal.h"
#include "slinked-list.h"
#include "xamarin/xamarin.h"
#include "xamarin/coreclr-bridge.h"

typedef void (*xamarin_runtime_initialize_decl)(struct InitializationOptions* options, GCHandle* exception_gchandle);
void
xamarin_bridge_call_runtime_initialize (struct InitializationOptions* options, GCHandle* exception_gchandle)
{
	void *del = dlsym (RTLD_DEFAULT, "xamarin_objcruntime_runtime_nativeaotinitialize");
	if (del == NULL)
		xamarin_assertion_message ("xamarin_bridge_call_runtime_initialize: failed to load xamarin_objcruntime_runtime_nativeaotinitialize: %s\n", dlerror ());

	xamarin_runtime_initialize_decl runtime_initialize = (xamarin_runtime_initialize_decl) del;
	runtime_initialize (options, exception_gchandle);
}

typedef int (*managed_entry_point)(int argc, const char* argv[]);

int
mono_jit_exec (MonoDomain * domain, MonoAssembly * assembly, int argc, const char** argv)
{
	void *del;
	managed_entry_point app_main;

	del = dlsym (RTLD_DEFAULT, "__managed__Main");
	if (del == NULL)
		xamarin_assertion_message ("mono_jit_exec: failed to load managed_entry_point: %s\n", dlerror ());
	app_main = (managed_entry_point) del;

	return app_main (argc, argv);
}

#endif // NATIVEAOT
