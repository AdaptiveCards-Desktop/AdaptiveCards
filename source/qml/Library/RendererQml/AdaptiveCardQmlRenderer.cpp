#include "AdaptiveCardQmlRenderer.h"
#include "pch.h"

namespace RendererQml
{
	AdaptiveCardQmlRenderer::AdaptiveCardQmlRenderer()
		: AdaptiveCardQmlRenderer(std::make_shared<AdaptiveCards::HostConfig>())
	{
	}

	AdaptiveCardQmlRenderer::AdaptiveCardQmlRenderer(std::shared_ptr<AdaptiveCards::HostConfig> hostConfig)
		: AdaptiveCardsRendererBase(AdaptiveCards::SemanticVersion("1.2"))
	{
		SetObjectTypes();
		SetHostConfig(hostConfig);
	}

	std::shared_ptr<RenderedQmlAdaptiveCard> AdaptiveCardQmlRenderer::RenderCard(std::shared_ptr<AdaptiveCards::AdaptiveCard> card, AdaptiveCardDependency::OnClickFunction onClick)
	{
		std::shared_ptr<RenderedQmlAdaptiveCard> output;
		auto context = std::make_shared<AdaptiveRenderContext>(GetHostConfig(), GetElementRenderers());
		context->SetOnClickFunction(onClick);
		std::shared_ptr<QmlTag> tag;

		try
		{
			context->SetLang(card->GetLanguage());
			tag = context->Render(card, &AdaptiveCardRender);
			output = std::make_shared<RenderedQmlAdaptiveCard>(tag, card, context->GetWarnings());
		}
		catch (const std::exception & e)
		{
			context->AddWarning(AdaptiveWarning(Code::RenderException, e.what()));
		}

		return output;
	}

    void AdaptiveCardQmlRenderer::AddContainerElements(std::shared_ptr<QmlTag> uiContainer, const std::vector<std::shared_ptr<AdaptiveCards::BaseCardElement>>& elements, std::shared_ptr<AdaptiveRenderContext> context)
    {
        if (!elements.empty())
        {
            auto bodyLayout = std::make_shared<QmlTag>("Column");
            bodyLayout->Property("id", "bodyLayout");
            bodyLayout->Property("width", "parent.width");
            //TODO: Set spacing from host config
            bodyLayout->Property("spacing", "8");
            uiContainer->Property("Layout.preferredHeight", "bodyLayout.height");
            uiContainer->AddChild(bodyLayout);

            for (const auto& cardElement : elements)
            {
                auto uiElement = context->Render(cardElement);

                if (uiElement != nullptr)
                {
                    //TODO: Add separator
                    //TODO: Add collection element
                    bodyLayout->AddChild(uiElement);
                }
            }
        }
    }

    void AdaptiveCardQmlRenderer::SetObjectTypes()
    {
        (*GetElementRenderers()).Set<AdaptiveCards::TextBlock>(AdaptiveCardQmlRenderer::TextBlockRender);
        (*GetElementRenderers()).Set<AdaptiveCards::RichTextBlock>(AdaptiveCardQmlRenderer::RichTextBlockRender);
        /*(*GetElementRenderers()).Set<AdaptiveCards::Image>(AdaptiveCardQmlRenderer::ImageRender);
        (*GetElementRenderers()).Set<AdaptiveCards::Media>(AdaptiveCardQmlRenderer::MediaRender);
        (*GetElementRenderers()).Set<AdaptiveCards::Container>(AdaptiveCardQmlRenderer::ContainerRender);
        (*GetElementRenderers()).Set<AdaptiveCards::Column>(AdaptiveCardQmlRenderer::ColumnRender);
        (*GetElementRenderers()).Set<AdaptiveCards::ColumnSet>(AdaptiveCardQmlRenderer::ColumnSetRender);
        (*GetElementRenderers()).Set<AdaptiveCards::FactSet>(AdaptiveCardQmlRenderer::FactSetRender);
        (*GetElementRenderers()).Set<AdaptiveCards::ImageSet>(AdaptiveCardQmlRenderer::ImageSetRender);
        (*GetElementRenderers()).Set<AdaptiveCards::ActionSet>(AdaptiveCardQmlRenderer::ActionSetRender);
        (*GetElementRenderers()).Set<AdaptiveCards::ChoiceSetInput>(AdaptiveCardQmlRenderer::ChoiceSetRender);*/
        (*GetElementRenderers()).Set<AdaptiveCards::TextInput>(AdaptiveCardQmlRenderer::TextInputRender);
        (*GetElementRenderers()).Set<AdaptiveCards::NumberInput>(AdaptiveCardQmlRenderer::NumberInputRender);
        /*(*GetElementRenderers()).Set<AdaptiveCards::DateInput>(AdaptiveCardQmlRenderer::DateInputRender);
        (*GetElementRenderers()).Set<AdaptiveCards::TimeInput>(AdaptiveCardQmlRenderer::TimeInputRender);*/
        (*GetElementRenderers()).Set<AdaptiveCards::ToggleInput>(AdaptiveCardQmlRenderer::ToggleInputRender);
        /*(*GetElementRenderers()).Set<AdaptiveCards::SubmitAction>(AdaptiveCardQmlRenderer::AdaptiveActionRender);
        (*GetElementRenderers()).Set<AdaptiveCards::OpenUrlAction>(AdaptiveCardQmlRenderer::AdaptiveActionRender);
        (*GetElementRenderers()).Set<AdaptiveCards::ShowCardAction>(AdaptiveCardQmlRenderer::AdaptiveActionRender);
        (*GetElementRenderers()).Set<AdaptiveCards::ToggleVisibilityAction>(AdaptiveCardQmlRenderer::AdaptiveActionRender);
        (*GetElementRenderers()).Set<AdaptiveCards::SubmitAction>(AdaptiveCardQmlRenderer::AdaptiveActionRender);*/
    }

