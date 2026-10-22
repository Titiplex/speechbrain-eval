from flask import abort, request
from sqlalchemy import MetaData, Table

from flexeval.core import AdminModule
from flexeval.database import db

from .src.statistics import numeric_summary


def summarize_source(source):
    table = Table(
        source["table"],
        MetaData(),
        autoload_with=db.engine,
    )

    query = db.session.query(table.c[source["column"]])

    if source.get("exclude_intro", True):
        query = query.filter(table.c["intro"].is_(False))

    return numeric_summary([row[0] for row in query.all()])


with AdminModule(__name__) as am:

    @am.route("/")
    @am.connection_required
    def index():
        reports = am.get_config().get("reports", {})

        report_id = request.args.get(
            "report",
            next(iter(reports), None),
        )

        if report_id not in reports:
            abort(404)

        report = reports[report_id]

        results = {
            source_id: summarize_source(source)
            for source_id, source in report["sources"].items()
        }

        navigation = [
            {"id": key, "title": value["title"]}
            for key, value in reports.items()
        ]

        return am.render_template(
            report["template"],
            report_title=report["title"],
            report_id=report_id,
            navigation=navigation,
            results=results,
        )