// <one line to give the program's name and a brief idea of what it does.>
// SPDX-FileCopyrightText: 2023 asterion <email>
// SPDX-License-Identifier: GPL-3.0-or-later

#ifndef GENRESBACKEND_H
#define GENRESBACKEND_H

#include <KConfig>
#include <KConfigGroup>
#include <QDebug>
#include <QDir>
#include <QObject>
#include <QStringList>

/**
 * @todo write docs
 */
class GenresBackend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList genres READ genres WRITE setGenres NOTIFY genresChanged)

public:
    /**
     * Default constructor
     */
    GenresBackend();

    /**
     * Destructor
     */
    ~GenresBackend();

    /**
     * @return the genres
     */
    QStringList genres() const;

public Q_SLOTS:
    /**
     * Sets the genres.
     *
     * @param genres the new genres
     */
    void setGenres(const QStringList &genres);

Q_SIGNALS:
    void genresChanged(const QStringList &genres);

public:
    QStringList m_genres;
};

#endif // GENRESBACKEND_H