    std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::AdaptiveCardRender(std::shared_ptr<AdaptiveCards::AdaptiveCard> card, std::shared_ptr<AdaptiveRenderContext> context)
    {
        auto uiCard = std::make_shared<QmlTag>("Rectangle");
        uiCard->AddImports("import QtQuick 2.15");
        uiCard->AddImports("import QtQuick.Layouts 1.3");
        uiCard->AddImports("import QtQuick.Controls 2.15");
        uiCard->AddImports("import QtGraphicalEffects 1.15");
        uiCard->Property("id", "adaptiveCard");
        uiCard->Property("implicitHeight", "adaptiveCardLayout.implicitHeight");
        //TODO: Width can be set as config
        uiCard->Property("width", "600");

		auto columnLayout = std::make_shared<QmlTag>("ColumnLayout");
		columnLayout->Property("id", "adaptiveCardLayout");
		columnLayout->Property("width", "parent.width");
		uiCard->AddChild(columnLayout);

		auto rectangle = std::make_shared<QmlTag>("Rectangle");
		rectangle->Property("id", "adaptiveCardRectangle");
		rectangle->Property("color", context->GetRGBColor(context->GetConfig()->GetContainerStyles().defaultPalette.backgroundColor));
		rectangle->Property("Layout.margins", std::to_string(context->GetConfig()->GetSpacing().paddingSpacing));
		rectangle->Property("Layout.fillWidth", "true");
		rectangle->Property("Layout.preferredHeight", "40");

		if (card->GetMinHeight() > 0)
		{
			rectangle->Property("Layout.minimumHeight", std::to_string(card->GetMinHeight()));
		}
		columnLayout->AddChild(rectangle);

        //TODO: Add card vertical content alignment

		AddContainerElements(rectangle, card->GetBody(), context);

		return uiCard;
	}

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::TextBlockRender(std::shared_ptr<AdaptiveCards::TextBlock> textBlock, std::shared_ptr<AdaptiveRenderContext> context)
	{
		//TODO:Parse markdown in the text

		//TODO: To get the Qml equivalant of monospace fontType and add it to config
		std::string fontFamily = context->GetConfig()->GetFontFamily(textBlock->GetFontType());
		int fontSize = context->GetConfig()->GetFontSize(textBlock->GetFontType(), textBlock->GetTextSize());
		
		auto uiTextBlock = std::make_shared<QmlTag>("Text");
		std::string textType = textBlock->GetElementTypeString();
		std::string horizontalAlignment = AdaptiveCards::EnumHelpers::getHorizontalAlignmentEnum().toString(textBlock->GetHorizontalAlignment());

		uiTextBlock->Property("width", "parent.width");
		uiTextBlock->Property("elide", "Text.ElideRight");
		uiTextBlock->Property("text", "\"" + textBlock->GetText() + "\"");

		uiTextBlock->Property("horizontalAlignment", Utils::GetHorizontalAlignment(horizontalAlignment));

        //TODO: Need to fix the color calculation
		std::string color = context->GetColor(textBlock->GetTextColor(), textBlock->GetIsSubtle(), false);
		
		uiTextBlock->Property("color", color);

		//Value based on what is mentioned in the html renderer
		uiTextBlock->Property("lineHeight", "1.33");

		uiTextBlock->Property("font.pixelSize", std::to_string(fontSize));

		//TODO: lighter weight showing same behaviour as default
		uiTextBlock->Property("font.weight", Utils::GetWeight(textBlock->GetTextWeight()));

		if (!textBlock->GetId().empty())
		{
			uiTextBlock->Property("id", textBlock->GetId());
		}

		if (!textBlock->GetIsVisible())
		{
			uiTextBlock->Property("visible", "false");
		}

		if (textBlock->GetMaxLines() > 0)
		{
			uiTextBlock->Property("maximumLineCount", std::to_string(textBlock->GetMaxLines()));
		}

		if (textBlock->GetWrap())
		{
			uiTextBlock->Property("wrapMode", "Text.WordWrap");
		}

		if (!fontFamily.empty())
		{
			uiTextBlock->Property("font.family", fontFamily);
		}

		return uiTextBlock;

	}

