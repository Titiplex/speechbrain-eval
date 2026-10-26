from flask import abort, request
from sqlalchemy import MetaData, Table, inspect

from flexeval.core import AdminModule
from flexeval.database import db

from .src.statistics import numeric_summary, control_summary


def summarize_source(source):
    # Native test tables/columns may not exist before the first response.
    empty = {"participants": {}} if source.get("type") == "control" else numeric_summary([])

    if source["table"] not in inspect(db.engine).get_table_names():
        return dict(empty, message="No answer registered for this test.")

    table = Table(source["table"], MetaData(), autoload_with=db.engine)
    required = list(source["expected"]) if source.get("type") == "control" else [source["column"]]

    if source.get("type") == "control":
        required.append("user_pseudo")

    missing = [name for name in required if name not in table.c]

    if missing:
        return dict(empty, message="Missing columns : " + ", ".join(missing))

    query = db.session.query(table)

    if source.get("exclude_intro", True):
        query = query.filter(table.c["intro"].is_(False))

    rows = [dict(zip(table.c.keys(), row)) for row in query.all()]

    if source.get("type") == "control":
        return control_summary(rows, source["expected"])

    return numeric_summary([row[source["column"]] for row in rows])



with AdminModule(__name__) as am:

    @am.route("/")
    @am.connection_required
    def index():
        reports = am.get_config().get("reports", {})
        report_id = request.args.get("report")

        menu_url = am.url_for(
            am.get_endpoint_for_local_rule("/")
        )

        navigation = [
            {
                "id": key,
                "title": report["title"],
                "description": report.get(
                    "description",
                    "See Results for this test"
                ),
                "url": am.url_for(
                    am.get_endpoint_for_local_rule("/"),
                    report=key,
                ),
            }
            for key, report in reports.items()
        ]

        if report_id is None:
            return am.render_template(
                "index.tpl",
                navigation=navigation,
            )

        if report_id not in reports:
            abort(404)

        report = reports[report_id]

        results = {
            source_id: summarize_source(source)
            for source_id, source in report["sources"].items()
        }

        return am.render_template(
            report["template"],
            report_title=report["title"],
            report_id=report_id,
            menu_url=menu_url,
            navigation=navigation,
            results=results,
        )