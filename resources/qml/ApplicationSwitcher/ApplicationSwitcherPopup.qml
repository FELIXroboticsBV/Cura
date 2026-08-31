// Copyright (c) 2021 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.15

import UM 1.4 as UM
import Cura 1.1 as Cura

Popup
{
    id: applicationSwitcherPopup

    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    opacity: opened ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: 100 } }
    padding: UM.Theme.getSize("wide_margin").width

    contentItem: Grid
    {
        id: ultimakerPlatformLinksGrid
        columns: 3
        spacing: UM.Theme.getSize("default_margin").width

        Repeater
        {
            model:
            [
                {
                    displayName: "FELIX Printers",
                    thumbnail: UM.Theme.getIcon("Felix-2", "high"),
                    description: "Visit felix website ",
                    link: "https://felixprinters.com/",
                    permissionsRequired: []
                },

                {
                    displayName: "Shop FELIX Printers",
                    thumbnail: UM.Theme.getIcon("Shop", "high"),
                    description: "Visit shop of the FELIX Printers ",
                    link: "https://shop.felixprinters.com/",
                    permissionsRequired: []
                }
            ]

            delegate: ApplicationButton
            {
                displayName: modelData.displayName
                iconSource: modelData.thumbnail
                tooltipText: modelData.description
                isExternalLink: true
                visible:
                {
                    try
                    {
                        modelData.permissionsRequired.forEach(function(permission)
                        {
                            if(!Cura.API.account.isLoggedIn || !Cura.API.account.permissions.includes(permission)) //This required permission is not in the account.
                            {
                                throw "No permission to use this application."; //Can't return from within this lambda. Throw instead.
                            }
                        });
                    }
                    catch(e)
                    {
                        return false;
                    }
                    return true;
                }

                onClicked: Qt.openUrlExternally(modelData.link)
            }
        }
    }

    background: UM.PointingRectangle
    {
        color: UM.Theme.getColor("tool_panel_background")
        borderColor: UM.Theme.getColor("lining")
        borderWidth: UM.Theme.getSize("default_lining").width

        // Move the target by the default margin so that the arrow isn't drawn exactly on the corner
        target: Qt.point(width - UM.Theme.getSize("default_margin").width - (applicationSwitcherButton.width / 2), -10)

        arrowSize: UM.Theme.getSize("default_arrow").width
    }
}