    std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::TextInputRender(std::shared_ptr<AdaptiveCards::TextInput> input, std::shared_ptr<AdaptiveRenderContext> context)
    {
        //TODO: Add inline action

        std::shared_ptr<QmlTag> uiTextInput;
        std::shared_ptr<QmlTag> scrollViewTag;        

        if (input->GetIsMultiline())
        {
            scrollViewTag = std::make_shared<QmlTag>("ScrollView");
            scrollViewTag->Property("width", "parent.width");
            scrollViewTag->Property("height", "50");
            scrollViewTag->Property("ScrollBar.vertical.interactive", "true");

            uiTextInput = std::make_shared<QmlTag>("TextArea");
            uiTextInput->Property("id", input->GetId());
            uiTextInput->Property("wrapMode", "Text.Wrap");
            uiTextInput->Property("padding", "10");

            if (input->GetMaxLength() > 0)
            {
                uiTextInput->Property("onTextChanged", Formatter() << "remove(" << input->GetMaxLength() << ", length)");
            }

            scrollViewTag->AddChild(uiTextInput);
        }
        else
        {
            uiTextInput = std::make_shared<QmlTag>("TextField");
            uiTextInput->Property("id", input->GetId());
            uiTextInput->Property("width", "parent.width");

            if (input->GetMaxLength() > 0)
            {
                uiTextInput->Property("maximumLength", std::to_string(input->GetMaxLength()));
            }
        }
        
        uiTextInput->Property("font.pixelSize", std::to_string(context->GetConfig()->GetFontSize(AdaptiveSharedNamespace::FontType::Default, AdaptiveSharedNamespace::TextSize::Default)));

        auto glowTag = std::make_shared<QmlTag>("Glow");
        glowTag->Property("samples", "25");
        glowTag->Property("color", "'skyblue'");

        auto backgroundTag = std::make_shared<QmlTag>("Rectangle");
        backgroundTag->Property("radius", "5");
        //TODO: These color styling should come from css
        backgroundTag->Property("color", Formatter() << input->GetId() <<".hovered ? 'lightgray' : 'white'");
        backgroundTag->Property("border.color", Formatter() << input->GetId() << ".activeFocus? 'black' : 'grey'");
        backgroundTag->Property("border.width", "1");
        backgroundTag->Property("layer.enabled", Formatter() << input->GetId() << ".activeFocus ? true : false");
        backgroundTag->Property("layer.effect", glowTag->ToString());
        uiTextInput->Property("background", backgroundTag->ToString());

        if (!input->GetValue().empty())
        {
            uiTextInput->Property("text", "\"" + input->GetValue() + "\"");
        }

        if (!input->GetPlaceholder().empty())
        {
            uiTextInput->Property("placeholderText", "\"" + input->GetPlaceholder() + "\"");
        }

        //TODO: Add stretch property

        if (!input->GetIsVisible())
        {
            uiTextInput->Property("visible", "false");
        }

        if (input->GetIsMultiline())
        {
            return scrollViewTag;
        }

        return uiTextInput;
    }

