/*
 * changemapobject.cpp
 * Copyright 2009, Thorbjørn Lindeijer <thorbjorn@lindeijer.nl>
 *
 * This file is part of Tiled.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation; either version 2 of the License, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include "changemapobject.h"

#include "mapdocument.h"
#include "mapobjectmodel.h"

#include <QCoreApplication>

using namespace Tiled;
using namespace Tiled::Internal;

ChangeMapObject::ChangeMapObject(MapDocument *mapDocument,
                                 MapObject *mapObject,
                                 MapObject::Property property,
                                 const QVariant &value)
    : QUndoCommand(QCoreApplication::translate("Undo Commands",
                                               "Change Object"))
    , mMapDocument(mapDocument)
    , mMapObject(mapObject)
    , mProperty(property)
    , mValue(value)
    , mOldChangeState(mapObject->propertyChanged(property))
    , mNewChangeState(true)
{
    switch (property) {
    case MapObject::VisibleProperty:
        if (value.toBool())
            setText(QCoreApplication::translate("Undo Commands", "Show Object"));
        else
            setText(QCoreApplication::translate("Undo Commands", "Hide Object"));
        break;
    default:
        break;
    }
}

void ChangeMapObject::swap()
{
    QVariant oldValue = mMapObject->mapObjectProperty(mProperty);
    mMapDocument->mapObjectModel()->setObjectProperty(mMapObject, mProperty, mValue);
    std::swap(mValue, oldValue);

    mMapObject->setPropertyChanged(mProperty, mNewChangeState);
    std::swap(mOldChangeState, mNewChangeState);
}


ChangeMapObjectCells::ChangeMapObjectCells(MapDocument *mapDocument,
                                           const QVector<MapObjectCell> &changes,
                                           QUndoCommand *parent)
    : QUndoCommand(parent)
    , mMapObjectModel(mapDocument->mapObjectModel())
    , mChanges(changes)
{
}

static QList<MapObject*> objectList(const QVector<MapObjectCell> &changes)
{
    QList<MapObject*> result;
    result.reserve(changes.size());

    for (const MapObjectCell &change : changes)
        result.append(change.object);

    return result;
}

void ChangeMapObjectCells::swap()
{
    for (MapObjectCell &change : mChanges) {
        auto cell = change.object->cell();
        change.object->setCell(change.cell);
        change.cell = cell;
    }
    emit mMapObjectModel->objectsChanged(objectList(mChanges));
}

ChangeMapObjectsTile::ChangeMapObjectsTile(MapDocument *mapDocument,
                                           const QList<MapObject *> &mapObjects,
                                           Tile *tile)
    : QUndoCommand(QCoreApplication::translate("Undo Commands",
                                               "Change %n Object/s Tile",
                                               nullptr, mapObjects.size()))
    , mMapDocument(mapDocument)
    , mMapObjects(mapObjects)
    , mTile(tile)
{
    for (MapObject *object : mMapObjects) {
        Cell cell = object->cell();
        mOldCells.append(cell);
        Tile *tile = cell.tile();
        // Update the size if the object's tile is valid and the sizes match
        mUpdateSize.append(tile && object->size() == tile->size());

        mOldChangeStates.append(object->propertyChanged(MapObject::CellProperty));
    }
}

static void setObjectCell(MapObject *object,
                          const Cell &cell,
                          const bool updateSize)
{
    object->setCell(cell);

    if (updateSize)
        object->setSize(cell.tile()->size());
}

void ChangeMapObjectsTile::restoreTiles()
{
    for (int i = 0; i < mMapObjects.size(); ++i) {
        setObjectCell(mMapObjects[i], mOldCells[i], mUpdateSize[i]);
        mMapObjects[i]->setPropertyChanged(MapObject::CellProperty, mOldChangeStates[i]);
    }

    emit mMapDocument->mapObjectModel()->objectsChanged(mMapObjects);
}

void ChangeMapObjectsTile::changeTiles()
{
    for (int i = 0; i < mMapObjects.size(); ++i) {
        Cell cell = mMapObjects[i]->cell();
        cell.setTile(mTile);
        setObjectCell(mMapObjects[i], cell, mUpdateSize[i]);
        mMapObjects[i]->setPropertyChanged(MapObject::CellProperty);
    }

    emit mMapDocument->mapObjectModel()->objectsChanged(mMapObjects);
}

DetachObject::DetachObject(MapDocument *mapDocument,
                           MapObject *mapObject)
    : QUndoCommand(QCoreApplication::translate("Undo Commands",
                                               "Detach Object",
                                                nullptr))
    , mMapDocument(mapDocument)
    , mMapObject(mapObject)
{
    mTemplateRef = mMapObject->templateRef();
    mProperties = mMapObject->properties();
}

void DetachObject::redo()
{
    // Merge the instance properties into the template properties
    Properties newProperties = mMapObject->templateObject()->properties();
    newProperties.merge(mMapObject->properties());
    mMapObject->setProperties(newProperties);

    mMapObject->setTemplateRef({nullptr, 0});
    mMapObject->syncWithTemplate();
    emit mMapDocument->mapObjectModel()->objectsChanged(QList<MapObject*>() << mMapObject);
}

void DetachObject::undo()
{
    mMapObject->setTemplateRef(mTemplateRef);
    mMapObject->setProperties(mProperties);
    mMapObject->syncWithTemplate();
    emit mMapDocument->mapObjectModel()->objectsChanged(QList<MapObject*>() << mMapObject);
}

LockTemplateProperty::LockTemplateProperty(MapDocument *mapDocument,
                                           MapObject *mapObject,
                                           QString propertyName,
                                           bool locked,
                                           bool customProperty)
    : mMapDocument(mapDocument)
    , mMapObject(mapObject)
    , mPropertyName(propertyName)
    , mLocked(locked)
    , mCustomProperty(customProperty)
{
    if (locked)
        setText(QCoreApplication::translate("Undo Commands",
                                            "Lock Property"));
    else
        setText(QCoreApplication::translate("Undo Commands",
                                            "Unlock Property"));
}

void LockTemplateProperty::swap()
{
    if (mMapObject->propertyLocked(mPropertyName, mCustomProperty))
        mMapObject->unlockProperty(mPropertyName, mCustomProperty);
    else
        mMapObject->lockProperty(mPropertyName, mCustomProperty);
}
