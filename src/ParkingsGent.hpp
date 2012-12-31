// Default empty project template
#ifndef ParkingsGent_HPP_
#define ParkingsGent_HPP_

#include <QObject>
#include <QFile>

#include <bb/cascades/ActivityIndicator>
#include <bb/cascades/ListView>

using namespace bb::cascades;
namespace bb { namespace cascades { class Application; }}

/*!
 * @brief Application pane object
 *
 *Use this object to create and init app UI, to create context objects, to register the new meta types etc.
 */
class ParkingsGent : public QObject
{
    Q_OBJECT
public:
    ParkingsGent(bb::cascades::Application *app);
    Q_INVOKABLE void initiateRequest();

private slots:
	void requestFinished(QNetworkReply* reply);

private:
	void cleanUpAndSaveXML(QString xml);
	QString getStatusImage(int availableCapacity);
	ActivityIndicator* actIndicator;
	ListView* listView;
	QNetworkAccessManager* networkManager;
	QFile* file;
};


#endif /* ParkingsGent_HPP_ */
