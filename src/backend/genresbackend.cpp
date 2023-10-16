// <one line to give the program's name and a brief idea of what it does.>
// SPDX-FileCopyrightText: 2023 asterion <email>
// SPDX-License-Identifier: GPL-3.0-or-later

#include "backend/genresbackend.h"

GenresBackend::GenresBackend()
{
    KConfig novaliverc(QDir::homePath()+"/.config/novaliverc");
    KConfigGroup categories = novaliverc.group("Categories");

    if (!categories.hasKey("genres"))
    {
        QString genres ="50s,60s,70s,80s,90s,adult contemporary,alternative,alternative rock,ambient,américa,blues,chillout,christian,classic hits,classic rock,classical,commercial,community radio,country,culture,dance,disco,easy listening,electro,electronic,entertainment,entretenimiento,español,estación,flamenco,fm,folk,funk,funky,gospel,greek,grupera,grupero,hiphop,hits,hot,house,indie,information,international,jazz,juvenil,latin pop,latinoamérica,local music,local news,lounge,mainstream,metal,mex,mexican music,mexico,moi merino,music,musica,música,música del recuerdo,música en español,musica latina,música pop,música popular mexicana,musica regional,música regional,musica regional mexicana,música variada,mx,news,news talk,norteamérica,noticias,npr,oldies,pop,pop music,pop rock,public radio,radio,rap,regional,regional mexican,regional mexicana,regional music,reggae,regional radio,rnb,rock,smooth jazz,soul,sport,sports,talk,talk & speech,techno,top 40,top hits,top40,traditional mexican music,trance,university radio,variety,world music";

        categories.writeEntry("genres", genres);
    }

    m_genres = categories.readEntry("genres", QStringList());
}

GenresBackend::~GenresBackend()
{
}

QStringList GenresBackend::genres() const
{
    return m_genres;
}

void GenresBackend::setGenres(const QStringList& genres)
{
    if (m_genres == genres) {
        return;
    }

    m_genres = genres;
    emit genresChanged(m_genres);
}
