/*
 * changepolygon.cpp
 * Copyright 2011, Thorbjørn Lindeijer <thorbjorn@lindeijer.nl>
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

#include "changepolygon.h"

#include "mapdocument.h"
#include "mapobject.h"
#include "mapobjectmodel.h"

#include <QCoreApplication>

using namespace Tiled;
using namespace Tiled::Internal;

ChangePolygon::ChangePolygon(MapDocument *mapDocument,
                             MapObject *mapObject,
                             const QPolygonF &oldPolygon)
    : mMapDocument(mapDocument)
    , mMapObject(mapObject)
    , mOldPolygon(oldPolygon)
    , mNewPolygon(mapObject->polygon())
{
    setText(QCoreApplication::translate("Undo Commands", "Change Polygon"));
}

ChangePolygon::ChangePolygon(MapDocument *mapDocument,
                             MapObject *mapObject,
                             const QPolygonF &newPolygon,
                             const QPolygonF &oldPolygon)
    : mMapDocument(mapDocument)
    , mMapObject(mapObject)
    , mOldPolygon(oldPolygon)
    , mNewPolygon(newPolygon)
    , mOldChangeState(mapObject->propertyChanged(MapObject::ShapeProperty))
{
    setText(QCoreApplication::translate("Undo Commands", "Change Polygon"));
}

void ChangePolygon::undo()
{
    mMapDocument->mapObjectModel()->setObjectPolygon(mMapObject, mOldPolygon);
    mMapObject->setPropertyChanged(MapObject::ShapeProperty, mOldChangeState);
}

void ChangePolygon::redo()
{
    mMapDocument->mapObjectModel()->setObjectPolygon(mMapObject, mNewPolygon);
    mMapObject->setPropertyChanged(MapObject::ShapeProperty);
}
