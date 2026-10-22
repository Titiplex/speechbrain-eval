{% extends get_template('base.tpl', 'flexeval') %}

{% block content %}

{% include get_template('_navigation.tpl', 'mod/stats') %}

<h2>{{ get_variable("report_title") }}</h2>

{% set results = get_variable("results") %}

<table class="table">
    <thead>
    <tr>
        <th>Méthode</th>
        <th>Nombre de notes</th>
        <th>Moyenne</th>
        <th>Écart-type</th>
    </tr>
    </thead>

    <tbody>
    {% for name, stats in results.items() %}
    <tr>
        <td>{{ name }}</td>
        <td>{{ stats["n"] }}</td>
        <td>
            {{ "%.2f"|format(stats["mean"])
            if stats["mean"] is not none else "—" }}
        </td>
        <td>
            {{ "%.2f"|format(stats["std"])
            if stats["std"] is not none else "—" }}
        </td>
    </tr>
    {% endfor %}
    </tbody>
</table>

{% endblock %}