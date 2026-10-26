from flask import abort, request
from sqlalchemy import MetaData, Table, inspect

from flexeval.core import AdminModule
from flexeval.database import db

from .src.statistics import numeric_summary, control_summary
from .src.analysis import numeric, categorical, quality, paired


def summarize_source(source):
    kind = source.get("type", "numeric")
    empty = {"participants": {}} if kind in ("control", "quality", "profile") else numeric([] , "") if kind == "numeric" else categorical([], kind)
    if source["table"] not in inspect(db.engine).get_table_names():
        return dict(empty, message="Aucune réponse enregistrée pour ce test.")
    table = Table(source["table"], MetaData(), autoload_with=db.engine)
    query = db.session.query(table)
    if source.get("exclude_intro", True) and "intro" in table.c:
        query = query.filter(table.c["intro"].is_(False))
    rows = [dict(zip(table.c.keys(), row)) for row in query.all()]
    if source.get("role"):
        rows = [row for row in rows if row.get("protocol_role") == source["role"]]
    if kind == "profile":
        return {"participants": {row["user_pseudo"]: row for row in rows}}
    if kind == "control":
        return control_summary(rows, source["expected"])
    if kind == "quality":
        return quality(rows, source["protocol"])
    if kind in ("ab", "abx"):
        return categorical(rows, kind)
    result = numeric(rows, source["column"])
    result["paired"] = paired(rows, source["compare"]) if source.get("compare") else None
    return result



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