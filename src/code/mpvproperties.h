/*
 * SPDX-FileCopyrightText: 2023 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: MIT
 */

#ifndef MPVPROPERTIES_H
#define MPVPROPERTIES_H

#include <QObject>
#include <qqmlintegration.h>

class MpvProperties : public QObject
{
    Q_OBJECT
//    QML_ELEMENT
//    QML_SINGLETON

public:
    explicit MpvProperties(QObject *parent = nullptr)
        : QObject(parent)
    {
    }

    static MpvProperties *self()
    {
        static MpvProperties p;
        return &p;
    }

    Q_PROPERTY(QString MediaTitle MEMBER MediaTitle CONSTANT)
    const QString MediaTitle{QStringLiteral("media-title")};

    Q_PROPERTY(QString Position MEMBER Position CONSTANT)
    const QString Position{QStringLiteral("time-pos")};

    Q_PROPERTY(QString Duration MEMBER Duration CONSTANT)
    const QString Duration{QStringLiteral("duration")};

    Q_PROPERTY(QString Pause MEMBER Pause CONSTANT)
    const QString Pause{QStringLiteral("pause")};

    Q_PROPERTY(QString Volume MEMBER Volume CONSTANT)
    const QString Volume{QStringLiteral("volume")};

    Q_PROPERTY(QString Mute MEMBER Mute CONSTANT)
    const QString Mute{QStringLiteral("mute")};

private:
    Q_DISABLE_COPY_MOVE(MpvProperties)
};

#endif // MPVPROPERTIES_H
