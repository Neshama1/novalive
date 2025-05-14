// <one line to give the program's name and a brief idea of what it does.>
// SPDX-FileCopyrightText: 2023 asterion <email>
// SPDX-License-Identifier: GPL-3.0-or-later

#ifndef COUNTRYBACKEND_H
#define COUNTRYBACKEND_H

#include <KConfig>
#include <KConfigGroup>
#include <QDebug>
#include <QDir>
#include <QObject>
#include <QStringList>

/**
 * @todo write docs
 */
class CountryBackend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QStringList code READ code WRITE setCode NOTIFY codeChanged)

public:
    /**
     * Default constructor
     */
    CountryBackend();

    /**
     * Destructor
     */
    ~CountryBackend();

    /**
     * @return the name
     */
    QStringList name() const;

    /**
     * @return the code
     */
    QStringList code() const;

public Q_SLOTS:
    /**
     * Sets the name.
     *
     * @param name the new name
     */
    void setName(const QStringList &name);

    /**
     * Sets the code.
     *
     * @param code the new code
     */
    void setCode(const QStringList &code);

Q_SIGNALS:
    void nameChanged(const QStringList &name);

    void codeChanged(const QStringList &code);

public:
    QStringList m_name;
    QStringList m_code;
};

#endif // COUNTRYBACKEND_H
