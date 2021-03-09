#pragma once
#include "stdafx.h"

namespace LightConfig
{
    const std::string lightConfig = R"({
    "hostCapabilities": {
        "capabilities": null
    },
    "choiceSetInputValueSeparator": ",",
    "supportsInteractivity": true,
    "fontFamily": "CiscoSans",
    "spacing": {
        "small": 4,
        "default": 12,
        "medium": 12,
        "large": 12,
        "extraLarge": 16,
        "padding": 12
    },
    "separator": {
        "lineThickness": 1,
        "lineColor": "#EEEEEE"
    },
    "fontSizes": {
        "small": 12,
        "default": 14,
        "medium": 16,
        "large": 20,
        "extraLarge": 22
    },
    "fontWeights": {
        "lighter": 300,
        "default": 400,
        "bolder": 600
    },
    "imageSizes": {
        "small": 40,
        "medium": 80,
        "large": 160
    },
    "containerStyles": {
        "default": {
            "foregroundColors": {
                "default": {
                    "default": "#171B1F",
                    "subtle": "#535759"
                },
                "dark": {
                    "default": "#171B1F",
                    "subtle": "#535759"
                },
                "light": {
                    "default": "#535759",
                    "subtle": "#929596"
                },
                "accent": {
                    "default": "#007EA8",
                    "subtle": "#00A0D1"
                },
                "good": {
                    "default": "#1B8728",
                    "subtle": "#24AB31"
                },
                "warning": {
                    "default": "#D93829",
                    "subtle": "#FF5C4A"
                },
                "attention": {
                    "default": "#C74F0E",
                    "subtle": "#F26B1D"
                }
            },
            "backgroundColor": "#FFFFFF"
        },
        "emphasis": {
            "foregroundColors": {
                "default": {
                    "default": "#171B1F",
                    "subtle": "#535759"
                },
                "dark": {
                    "default": "#171B1F",
                    "subtle": "#535759"
                },
                "light": {
                    "default": "#383C40",
                    "subtle": "#737678"
                },
                "accent": {
                    "default": "#007EA8",
                    "subtle": "#00A0D1"
                },
                "good": {
                    "default": "#1B8728",
                    "subtle": "#24AB31"
                },
                "warning": {
                    "default": "#D93829",
                    "subtle": "#FF5C4A"
                },
                "attention": {
                    "default": "#C74F0E",
                    "subtle": "#F26B1D"
                }
            },
            "backgroundColor": "#F2F4F5"
        },
        "good": {
            "foregroundColors": {
                "default": {
                    "default": "#171B1F",
                    "subtle": "#535759"
                },
                "dark": {
                    "default": "#171B1F",
                    "subtle": "#535759"
                },
                "light": {
                    "default": "#535759",
                    "subtle": "#929596"
                },
                "accent": {
                    "default": "#007EA8",
                    "subtle": "#00A0D1"
                },
                "good": {
                    "default": "#1B8728",
                    "subtle": "#24AB31"
                },
                "warning": {
                    "default": "#D93829",
                    "subtle": "#FF5C4A"
                },
                "attention": {
                    "default": "#C74F0E",
                    "subtle": "#F26B1D"
                }
            },
            "backgroundColor": "#E8FAE9"
        },
        "accent": {
            "foregroundColors": {
                "default": {
                    "default": "#171B1F",
                    "subtle": "#535759"
                },
                "dark": {
                    "default": "#171B1F",
                    "subtle": "#535759"
                },
                "light": {
                    "default": "#535759",
                    "subtle": "#929596"
                },
                "accent": {
                    "default": "#007EA8",
                    "subtle": "#00A0D1"
                },
                "good": {
                    "default": "#1B8728",
                    "subtle": "#24AB31"
                },
                "warning": {
                    "default": "#D93829",
                    "subtle": "#FF5C4A"
                },
                "attention": {
                    "default": "#C74F0E",
                    "subtle": "#F26B1D"
                }
            },
            "backgroundColor": "#E6F9FC"
        },
        "warning": {
            "foregroundColors": {
                "default": {
                    "default": "#171B1F",
                    "subtle": "#535759"
                },
                "dark": {
                    "default": "#171B1F",
                    "subtle": "#535759"
                },
                "light": {
                    "default": "#535759",
                    "subtle": "#929596"
                },
                "accent": {
                    "default": "#007EA8",
                    "subtle": "#00A0D1"
                },
                "good": {
                    "default": "#1B8728",
                    "subtle": "#24AB31"
                },
                "warning": {
                    "default": "#D93829",
                    "subtle": "#FF5C4A"
                },
                "attention": {
                    "default": "#C74F0E",
                    "subtle": "#F26B1D"
                }
            },
            "backgroundColor": "#FFE1D9"
        },
        "attention": {
            "foregroundColors": {
                "default": {
                    "default": "#171B1F",
                    "subtle": "#535759"
                },
                "dark": {
                    "default": "#171B1F",
                    "subtle": "#535759"
                },
                "light": {
                    "default": "#535759",
                    "subtle": "#929596"
                },
                "accent": {
                    "default": "#007EA8",
                    "subtle": "#00A0D1"
                },
                "good": {
                    "default": "#1B8728",
                    "subtle": "#24AB31"
                },
                "warning": {
                    "default": "#D93829",
                    "subtle": "#FF5C4A"
                },
                "attention": {
                    "default": "#C74F0E",
                    "subtle": "#F26B1D"
                }
            },
            "backgroundColor": "#FCF4E1"
        }
    },
    "actions": {
        "maxActions": 5,
        "buttonSpacing": 8,
        "showCard": {
            "actionMode": "Inline",
            "inlineTopMargin": 8,
            "style": "emphasis"
        },
        "style": "emphasis",
        "preExpandSingleShowCardAction": false,
        "actionsOrientation": "Vertical",
        "actionAlignment": "stretch"
    },
    "adaptiveCard": {
        "allowCustomStyle": false
    },
    "imageSet": {
        "maxImageHeight": 100
    },
    "media": {
        "allowInlinePlayback": false
    },
    "factSet": {
        "title": {
            "size": "Default",
            "color": "Default",
            "isSubtle": false,
            "weight": "Bolder",
            "wrap": true
        },
        "value": {
            "size": "Default",
            "color": "Default",
            "isSubtle": false,
            "weight": "Default",
            "wrap": true
        },
        "spacing": 10
    },
    "cssClassNamePrefix": null
})";
}
