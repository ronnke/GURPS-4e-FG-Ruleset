-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
    OptionsManager.registerCallback("SHPC", updateHealthDisplay);
    OptionsManager.registerCallback("SHNPC", updateHealthDisplay);
    OptionsManager.registerCallback("CTSI", updateShowOrder);
    updateHealthDisplay();
    updateShowOrder();
end

function onClose()
    OptionsManager.unregisterCallback("SHPC", updateHealthDisplay);
    OptionsManager.unregisterCallback("SHNPC", updateHealthDisplay);
    OptionsManager.unregisterCallback("CTSI", updateShowOrder);
end

function updateHealthDisplay()
    for _,w in pairs(list.getWindows()) do
        w.updateHealthDisplay();
    end
end

function updateShowOrder()
    for _,w in pairs(list.getWindows()) do
        w.updateShowOrder();
    end
end
