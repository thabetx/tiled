import qbs 1.0
import qbs.FileInfo
import qbs.TextFile

QtGuiApplication {
    name: "tiled"
    targetName: name

    Depends { name: "libtiled" }
    Depends { name: "translations" }
    Depends { name: "qtpropertybrowser" }
    Depends { name: "qtsingleapplication" }
    Depends { name: "Qt"; submodules: ["core", "widgets"]; versionAtLeast: "5.4" }

    property string sparkleDir: {
        if (qbs.architecture === "x86_64")
            return "winsparkle/x64"
        else
            return "winsparkle/x86"
    }

    cpp.includePaths: ["."]
    cpp.useRPaths: project.useRPaths
    cpp.rpaths: {
        if (qbs.targetOS.contains("darwin"))
            return ["@loader_path/../Frameworks"];
        else if (project.linuxArchive)
            return ["$ORIGIN/lib"]
        else
            return ["$ORIGIN/../lib"];
    }
    cpp.useCxxPrecompiledHeader: qbs.buildVariant != "debug"
    cpp.cxxLanguageVersion: "c++11"

    cpp.defines: {
        var defs = [
            "TILED_VERSION=" + project.version,
            "QT_NO_CAST_FROM_ASCII",
            "QT_NO_CAST_TO_ASCII"
        ];
        if (project.snapshot)
            defs.push("TILED_SNAPSHOT");
        if (project.sparkleEnabled)
            defs.push("TILED_SPARKLE");
        if (project.linuxArchive)
            defs.push("TILED_LINUX_ARCHIVE");
        return defs;
    }

    consoleApplication: false

    Group {
        name: "Precompiled header"
        files: ["pch.h"]
        fileTags: ["cpp_pch_src"]
    }

    files: [
        "aboutdialog.cpp",
        "aboutdialog.h",
        "aboutdialog.ui",
        "abstractobjecttool.cpp",
        "abstractobjecttool.h",
        "abstracttiletool.cpp",
        "abstracttiletool.h",
        "abstracttool.cpp",
        "abstracttool.h",
        "actionmanager.cpp",
        "actionmanager.h",
        "addpropertydialog.cpp",
        "addpropertydialog.h",
        "addpropertydialog.ui",
        "addremovelayer.cpp",
        "addremovelayer.h",
        "addremovemapobject.cpp",
        "addremovemapobject.h",
        "addremoveterrain.cpp",
        "addremoveterrain.h",
        "addremovetiles.cpp",
        "addremovetileset.cpp",
        "addremovetileset.h",
        "addremovetiles.h",
        "adjusttileindexes.cpp",
        "adjusttileindexes.h",
        "automapper.cpp",
        "automapper.h",
        "automapperwrapper.cpp",
        "automapperwrapper.h",
        "automappingmanager.cpp",
        "automappingmanager.h",
        "automappingutils.cpp",
        "automappingutils.h",
        "autoupdater.cpp",
        "autoupdater.h",
        "brokenlinks.cpp",
        "brokenlinks.h",
        "brushitem.cpp",
        "brushitem.h",
        "bucketfilltool.cpp",
        "bucketfilltool.h",
        "changeimagelayerposition.cpp",
        "changeimagelayerposition.h",
        "changeimagelayerproperties.cpp",
        "changeimagelayerproperties.h",
        "changelayer.cpp",
        "changelayer.h",
        "changemapobject.cpp",
        "changemapobject.h",
        "changemapobjectsorder.cpp",
        "changemapobjectsorder.h",
        "changemapproperty.cpp",
        "changemapproperty.h",
        "changeobjectgroupproperties.cpp",
        "changeobjectgroupproperties.h",
        "changepolygon.cpp",
        "changepolygon.h",
        "changeproperties.cpp",
        "changeproperties.h",
        "changeselectedarea.cpp",
        "changeselectedarea.h",
        "changetile.cpp",
        "changetile.h",
        "changetileanimation.cpp",
        "changetileanimation.h",
        "changetileimagesource.cpp",
        "changetileimagesource.h",
        "changetileobjectgroup.cpp",
        "changetileobjectgroup.h",
        "changetileprobability.cpp",
        "changetileprobability.h",
        "changetileterrain.cpp",
        "changetileterrain.h",
        "clipboardmanager.cpp",
        "clipboardmanager.h",
        "colorbutton.cpp",
        "colorbutton.h",
        "commandbutton.cpp",
        "commandbutton.h",
        "command.cpp",
        "commanddatamodel.cpp",
        "commanddatamodel.h",
        "commanddialog.cpp",
        "commanddialog.h",
        "commanddialog.ui",
        "command.h",
        "commandlineparser.cpp",
        "commandlineparser.h",
        "commandmanager.cpp",
        "commandmanager.h",
        "consoledock.cpp",
        "consoledock.h",
        "containerhelpers.h",
        "createellipseobjecttool.cpp",
        "createellipseobjecttool.h",
        "createmultipointobjecttool.cpp",
        "createmultipointobjecttool.h",
        "createobjecttool.cpp",
        "createobjecttool.h",
        "createpolygonobjecttool.cpp",
        "createpolygonobjecttool.h",
        "createpolylineobjecttool.cpp",
        "createpolylineobjecttool.h",
        "createrectangleobjecttool.cpp",
        "createrectangleobjecttool.h",
        "createscalableobjecttool.cpp",
        "createscalableobjecttool.h",
        "createtextobjecttool.cpp",
        "createtextobjecttool.h",
        "createtileobjecttool.cpp",
        "createtileobjecttool.h",
        "document.cpp",
        "document.h",
        "documentmanager.cpp",
        "documentmanager.h",
        "editor.cpp",
        "editor.h",
        "editpolygontool.cpp",
        "editpolygontool.h",
        "eraser.cpp",
        "eraser.h",
        "erasetiles.cpp",
        "erasetiles.h",
        "exportasimagedialog.cpp",
        "exportasimagedialog.h",
        "exportasimagedialog.ui",
        "eyevisibilitydelegate.cpp",
        "eyevisibilitydelegate.h",
        "filechangedwarning.cpp",
        "filechangedwarning.h",
        "fileedit.cpp",
        "fileedit.h",
        "flexiblescrollbar.cpp",
        "flexiblescrollbar.h",
        "flipmapobjects.cpp",
        "flipmapobjects.h",
        "geometry.cpp",
        "geometry.h",
        "grouplayeritem.cpp",
        "grouplayeritem.h",
        "id.cpp",
        "id.h",
        "imagecolorpickerwidget.cpp",
        "imagecolorpickerwidget.h",
        "imagecolorpickerwidget.ui",
        "imagelayeritem.cpp",
        "imagelayeritem.h",
        "clickablelabel.cpp",
        "clickablelabel.h",
        "languagemanager.cpp",
        "languagemanager.h",
        "layerdock.cpp",
        "layerdock.h",
        "layeritem.cpp",
        "layeritem.h",
        "layermodel.cpp",
        "layermodel.h",
        "layeroffsettool.cpp",
        "layeroffsettool.h",
        "magicwandtool.h",
        "magicwandtool.cpp",
        "main.cpp",
        "maintoolbar.cpp",
        "maintoolbar.h",
        "mainwindow.cpp",
        "mainwindow.h",
        "mainwindow.ui",
        "mapdocumentactionhandler.cpp",
        "mapdocumentactionhandler.h",
        "mapdocument.cpp",
        "mapdocument.h",
        "mapeditor.cpp",
        "mapeditor.h",
        "mapobjectitem.cpp",
        "mapobjectitem.h",
        "mapobjectmodel.cpp",
        "mapobjectmodel.h",
        "mapscene.cpp",
        "mapscene.h",
        "mapsdock.cpp",
        "mapsdock.h",
        "mapview.cpp",
        "mapview.h",
        "minimap.cpp",
        "minimapdock.cpp",
        "minimapdock.h",
        "minimap.h",
        "minimaprenderer.cpp",
        "minimaprenderer.h",
        "movelayer.cpp",
        "movelayer.h",
        "movemapobject.cpp",
        "movemapobject.h",
        "movemapobjecttogroup.cpp",
        "movemapobjecttogroup.h",
        "newmapdialog.cpp",
        "newmapdialog.h",
        "newmapdialog.ui",
        "newtilesetdialog.cpp",
        "newtilesetdialog.h",
        "newtilesetdialog.ui",
        "noeditorwidget.cpp",
        "noeditorwidget.h",
        "noeditorwidget.ui",
        "objectgroupitem.cpp",
        "objectgroupitem.h",
        "objectsdock.cpp",
        "objectsdock.h",
        "objectselectionitem.cpp",
        "objectselectionitem.h",
        "objectselectiontool.cpp",
        "objectselectiontool.h",
        "objecttypes.cpp",
        "objecttypes.h",
        "objecttypeseditor.cpp",
        "objecttypeseditor.h",
        "objecttypeseditor.ui",
        "objecttypesmodel.cpp",
        "objecttypesmodel.h",
        "offsetlayer.cpp",
        "offsetlayer.h",
        "offsetmapdialog.cpp",
        "offsetmapdialog.h",
        "offsetmapdialog.ui",
        "painttilelayer.cpp",
        "painttilelayer.h",
        "patreondialog.cpp",
        "patreondialog.h",
        "patreondialog.ui",
        "pluginlistmodel.cpp",
        "pluginlistmodel.h",
        "preferences.cpp",
        "preferencesdialog.cpp",
        "preferencesdialog.h",
        "preferencesdialog.ui",
        "preferences.h",
        "propertiesdock.cpp",
        "propertiesdock.h",
        "propertybrowser.cpp",
        "propertybrowser.h",
        "raiselowerhelper.cpp",
        "raiselowerhelper.h",
        "randompicker.h",
        "rangeset.h",
        "renamelayer.cpp",
        "renamelayer.h",
        "renameterrain.cpp",
        "renameterrain.h",
        "reparentlayers.cpp",
        "reparentlayers.h",
        "replacetileset.cpp",
        "replacetileset.h",
        "resizedialog.cpp",
        "resizedialog.h",
        "resizedialog.ui",
        "resizehelper.cpp",
        "resizehelper.h",
        "resizemap.cpp",
        "resizemap.h",
        "resizemapobject.cpp",
        "resizemapobject.h",
        "resizetilelayer.cpp",
        "resizetilelayer.h",
        "reversingproxymodel.cpp",
        "reversingproxymodel.h",
        "rotatemapobject.cpp",
        "rotatemapobject.h",
        "selectionrectangle.cpp",
        "selectionrectangle.h",
        "selectsametiletool.cpp",
        "selectsametiletool.h",
        "snaphelper.cpp",
        "snaphelper.h",
        "stampbrush.cpp",
        "stampbrush.h",
        "standardautoupdater.cpp",
        "standardautoupdater.h",
        "stylehelper.cpp",
        "stylehelper.h",
        "swaptiles.cpp",
        "swaptiles.h",
        "templateformat.h",
        "terrainbrush.cpp",
        "terrainbrush.h",
        "terraindock.cpp",
        "terraindock.h",
        "terrainmodel.cpp",
        "terrainmodel.h",
        "terrainview.cpp",
        "terrainview.h",
        "texteditordialog.cpp",
        "texteditordialog.h",
        "texteditordialog.ui",
        "textpropertyedit.cpp",
        "textpropertyedit.h",
        "thumbnailrenderer.cpp",
        "thumbnailrenderer.h",
        "tileanimationeditor.cpp",
        "tileanimationeditor.h",
        "tileanimationeditor.ui",
        "tilecollisiondock.cpp",
        "tilecollisiondock.h",
        "tiledapplication.cpp",
        "tiledapplication.h",
        "tiled.qrc",
        "tiledproxystyle.cpp",
        "tiledproxystyle.h",
        "tilelayeritem.cpp",
        "tilelayeritem.h",
        "tilepainter.cpp",
        "tilepainter.h",
        "tileselectionitem.cpp",
        "tileselectionitem.h",
        "tileselectiontool.cpp",
        "tileselectiontool.h",
        "tilesetchanges.cpp",
        "tilesetchanges.h",
        "tilesetdock.cpp",
        "tilesetdock.h",
        "tilesetdocument.cpp",
        "tilesetdocument.h",
        "tileseteditor.cpp",
        "tileseteditor.h",
        "tilesetmodel.cpp",
        "tilesetmodel.h",
        "tilesetparametersedit.cpp",
        "tilesetparametersedit.h",
        "tilesetterrainmodel.cpp",
        "tilesetterrainmodel.h",
        "tilesetview.cpp",
        "tilesetview.h",
        "tilestamp.cpp",
        "tilestamp.h",
        "tilestampmanager.cpp",
        "tilestampmanager.h",
        "tilestampmodel.cpp",
        "tilestampmodel.h",
        "tilestampsdock.cpp",
        "tilestampsdock.h",
        "tmxmapformat.cpp",
        "tmxmapformat.h",
        "toolmanager.cpp",
        "toolmanager.h",
        "treeviewcombobox.cpp",
        "treeviewcombobox.h",
        "undocommands.h",
        "undodock.cpp",
        "undodock.h",
        "utils.cpp",
        "utils.h",
        "varianteditorfactory.cpp",
        "varianteditorfactory.h",
        "variantpropertymanager.cpp",
        "variantpropertymanager.h",
        "zoomable.cpp",
        "zoomable.h",
    ]

    Properties {
        condition: qbs.targetOS.contains("macos")
        cpp.frameworks: "Foundation"
        cpp.cxxFlags: ["-Wno-unknown-pragmas"]
        bundle.infoPlistFile: "Info.plist"
        targetName: "Tiled"
    }
    Group {
        name: "macOS"
        condition: qbs.targetOS.contains("macos")
        files: [
            "Info.plist",
            "macsupport.h",
            "macsupport.mm",
        ]
    }

    Group {
        qbs.install: true
        qbs.installDir: {
            if (qbs.targetOS.contains("windows")
                    || qbs.targetOS.contains("macos")
                    || project.linuxArchive)
                return ""
            else
                return "bin"
        }
        qbs.installSourceBase: product.buildDirectory
        fileTagsFilter: product.type.concat(["aggregate_infoplist", "pkginfo"])
    }

    Properties {
        condition: project.sparkleEnabled
        cpp.includePaths: [".", "winsparkle/include"]
        cpp.libraryPaths: [sparkleDir]
        cpp.dynamicLibraries: ["WinSparkle"]
    }
    Group {
        name: "WinSparkle"
        condition: qbs.targetOS.contains("windows") && project.sparkleEnabled
        files: [
            "winsparkleautoupdater.cpp",
            "winsparkleautoupdater.h",
        ]
    }
    Group {
        name: "WinSparkle DLL"
        condition: qbs.targetOS.contains("windows") && project.sparkleEnabled
        qbs.install: true
        qbs.installDir: ""
        files: [
            sparkleDir + "/WinSparkle.dll"
        ]
    }

    Group {
        name: "macOS (icons)"
        condition: qbs.targetOS.contains("macos")
        qbs.install: true
        qbs.installDir: "Tiled.app/Contents/Resources"
        files: ["images/*.icns"]
    }

    Group {
        name: "Desktop file (Linux)"
        condition: qbs.targetOS.contains("linux")
        qbs.install: true
        qbs.installDir: "share/applications"
        files: [ "../../tiled.desktop" ]
    }

    Group {
        name: "Thumbnailer (Linux)"
        condition: qbs.targetOS.contains("linux")
        qbs.install: true
        qbs.installDir: "share/thumbnailers"
        files: [ "../../mime/tiled.thumbnailer" ]
    }

    Group {
        name: "MIME info (Linux)"
        condition: qbs.targetOS.contains("linux")
        qbs.install: true
        qbs.installDir: "share/mime/packages"
        files: [ "../../mime/tiled.xml" ]
    }

    Group {
        name: "Man page (Linux)"
        condition: qbs.targetOS.contains("linux")
        qbs.install: true
        qbs.installDir: "share/man/man1"
        files: [ "../../man/tiled.1" ]
    }

    Group {
        name: "Icon 16x16 (Linux)"
        condition: qbs.targetOS.contains("linux")
        qbs.install: true
        qbs.installDir: "share/icons/hicolor/16x16/apps"
        files: [ "images/16x16/tiled.png" ]
    }

    Group {
        name: "Icon 32x32 (Linux)"
        condition: qbs.targetOS.contains("linux")
        qbs.install: true
        qbs.installDir: "share/icons/hicolor/32x32/apps"
        files: [ "images/32x32/tiled.png" ]
    }

    Group {
        name: "Icon scalable (Linux)"
        condition: qbs.targetOS.contains("linux")
        qbs.install: true
        qbs.installDir: "share/icons/hicolor/scalable/apps"
        files: [ "images/scalable/tiled.svg" ]
    }

    Group {
        name: "MIME icon 16x16 (Linux)"
        condition: qbs.targetOS.contains("linux")
        qbs.install: true
        qbs.installDir: "share/icons/hicolor/16x16/mimetypes"
        files: [ "images/16x16/application-x-tiled.png" ]
    }

    Group {
        name: "MIME icon 32x32 (Linux)"
        condition: qbs.targetOS.contains("linux")
        qbs.install: true
        qbs.installDir: "share/icons/hicolor/32x32/mimetypes"
        files: [ "images/32x32/application-x-tiled.png" ]
    }

    Group {
        name: "MIME icon scalable (Linux)"
        condition: qbs.targetOS.contains("linux")
        qbs.install: true
        qbs.installDir: "share/icons/hicolor/scalable/mimetypes"
        files: [ "images/scalable/application-x-tiled.svg" ]
    }

    // Generate the tiled.rc file in order to dynamically specify the version
    Group {
        name: "RC file (Windows)"
        files: [ "tiled.rc.in" ]
        fileTags: ["rcIn"]
    }
    Rule {
        inputs: ["rcIn"]
        Artifact {
            filePath: {
                var destdir = FileInfo.joinPaths(product.moduleProperty("Qt.core",
                                                         "generatedFilesDir"), input.fileName);
                return destdir.replace(/\.[^\.]*$/,'')
            }
            fileTags: "rc"
        }
        prepare: {
            var cmd = new JavaScriptCommand();
            cmd.description = "prepare " + FileInfo.fileName(output.filePath);
            cmd.highlight = "codegen";

            cmd.sourceCode = function() {
                var i;
                var vars = {};
                var inf = new TextFile(input.filePath);
                var all = inf.readAll();

                var versionArray = project.version.split(".");
                if (versionArray.length == 3)
                    versionArray.push("0");

                // replace vars
                vars['VERSION'] = project.version;
                vars['VERSION_CSV'] = versionArray.join(",");

                for (i in vars) {
                    all = all.replace(new RegExp('@' + i + '@(?!\w)', 'g'), vars[i]);
                }

                var file = new TextFile(output.filePath, TextFile.WriteOnly);
                file.truncate();
                file.write(all);
                file.close();
            }

            return cmd;
        }
    }
}
