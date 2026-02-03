#pragma once

#include <chrono>
#include <format>
#include <string>

#ifdef KR_PLATFORM_WINDOWS

extern Kairon::Application* Kairon::createApplication();

int main(int argc, char** argv) {

	Kairon::Log::Init();
	KR_CORE_WARN("Initialized Log!");

	auto now = std::chrono::floor<std::chrono::seconds>(
		std::chrono::system_clock::now()
	);
	std::string time {std::format("{:%d/%m/%Y %H:%M:%S}", now)};
	KR_INFO("Hello!!!! time: {0}", time.data());

	auto app = Kairon::createApplication();
	app->Run();
	delete app;

	return 0;
}

#elif defined(KR_PLATFORM_MACOS) || defined(KR_PLATFORM_LINUX)

int main(int argc, char** argv) {

	Kairon::Log::Init();
	KR_CORE_WARN("Initialized Log!");

	auto now = std::chrono::floor<std::chrono::seconds>(
		std::chrono::system_clock::now()
	);
	std::string time {std::format("{:%d/%m/%Y %H:%M:%S}", now)};
	KR_INFO("Hello!!!! time: {0}", time.data());

	KR_ERROR("Unsupported platform!!!!");

	return 0;
}

#endif