/*
 * objecttemplatemodel.h
 * Copyright 2017, Thorbjørn Lindeijer <thorbjorn@lindeijer.nl>
 * Copyright 2017, Mohamed Thabet <thabetx@gmail.com>
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

#include "templategroupdocument.h"

#include <QAbstractItemModel>

namespace Tiled {

class MapObject;

namespace Internal {

class ObjectTemplateModel : public QAbstractItemModel
{
    Q_OBJECT

public:
    static ObjectTemplateModel *instance();
    static void deleteInstance();

    const TemplateDocuments &templateDocuments() const;
    void setTemplateDocuments(const TemplateDocuments &templateDocuments);

    QModelIndex index(int row, int column, const QModelIndex &parent = QModelIndex()) const override;
    QModelIndex parent(const QModelIndex &index) const override;

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    bool addNewDocument(TemplateGroupDocument *document);
    bool addDocument(TemplateGroupDocument *document);
    bool addTemplateGroup(TemplateGroup *templateGroup);
    bool saveObjectToDocument(MapObject *object, QString name, int documentIndex);
    ObjectTemplate *toObjectTemplate(const QModelIndex &index) const;
    void save(const TemplateGroup *templateGroup) const;
    void replace(TemplateGroup *oldTemplateGroup, TemplateGroup *newtemplateGroup);

    Qt::ItemFlags flags(const QModelIndex &index) const override;
    QStringList mimeTypes() const override;
    QMimeData *mimeData(const QModelIndexList &indexes) const override;

signals:
    void templateGroupReplaced();

private:
    ObjectTemplateModel(QObject *parent = nullptr);
    ~ObjectTemplateModel();

    static ObjectTemplateModel *mInstance;

    TemplateDocuments mTemplateDocuments;
    TemplateGroup *toTemplateGroup(const QModelIndex &index) const;
};

inline const TemplateDocuments &ObjectTemplateModel::templateDocuments() const
{ return mTemplateDocuments; }

} // namespace Internal
} // namespace Tiled
