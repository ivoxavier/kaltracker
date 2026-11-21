import QtQuick 2.9
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3
import "../components"
import "../theme"

Page {
    id: backuprestore_page
    objectName: 'BackupRestorePage'
    
    header: PageHeader {
        title: i18n.tr("Backup & Restore Data")
    }

    BackgroundStyle {}

    // ==========================================
    // LIGAÇÃO C++: BACKUP & RESTORE
    // ==========================================
    Connections {
        target: backupRestoreService

        function onExportSuccess() { 
            PopupUtils.open(data_exported_dialog); 
        }
        
        function onExportFail(errorString) { 
            console.log("Export Error: " + errorString); 
            PopupUtils.open(error_dialog); 
        }
        
        function onImportVerificationSuccess() { 
            backupRestoreService.importData(); 
        }
        
        function onImportVerificationFail() { 
            PopupUtils.open(files_not_valid); 
        }
        
        function onImportSuccess() { 
            PopupUtils.open(data_loaded_dialog); 
        }
        
        function onImportFail(errorString) { 
            console.log("Import Error: " + errorString); 
            PopupUtils.open(data_not_loaded_dialog); 
        }
    }

    // ==========================================
    // DIÁLOGOS DE RESULTADO
    // ==========================================
    Component { id: error_dialog; MessageDialog { msg: i18n.tr("Something went wrong, please verify Logs") } }
    Component { id: files_not_valid; MessageDialog { msg: i18n.tr("Verify if files exist in the Import folder.") } }
    Component { id: data_not_loaded_dialog; MessageDialog { msg: i18n.tr("Data not loaded, please check logs") } }
    Component { id: data_exported_dialog; MessageDialog { msg: i18n.tr("Data exported successfully!") } }
    Component { id: data_loaded_dialog; MessageDialog { msg: i18n.tr("Data loaded! We recommend restarting the app.") } }
    
    // ==========================================
    // INTERFACE DE UTILIZADOR
    // ==========================================
    Flickable {
        anchors.top: parent.header.bottom 
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        contentWidth: parent.width
        contentHeight: main_column.height + units.gu(8) 
        clip: true

        Column { 
            id: main_column
            width: parent.width
            spacing: units.gu(3)
            
            // --- ANIMAÇÃO DE ENTRADA SUAVE ---
            opacity: 0
            transform: Translate { id: slide_anim; y: units.gu(3) }
            
            Component.onCompleted: entry_anim.start()
            
            ParallelAnimation {
                id: entry_anim
                NumberAnimation { target: main_column; property: "opacity"; to: 1; duration: 400; easing.type: Easing.OutCubic }
                NumberAnimation { target: slide_anim; property: "y"; to: 0; duration: 500; easing.type: Easing.OutBack }
            }

            Item { width: 1; height: units.gu(2) }

            // --- HERO GRAPHIC MODERNO ---
            Item {
                anchors.horizontalCenter: parent.horizontalCenter
                width: units.gu(12)
                height: units.gu(12)
                
                Rectangle {
                    anchors.fill: parent
                    radius: width / 2
                    color: app_style.button.actionButton.buttonColor
                    opacity: 0.15 
                }
                
                Icon {
                    anchors.centerIn: parent
                    width: units.gu(6)
                    height: units.gu(6)
                    name: "document-save" 
                    color: app_style.button.actionButton.buttonColor
                }
            }
            
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: i18n.tr("Keep your data safe")
                font.weight: Font.Light
                font.pixelSize: units.gu(2.5)
                color: app_style.label.labelColor
            }

            // --- BOTÃO DE EXPORTAR ---
            SlotBackupRestore {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - units.gu(4)
                height: units.gu(14) 
                
                icon_source: "../../assets/export_icon.svg"
                slot_label: i18n.tr("Export Data")
                slot_path_label: "./local/share/kaltracker.ivoxavier/Export"
                 
                MouseArea {
                    anchors.fill: parent
                    onClicked: { backupRestoreService.exportData(); }    
                }
            }

            // --- BOTÃO DE IMPORTAR ---
            SlotBackupRestore {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - units.gu(4)
                height: units.gu(14) 

                icon_source: "../../assets/import_icon.svg"
                slot_label: i18n.tr("Import Data")
                slot_path_label: "./local/share/kaltracker.ivoxavier/Import"
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: { backupRestoreService.verifyImportFiles(); }
                }
            }  
            
            // --- INSTRUÇÕES (BANNER INFORMATIVO) ---
            Item { width: 1; height: units.gu(1) } // Espaçador

            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - units.gu(4)
                spacing: units.gu(1)

                Label {
                    text: i18n.tr("Importing Requirements")
                    font.weight: Font.DemiBold
                    color: LomiriColors.ash
                }

                Rectangle {
                    width: parent.width
                    height: info_row.height + units.gu(4)
                    color: app_style.shape.shapeColor
                    radius: units.gu(1)
                    
                    Row {
                        id: info_row
                        width: parent.width - units.gu(4)
                        anchors.centerIn: parent
                        spacing: units.gu(2)
                        
                        Icon {
                            name: "info"
                            width: units.gu(3)
                            height: units.gu(3)
                            color: LomiriColors.ash
                        }
                        
                        Label {
                            width: parent.width - units.gu(5) 
                            font.pixelSize: units.gu(1.5)
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            color: app_style.label.labelColor
                            text: i18n.tr("Place the files from the ExportData folder into the Import path before restoring.") 
                        }
                    }
                }
            }
        }  
    }
}