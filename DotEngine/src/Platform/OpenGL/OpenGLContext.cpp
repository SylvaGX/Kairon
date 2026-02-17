#include "detpch.h"
#include "OpenGLContext.h"

#include <GLFW/glfw3.h>
#include <glad/glad.h>

namespace DotEngine {

	OpenGLContext::OpenGLContext(GLFWwindow* windowHandle)
		:m_WindowHandle(windowHandle)
	{
		DOTENGINE_CORE_ASSERT(windowHandle, "Window handle is null!");
	}

	void OpenGLContext::Init()
	{
		glfwMakeContextCurrent(m_WindowHandle);
		int status = gladLoadGLLoader((GLADloadproc)glfwGetProcAddress);
		DOTENGINE_CORE_ASSERT(status, "Failed to initialize Glad!");

		DOTENGINE_CORE_INFO("OpenGL Info:");
		DOTENGINE_CORE_INFO("  Vendor: {0}", glGetString(GL_VENDOR));
		DOTENGINE_CORE_INFO("  Renderer: {0}", glGetString(GL_RENDERER));
		DOTENGINE_CORE_INFO("  Version: {0}", glGetString(GL_VERSION));
	}

	void OpenGLContext::SwapBuffers()
	{
		glfwSwapBuffers(m_WindowHandle);
	}

}