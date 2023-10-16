// <one line to give the program's name and a brief idea of what it does.>
// SPDX-FileCopyrightText: 2023 asterion <email>
// SPDX-License-Identifier: GPL-3.0-or-later

#ifndef LANGUAGEBACKEND_H
#define LANGUAGEBACKEND_H

#include <QObject>
#include <QDebug>
#include <QDir>
#include <QStringList>
#include <KConfig>
#include <KConfigGroup>

/**
 * @todo write docs
 */
class LanguageBackend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList language READ language WRITE setLanguage NOTIFY languageChanged)

public:
    /**
     * Default constructor
     */
    LanguageBackend();

    /**
     * Destructor
     */
    ~LanguageBackend();

    /**
     * @return the language
     */
    QStringList language() const;

public Q_SLOTS:
    /**
     * Sets the language.
     *
     * @param language the new language
     */
    void setLanguage(const QStringList& language);

Q_SIGNALS:
    void languageChanged(const QStringList& language);

public:
    QStringList m_language;
};

#endif // LANGUAGEBACKEND_H
