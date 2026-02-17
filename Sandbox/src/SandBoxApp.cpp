#include <DotEngine.h>

#include "imgui.h"

class ExampleLayer : public DotEngine::Layer {
public:
	ExampleLayer() : Layer("Example") {}

	void OnUpdate() override
	{
		if (DotEngine::Input::IsKeyPressed(DOTENGINE_KEY_TAB))
			DOTENGINE_TRACE("Tab key is pressed (poll)!");
	}

	void OnImGuiRender() override {
		ImGui::Begin("Test");
		ImGui::Text("Hello World");
		ImGui::End();
	}

	void OnEvent(DotEngine::Event& event) override {
		if (event.GetEventType() == DotEngine::EventType::KeyPressed) {
			const auto& e = dynamic_cast<DotEngine::KeyPressedEvent &>(event);
			DOTENGINE_TRACE("{0}", static_cast<char>(e.GetKeyCode()));
		}
	}
};

class SandBox : public DotEngine::Application {
public:
	SandBox() {
		PushLayer(new ExampleLayer());
	}
	~SandBox() {
	
	}

private:

};

DotEngine::Application* DotEngine::createApplication() {

	return new SandBox(); 

}