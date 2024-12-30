#ifndef MPVRENDERER_H_
#define MPVRENDERER_H_

#include <QtQuick/QQuickFramebufferObject>
#include <QQuickItem>
#include <QString>
#include <QVariant>

#include <mpv/client.h>
#include <mpv/render_gl.h>
#include "qthelper.hpp"

class MpvRenderer;

class MpvObject : public QQuickFramebufferObject
{
    Q_OBJECT

    mpv_handle *mpv;
    mpv_render_context *mpv_gl;

    friend class MpvRenderer;

public:
    static void on_update(void *ctx);

    MpvObject(QQuickItem * parent = 0);
    virtual ~MpvObject();
    virtual Renderer *createRenderer() const;

public Q_SLOTS:
    void command(const QVariant& params);
    void setProperty(const QString& name, const QVariant& value);
    QVariant getProperty(const QString &name) const;

Q_SIGNALS:
    void onUpdate();
    void mpv_events();
    void propertyChanged(QString property, QVariant data);

private:
    void handle_mpv_event(mpv_event *event);

private Q_SLOTS:
    void doUpdate();
    void on_mpv_events();
};

#endif
