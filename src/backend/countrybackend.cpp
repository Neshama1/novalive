// <one line to give the program's name and a brief idea of what it does.>
// SPDX-FileCopyrightText: 2023 asterion <email>
// SPDX-License-Identifier: GPL-3.0-or-later

#include "backend/countrybackend.h"

CountryBackend::CountryBackend()
{
    KConfig novaliverc(QDir::homePath()+"/.config/novaliverc");
    KConfigGroup categories = novaliverc.group("Categories");

    if (!categories.hasKey("countryName"))
    {
        QString names ="Afghanistan,Albania,Algeria,Argentina,Australia,Austria,Belarus,Belgium,Bolivia,Bosnia and Herzegovina,Brazil,British Indian Ocean Territory,Bulgaria,Canada,Chile,China,Colombia,Costa Rica,Croatia,Cuba,Cyprus,Czechia,Denmark,Dominican Republic,DR Congo,Ecuador,Egypt,El Salvador,Estonia,Finland,France,Germany,Ghana,Gibraltar,Greece,Guatemala,Honduras,Hong Kong,Hungary,Iceland,India,Indonesia,Iran,Ireland,Israel,Italy,Jamaica,Japan,Kazakhstan,Kenya,Latvia,Lebanon,Lithuania,Luxembourg,Malaysia,Mali,Mexico,Moldova,Montenegro,Morocco,Nepal,Netherlands,New Zealand,Nigeria,Norway,Pakistan,Paraguay,Peru,Philippines,Poland,Portugal,Puerto Rico,Romania,Russia,Saudi Arabia,Senegal,Serbia,Singapore,Slovakia,Slovenia,South Africa,South Korea,Spain,SriLanka,Sweden,Switzerland,Syria,Taiwan,Tanzania,Thailand,Tunisia,Turkey,Uganda,Ukraine,United Arab Emirates,United Kingdom,United States,Uruguay,Venezuela,Vietnam";

        categories.writeEntry("countryName", names);
    }
    if (!categories.hasKey("countryCode"))
    {
        QString codes ="AF,AL,DZ,AR,AU,AT,BY,BE,BO,BA,BR,IO,BG,CA,CL,CN,CO,CR,HR,CU,CY,CZ,DK,DO,CD,EC,EG,SV,EE,FI,FR,DE,GH,GI,GR,GT,HN,HK,HU,IS,IN,ID,IR,IE,IL,IT,JM,JP,KZ,KE,LV,LB,LT,LU,MY,ML,MX,MD,ME,MA,NP,NL,NZ,NG,NO,PK,PY,PE,PH,PL,PT,PR,RO,RU,SA,SN,RS,SG,SK,SI,ZA,KR,ES,LK,SE,CH,SY,TW,TZ,TH,TN,TR,UG,UA,AE,GB,US,UY,VE,VN";

        categories.writeEntry("countryCode", codes);
    }

    m_name = categories.readEntry("countryName", QStringList());
    m_code = categories.readEntry("countryCode", QStringList());
}

CountryBackend::~CountryBackend()
{
}

QStringList CountryBackend::name() const
{
    return m_name;
}

void CountryBackend::setName(const QStringList& name)
{
    if (m_name == name) {
        return;
    }

    m_name = name;
    emit nameChanged(m_name);
}

QStringList CountryBackend::code() const
{
    return m_code;
}

void CountryBackend::setCode(const QStringList& code)
{
    if (m_code == code) {
        return;
    }

    m_code = code;
    emit codeChanged(m_code);
}
