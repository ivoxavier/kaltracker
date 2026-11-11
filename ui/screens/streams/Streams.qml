/*
 * 2022-2026  Ivo Xavier
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 */

import QtQuick 2.9
import Lomiri.Components 1.3
import Qt.labs.settings 1.0
import io.thp.pyotherside 1.5

Python {
    Component.onCompleted: {
        addImportPath(Qt.resolvedUrl('.'))
        addImportPath(Qt.resolvedUrl('../py/'))
        addImportPath(Qt.resolvedUrl('../../py/'))
        
        importModule('streams', function(success) {
            console.log("Module 'streams' loaded:", success)
        })
    }

    onError: {
        console.log("ERROr PyOtherSide:", traceback)
    }
}