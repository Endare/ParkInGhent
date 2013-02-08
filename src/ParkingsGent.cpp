// Default empty project template
#include "ParkingsGent.hpp"

#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>
#include <bb/cascades/XmlDataModel>

#include <bb/system/SystemDialog>

#include <QtXml>

using namespace bb::cascades;

ParkingsGent::ParkingsGent(bb::cascades::Application *app)
: QObject(app)
{
    // create scene document from main.qml asset
    QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);
    // Expose this class to the QML code so we can call its functions from there
    qml->setContextProperty("app", this);
    AbstractPane *root = qml->createRootObject<AbstractPane>();

    // Retrieve the activity indicator and listview so we can configure them from the C++ code
    actIndicator = root->findChild<ActivityIndicator*>("indicator");
    listView = root->findChild<ListView*>("parkingListView");

    //Create and configure the network access manager for retrieving the data
    networkManager = new QNetworkAccessManager(this);
    bool result = connect(networkManager, SIGNAL(finished(QNetworkReply*)), this, SLOT(requestFinished(QNetworkReply*)));
    Q_ASSERT(result); // Check connection
    Q_UNUSED(result);

    // Create a file in the application's data directory
    file = new QFile("data/Parkings.xml");

    // set created root object as a scene
    app->setScene(root);
    initiateRequest();
}

void ParkingsGent::initiateRequest()
{
	qDebug() << "Initiating request";
	actIndicator->start();
	QNetworkRequest request = QNetworkRequest();
	request.setUrl(QUrl("http://datatank.gent.be/Mobiliteitsbedrijf/Parkings.xml"));
    networkManager->get(request);
}

void ParkingsGent::requestFinished(QNetworkReply* reply)
{
	qDebug() << "Request was finished";
	// Check the network reply for errors
	if (reply->error() == QNetworkReply::NoError)
	{
		// Open the file and print an error if the file cannot be opened
		if (!file->open(QIODevice::WriteOnly | QIODevice::Text))
		{
			qDebug() << "\n Failed to open file";
			return;
		}

		// Write to the file using the reply data and close the file
		QString xml(reply->readAll());
		cleanUpAndSaveXML(xml);

		// Create the data model using the contents of the file. The
		// location of the file is relative to the assets directory.
		XmlDataModel *dataModel = new XmlDataModel();
		dataModel->setSource(QUrl("file://" + QDir::homePath() + "/Parkings.xml"));

		// Set the new data model on the list
		listView->setDataModel(dataModel);

	}
	else
	{
		qDebug() << "\n Problem with the network";
		qDebug() << "\n" << reply->errorString();
		bb::system::SystemDialog* errorDialog = new bb::system::SystemDialog(tr("OK"));
		errorDialog->setTitle(tr("Netwerkfout"));
		errorDialog->setBody(tr("Er is een fout opgetreden tijdens het ophalen van de parkingdata. Probeer het later opnieuw.") + QString("\n(") + reply->errorString() + QString(")"));
		errorDialog->show();
	}
	actIndicator->stop();
}

void ParkingsGent::cleanUpAndSaveXML(QString xml)
{
	//Clean up so the XmlDataModel can work with this data
	xml.replace(QRegExp("<.xml[^>]*>"), QString(""));
	xml.replace(QRegExp("<Parkings [^>]*>"), QString("<root>"));
	xml.replace("</Parkings>", "</root>", Qt::CaseSensitive);
	xml.replace(QRegExp("<activeRoute>[^<]*</activeRoute>"), QString(""));
	//Add the image information
	QDomDocument doc;
	doc.setContent(xml);
	QDomNodeList children = doc.documentElement().childNodes();
	for(int i = 0; i < children.count(); i++)
	{
		QDomElement child = children.at(i).toElement();
		int availableCapacity = child.attribute(QString("availableCapacity"), QString("0")).toInt();
		child.setAttribute(QString("statusImage"), getStatusImage(availableCapacity));
		int open = child.attribute(QString("open"), QString("0")).toInt();
		QString isOpen = (open == 1 ? tr("Ja") : tr("Neen"));
		child.setAttribute(QString("open"), isOpen);
		//Remove break tags from address (Label doesn't handle this properly)
		QString address = child.attribute(QString("address"), "-");
		address.replace(QString(","), QString(""));
		address.replace(QString("<br>"), QString("\n"));
		address.replace(QString("<br/>"), QString("\n"));
		child.setAttribute(QString("address"), address);
	}
	xml = doc.toString();
	//Write to file
	file->write(xml.toAscii().data());
	file->flush();
	file->close();
}

QString ParkingsGent::getStatusImage(int availableCapacity)
{
	QString path("asset:///images/");
	if(availableCapacity <= 0)
	{
		path = path + tr("vol");
	}
	else if(availableCapacity <= 99)
	{
		path = path + QString::number(availableCapacity);
	}
	else
	{
		path = path + tr("vrij");
	}
	return path + QString(".png");
}