    std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::NumberInputRender(std::shared_ptr<AdaptiveCards::NumberInput> input, std::shared_ptr<AdaptiveRenderContext> context)
    {
        const auto inputId = input->GetId();

        auto glowTag = std::make_shared<QmlTag>("Glow");
        glowTag->Property("samples", "25");
        glowTag->Property("color", "'skyblue'");

        auto backgroundTag = std::make_shared<QmlTag>("Rectangle");
        backgroundTag->Property("radius", "5");
        //TODO: These color styling should come from css
        backgroundTag->Property("color", Formatter() << inputId + "_contentItem" << ".hovered ? 'lightgray' : 'white'");
        backgroundTag->Property("layer.enabled", Formatter() << inputId + "_contentItem" << ".activeFocus ? true : false");
        backgroundTag->Property("layer.effect", glowTag->ToString());

        auto contentItemTag = std::make_shared<QmlTag>("TextField");
        contentItemTag->Property("id", inputId + "_contentItem");
        contentItemTag->Property("padding", "10");
        contentItemTag->Property("font.pixelSize", std::to_string(context->GetConfig()->GetFontSize(AdaptiveSharedNamespace::FontType::Default, AdaptiveSharedNamespace::TextSize::Default)));
        contentItemTag->Property("readOnly", Formatter() << "!" << inputId << ".editable");
        contentItemTag->Property("validator", Formatter() << inputId << ".validator");
        contentItemTag->Property("inputMethodHints", "Qt.ImhFormattedNumbersOnly");
        contentItemTag->Property("text", Formatter() << inputId << ".textFromValue(" << inputId << ".value, " << inputId << ".locale)");
        if (!input->GetPlaceholder().empty())
        {
            contentItemTag->Property("placeholderText", "\"" + input->GetPlaceholder() + "\"");
        }
        contentItemTag->Property("background", backgroundTag->ToString());

        auto doubleValidatorTag = std::make_shared<QmlTag>("DoubleValidator");

        auto uiNumberInput = std::make_shared<QmlTag>("SpinBox");
        uiNumberInput->Property("id", input->GetId());
        uiNumberInput->Property("width", "parent.width");
        uiNumberInput->Property("stepSize", "1");
        uiNumberInput->Property("editable", "true");
        uiNumberInput->Property("validator", doubleValidatorTag->ToString());

        if ((input->GetMin() == input->GetMax() && input->GetMin() == 0) || input->GetMin() > input->GetMax())
        {
            input->SetMin(INT_MIN);
            input->SetMax(INT_MAX);
        }
        if (input->GetValue() < input->GetMin())
        {
            input->SetValue(input->GetMin());
        }
        if (input->GetValue() > input->GetMax())
        {
            input->SetValue(input->GetMax());
        }

        uiNumberInput->Property("from", std::to_string(input->GetMin().value()));
        uiNumberInput->Property("to", std::to_string(input->GetMax().value()));
        uiNumberInput->Property("value", std::to_string(input->GetValue().value()));

        //TODO: Add stretch property

        if (!input->GetIsVisible())
        {
            uiNumberInput->Property("visible", "false");
        }

        uiNumberInput->Property("contentItem", contentItemTag->ToString());

        return uiNumberInput;
    }

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::RichTextBlockRender(std::shared_ptr<AdaptiveCards::RichTextBlock> richTextBlock, std::shared_ptr<AdaptiveRenderContext> context)
	{
		auto uiTextBlock = std::make_shared<QmlTag>("Text");
		std::string textType = richTextBlock->GetElementTypeString();
		std::string horizontalAlignment = AdaptiveCards::EnumHelpers::getHorizontalAlignmentEnum().toString(richTextBlock->GetHorizontalAlignment());

		uiTextBlock->Property("textFormat", "Text.RichText");
		uiTextBlock->Property("wrapMode", "Text.WordWrap");
		uiTextBlock->Property("width", "parent.width");

		uiTextBlock->Property("horizontalAlignment", Utils::GetHorizontalAlignment(horizontalAlignment));
		std::string textrun_all = "\"";

		if (!richTextBlock->GetIsVisible())
		{
			uiTextBlock->Property("visible", "false");
		}

		for (const auto& inlineRun : richTextBlock->GetInlines())
		{
			if (Utils::IsInstanceOfSmart<AdaptiveCards::TextRun>(inlineRun))
			{
				auto textRun = std::dynamic_pointer_cast<AdaptiveCards::TextRun>(inlineRun);
				textrun_all.append(TextRunRender(textRun, context));
			}
		}
		textrun_all = textrun_all.append("\"");
		uiTextBlock->Property("text", textrun_all);

		return uiTextBlock;

	}
	
