import QtQuick 2.0
import QtTest 1.0
import Ubuntu.Components 1.1
import "../../components"
import "../../udata"

// See more details @ http://qt-project.org/doc/qt-5.0/qtquick/qml-testcase.html

// Execute tests with:
//   qmltestrunner

Item {
    Database {
        id: database
        name: "taskly-testing"

        modelPath: Qt.resolvedUrl("../../model")
    }

    Query {
        id: query
        _db: database
        type: "Task"
    }

    TestCase {
        name: "Task"

        function init() {
            database.debug(">> init");
            database.open()
            database.clear()
            query.init()
            query.reload()
            compare(query.finishedLoading, true, "Query should load now")
            //compare("",d.text,"text was not empty on init");
            database.debug("<< init");
        }

        function cleanup() {
            database.debug(">> cleanup");
            database.debug("<< cleanup");
        }

        function initTestCase() {
            database.debug(">> initTestCase");
            database.debug("<< initTestCase");
        }

        function cleanupTestCase() {
            database.debug(">> cleanupTestCase");
            database.debug("<< cleanupTestCase");
        }

        function test_canCreateTask() {
            var expected = "Sample Task"

            var object = database.create('Task', {title: expected})

            compare(object.title, object.title, "expected did not equal result");
        }

        function test_taskSaves() {
            var expected = "Sample Task"

            var object = database.create('Task', {title: expected})

            var matching = database.loadById('Task', object._id)

            compare(matching.title, object.title, "expected did not equal result");
        }

        function test_queryUpdates() {
            var expected = "Sample Task"

            compare(query.count, 0, "Query is not empty")

            var object = database.create('Task', {title: expected})

            compare(query.count, 1, "expected did not equal result");

            compare(query.at(0).title, expected)

            object.title = "A new title"

            compare(query.at(0).title, object.title)

            object.remove()
            compare(query.count, 0, "Query is not empty")
        }

        function benchmark_once_createTask() {
            var object = database.create('Task', {title: "Benchmark task"})
            object.destroy()
        }
    }
}

