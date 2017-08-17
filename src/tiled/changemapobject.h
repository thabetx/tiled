/*
 * changemapobject.h
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

#pragma once

#include "mapobject.h"
#include "tilelayer.h"

#include <QUndoCommand>
#include <QVector>

namespace Tiled {

class MapObject;
class Tile;

namespace Internal {

class MapDocument;
class MapObjectModel;

class ChangeMapObject : public QUndoCommand
{
public:
    /**
     * Creates an undo command that sets the given \a object's \a property to
     * \a value.
     */
    ChangeMapObject(MapDocument *mapDocument,
                    MapObject *object,
                    MapObject::Property property,
                    const QVariant &value);

    void undo() override { swap(); }
    void redo() override { swap(); }

private:
    void swap();

    MapDocument *mMapDocument;
    MapObject *mMapObject;
    MapObject::Property mProperty;
    QVariant mValue;
    bool mOldChangeState;
    bool mNewChangeState;
};


struct MapObjectCell
{
    MapObject *object;
    Cell cell;
};

class ChangeMapObjectCells : public QUndoCommand
{
public:
    /**
     * Creates an undo command that applies the given map object changes.
     */
    ChangeMapObjectCells(MapDocument *mapDocument,
                         const QVector<MapObjectCell> &changes,
                         QUndoCommand *parent = nullptr);

    void undo() override { swap(); }
    void redo() override { swap(); }

private:
    void swap();

    MapObjectModel *mMapObjectModel;
    QVector<MapObjectCell> mChanges;
};

class ChangeMapObjectsTile : public QUndoCommand
{
public:
    ChangeMapObjectsTile(MapDocument *mapDocument,
                         const QList<MapObject *> &mapObjects,
                         Tile *tile);

    void undo() override { restoreTiles(); }
    void redo() override { changeTiles(); }

private:
    void changeTiles();
    void restoreTiles();

    MapDocument *mMapDocument;
    const QList<MapObject *> mMapObjects;
    Tile * const mTile;
    QVector<Cell> mOldCells;
    QVector<bool> mUpdateSize;
    QVector<bool> mOldChangeStates;
};

class DetachObject : public QUndoCommand
{
public:
    /**
     * Creates an undo command that detaches the given template instance from the template.
     */
    DetachObject(MapDocument *mapDocument,
                 MapObject *mapObject);

    void redo() override;
    void undo() override;

private:
    void attach();
    void detach();

    MapDocument *mMapDocument;
    MapObject *mMapObject;
    TemplateRef mTemplateRef;
    Properties mProperties;
};
} // namespace Internal
} // namespace Tiled
