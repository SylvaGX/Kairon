#pragma once

#include "DotEngine/Layer.h"

#include "DotEngine/Events/ApplicationEvent.h"
#include "DotEngine/Events/KeyEvent.h"
#include "DotEngine/Events/MouseEvent.h"

namespace DotEngine {

	class DOTENGINE_API ImGuiLayer : public Layer {
	public:
		ImGuiLayer();
		~ImGuiLayer();

		virtual void OnAttach() override;
		virtual void OnDetach() override;
		virtual void OnImGuiRender() override;

		void Begin();
		void End();
	private:
		float m_Time = 0.0f;
	};
}