// <one line to give the program's name and a brief idea of what it does.>
// SPDX-FileCopyrightText: 2023 asterion <email>
// SPDX-License-Identifier: GPL-3.0-or-later

#include "languagebackend.h"

LanguageBackend::LanguageBackend()
{
    KConfig novaliverc(QDir::homePath()+"/.config/novaliverc");
    KConfigGroup categories = novaliverc.group("Categories");

    if (!categories.hasKey("language"))
    {
        QString languages ="afrikaans,albanian,american english,arabesk,arabic,azerbaijani,bahasa indonesia,bambara,basque,belarusian,bengali,bosnian,brasil,brazilian portuguese,british english,bulgarian,cantonese,castellano,catalan,cebuano,chinese,creole,croatian,czech,danish,deutsch fränkisch,dutch,english,english uk,español,español argentina,español colombia,español ecuador,español internacional,español mexico,estonian,filipino,finnish,french,galician,german,greek,hebrew,hindi,hokkien,hungarian,icelandic,indonesian,italian,japanese,kannada,kazakh,korean,kurdish,latin,latvian,lithuanian,lowgerman,luganda,malay,malayalam,mandarin,marathi,moldovian,mongolian,montenegrin,montenegro,nepali,norwegian,persian,polish,português brasil,portugues do brasil,portuguese,punjabi,romanian,russian,serbian,sinhala,slovak,slovenian,spanish,swahili,swedish,swiss german,tagalog,tamil,thai,tibetan,türkisch,turkish,ukrainian,urdu,vietnamese,русский";

        categories.writeEntry("language", languages);
    }

    m_language = categories.readEntry("language", QStringList());
}

LanguageBackend::~LanguageBackend()
{
}

QStringList LanguageBackend::language() const
{
    return m_language;
}

void LanguageBackend::setLanguage(const QStringList& language)
{
    if (m_language == language) {
        return;
    }

    m_language = language;
    Q_EMIT languageChanged(m_language);
}