	std::string AdaptiveCardQmlRenderer::TextRunRender(std::shared_ptr<AdaptiveCards::TextRun> textRun, std::shared_ptr<AdaptiveRenderContext> context)
	{
		const std::string fontFamily = context->GetConfig()->GetFontFamily(textRun->GetFontType());
		const int fontSize = context->GetConfig()->GetFontSize(textRun->GetFontType(), textRun->GetTextSize());
		const int weight = context->GetConfig()->GetFontWeight(textRun->GetFontType(), textRun->GetTextWeight());

		//Value based on what is mentioned in the html renderer
		const auto lineHeight = fontSize * 1.33;

		std::string uiTextRun = "<span style='";
		std::string textType = textRun->GetInlineTypeString();

		//TODO: Add font to hostconfig
		uiTextRun.append("font-family:" + std::string("\\\"") + fontFamily + std::string("\\\"") + ";");

		//TODO: Need to fix the color calculation
		std::string color = context->GetColor(textRun->GetTextColor(), textRun->GetIsSubtle(), false).substr(3);
		uiTextRun.append("color:" + color + ";");

		std::string lineheight = Formatter() << std::fixed << std::setprecision(2) << lineHeight << "px";
		uiTextRun.append("line-height:" + lineheight + ";");

		uiTextRun.append("font-size:" + std::to_string(fontSize) + "px" + ";");

		uiTextRun.append("font-weight:" + std::to_string(weight) + ";");

		//TODO: Exact calculation for background color
		if (textRun->GetHighlight())
		{
			uiTextRun.append("background-color:" + Utils::GetTextHighlightColor(color) + ";");
		}

		if (textRun->GetItalic())
		{
			uiTextRun.append("font-style:" + std::string("italic") + ";");
		}

		if (textRun->GetStrikethrough())
		{
			uiTextRun.append("text-decoration:" + std::string("line-through") + ";");
		}

		uiTextRun.append("'>");
		uiTextRun.append(TextUtils::ApplyTextFunctions(textRun->GetText(), context->GetLang()));
		uiTextRun.append("</span>");

		return uiTextRun;
	}

	std::shared_ptr<QmlTag> AdaptiveCardQmlRenderer::ToggleInputRender(std::shared_ptr<AdaptiveCards::ToggleInput> input, std::shared_ptr<AdaptiveRenderContext> context)
	{
		auto uiCheckboxInput = std::make_shared<QmlTag>("CheckBox");

		const auto valueOn = !input->GetValueOn().empty() ? input->GetValueOn() : "True";
		const auto valueOff = !input->GetValueOff().empty() ? input->GetValueOff() : "False";
		const auto id = input->GetId();

		uiCheckboxInput->Property("readonly property string valueOn", "\"" + valueOn + "\"");
		uiCheckboxInput->Property("readonly property string valueOff", "\"" + valueOff + "\"");
		uiCheckboxInput->Property("id", id);
		uiCheckboxInput->Property("text", "\"" + input->GetTitle() + "\"");
		uiCheckboxInput->Property("width", "parent.width");

		auto uiOuterRectangle = std::make_shared<QmlTag>("Rectangle");
		uiOuterRectangle->Property("implicitWidth", "26");
		uiOuterRectangle->Property("implicitHeight", "26");
		uiOuterRectangle->Property("x", id + ".leftPadding");
		uiOuterRectangle->Property("y", "parent.height / 2 - height / 2");
		uiOuterRectangle->Property("radius", "3");
		uiOuterRectangle->Property("border.color", id + ".checkState === Qt.Checked ? '#0075FF' : '767676'");

		//To be replaced with image of checkmark.
		auto uiInnerRectangle = std::make_shared<QmlTag>("Rectangle");
		uiInnerRectangle->Property("width", "14");
		uiInnerRectangle->Property("height", "14");
		uiInnerRectangle->Property("x", "6");
		uiInnerRectangle->Property("y", "6");
		uiInnerRectangle->Property("radius", "2");
		uiInnerRectangle->Property("color", id + ".down ? '#ffffff' : '#0075FF'");
		uiInnerRectangle->Property("visible", id + ".checked");

		uiOuterRectangle->AddChild(uiInnerRectangle);

		uiCheckboxInput->Property("indicator", uiOuterRectangle->ToString());

		auto uiLabel = std::make_shared<QmlTag>("Label");
		uiLabel->Property("text", id + ".text");
		uiLabel->Property("font", id + ".font");
		uiLabel->Property("horizontalAlignment", "Text.AlignLeft");
		uiLabel->Property("verticalAlignment", "Text.AlignVCenter");
		uiLabel->Property("leftPadding", id + ".indicator.width + " + id + ".spacing");
	
		uiCheckboxInput->Property("contentItem", uiLabel->ToString());

		if (input->GetValue().compare(valueOn))
		{
			uiCheckboxInput->Property("checked", "true");
		}

		if (!input->GetIsVisible())
		{
			uiCheckboxInput->Property("visible", "false");
		}
		//TO DO - height 
		
		return uiCheckboxInput;
	}



}

