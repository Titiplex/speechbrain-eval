{% extends get_template('base.tpl','flexeval') %}
{% block content %}
{% include get_template('_navigation.tpl','mod/stats') %}
<h2>{{ get_variable('report_title') }}</h2>
<p>Informations déclaratives. La compréhension avec nouvel essai est gérée
    par le navigateur : les tentatives ne constituent pas une mesure
    infalsifiable.</p>
{% for title,s in get_variable('results').items() %}
<h3 class="h5">{{ title }}</h3>
<table class="table">
    <thead>
    <tr>
        <th>Participant</th>
        <th>Informations</th>
    </tr>
    </thead>
    <tbody>
    {% for user,p in s.participants.items() %}
    <tr>
        <td>{{ user }}</td>
        <td>{{ p }}</td>
    </tr>
    {% endfor %}
    </tbody>
</table>
{% endfor %}
{% endblock %}
