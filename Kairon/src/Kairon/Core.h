#pragma once

// Platform detection
#if defined(KR_PLATFORM_WINDOWS)
	#if KR_DYNAMIC_LINK
		#ifdef KR_BUILD_DLL
			#define KAIRON_API __declspec(dllexport)
		#else
			#define KAIRON_API __declspec(dllimport)
		#endif
	#else
		#define KAIRON_API
	#endif
	#define KR_DEBUGBREAK() __debugbreak()
#elif defined(KR_PLATFORM_MACOS) || defined(KR_PLATFORM_LINUX)
	#define KAIRON_API
	#if defined(__has_builtin)
		#if __has_builtin(__builtin_debugtrap)
			#define KR_DEBUGBREAK() __builtin_debugtrap()
		#else
			#include <signal.h>
			#define KR_DEBUGBREAK() raise(SIGTRAP)
		#endif
	#else
		#include <signal.h>
		#define KR_DEBUGBREAK() raise(SIGTRAP)
	#endif
#else
	#error Unsupported platform!
#endif

#ifdef KR_DEBUG
	#define KR_ENABLE_ASSERTS
#endif

#ifdef KR_ENABLE_ASSERTS
	#define KR_ASSERT(x, ...) { if(!(x)){ KR_ERROR("Assertion Failed: {0}", __VA_ARGS__); KR_DEBUGBREAK();}}
	#define KR_CORE_ASSERT(x, ...) { if(!(x)){ KR_CORE_ERROR("Assertion Faeiled: {0}", __VA_ARGS__); KR_DEBUGBREAK();}}
#else
	#define KR_ASSERT(x, ...)
	#define KR_CORE_ASSERT(x, ...)
#endif // KR_ENABLE_ASSERTS


#define BIT(X) (1 << X)

#define KR_BIND_EVENT_FN(fn) std::bind(&fn, this, std::placeholders::_1)
